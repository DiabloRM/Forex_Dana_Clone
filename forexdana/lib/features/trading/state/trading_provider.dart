import 'package:flutter/foundation.dart';
import '../../../core/models/candle_data.dart';
import '../../../core/models/ticker_data.dart';
import '../../../core/network/api_client.dart';
import '../../../core/mock/mock_trading_sets.dart';

class TradingProvider extends ChangeNotifier {
  final ApiClient _client;
  TradingProvider(this._client, {this.mockOnly = false});

  final bool mockOnly;

  List<CandleData> candles = [];
  TickerData? ticker;
  bool loading = false;
  String? error;

  List<double> ma5 = [];
  List<double> ma10 = [];
  List<double> ma30 = [];
  List<double> macd = [];
  List<double> signal = [];
  List<double> hist = [];

  Future<void> loadAll(
      {required String symbol, required String interval}) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      if (mockOnly) {
        await loadMock(symbol: symbol, interval: interval);
      } else {
        final results = await Future.wait([
          _fetchTimeSeries(symbol: symbol, interval: interval, outputSize: 300),
          _fetchQuote(symbol: symbol),
        ]);
        candles = results[0] as List<CandleData>;
        ticker = results[1] as TickerData;
        _computeMAs();
        _computeMACD();
      }
    } catch (e) {
      error = e.toString();
      if (kDebugMode) {
        print('TradingProvider error: $e');
      }
      // Fallback to mock data when API fails
      try {
        await loadMock(symbol: symbol, interval: interval);
      } catch (mockError) {
        error = 'Failed to load data: $e\nFallback also failed: $mockError';
      }
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMock(
      {required String symbol, required String interval}) async {
    candles = MockTradingSets.preset(symbol, interval, count: 180);
    ticker = MockTradingSets.tickerFromCandles(symbol, candles);
    _computeMAs();
    _computeMACD();
  }

  Future<List<CandleData>> _fetchTimeSeries({
    required String symbol,
    required String interval,
    int outputSize = 300,
  }) async {
    // TwelveData time_series: returns { values: [ {datetime, open, high, low, close, volume}, ... ] }
    final res = await _client.get('/time_series', query: {
      'symbol': symbol, // e.g., EUR/USD
      'interval': interval, // e.g., 5min, 15min, 1h, 1day
      'outputsize': outputSize,
      'format': 'JSON',
    });
    final map = res.data as Map<String, dynamic>;
    final values = (map['values'] as List).cast<Map<String, dynamic>>();
    // API returns latest first; reverse to chronological order
    final reversed = values.reversed.toList();
    return reversed.map((v) {
      final dt = DateTime.parse(v['datetime'] as String).millisecondsSinceEpoch;
      return CandleData(
        open: double.parse(v['open'] as String),
        high: double.parse(v['high'] as String),
        low: double.parse(v['low'] as String),
        close: double.parse(v['close'] as String),
        volume: double.tryParse((v['volume'] ?? '0').toString()) ?? 0,
        timestamp: dt,
      );
    }).toList();
  }

  Future<TickerData> _fetchQuote({required String symbol}) async {
    try {
      // TwelveData quote: /quote?symbol=EUR/USD
      final res = await _client.get('/quote', query: {
        'symbol': symbol,
      });
      final d = res.data as Map<String, dynamic>;

      // Check for API errors
      if (d['status'] == 'error') {
        throw Exception('API Error: ${d['message']}');
      }

      // Use close price if price is not available (for consistency with time series)
      final lastPrice =
          double.tryParse((d['close'] ?? d['price'] ?? '0').toString()) ?? 0;
      if (lastPrice <= 0) {
        throw Exception('Invalid price data received');
      }

      // Fields: price, percent_change, change, high, low, volume
      return TickerData(
        symbol: d['symbol'] as String? ?? symbol,
        lastPrice: lastPrice,
        priceChange: double.tryParse((d['change'] ?? '0').toString()) ?? 0,
        priceChangePercent:
            double.tryParse((d['percent_change'] ?? '0').toString()) ?? 0,
        highPrice: double.tryParse((d['high'] ?? '0').toString()) ?? 0,
        lowPrice: double.tryParse((d['low'] ?? '0').toString()) ?? 0,
        volume: double.tryParse((d['volume'] ?? '0').toString()) ?? 0,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Quote fetch error: $e');
      }
      rethrow;
    }
  }

  void _computeMAs() {
    final closes = candles.map((c) => c.close).toList();
    ma5 = _sma(closes, 5);
    ma10 = _sma(closes, 10);
    ma30 = _sma(closes, 30);
  }

  void _computeMACD() {
    final closes = candles.map((c) => c.close).toList();
    final ema12 = _ema(closes, 12);
    final ema26 = _ema(closes, 26);
    macd = List.generate(closes.length, (i) => ema12[i] - ema26[i]);
    signal = _ema(macd, 9);
    hist = List.generate(closes.length, (i) => macd[i] - signal[i]);
  }

  List<double> _sma(List<double> vals, int period) {
    if (vals.isEmpty) return [];
    final out = List<double>.filled(vals.length, double.nan);
    double sum = 0;
    for (int i = 0; i < vals.length; i++) {
      sum += vals[i];
      if (i >= period) sum -= vals[i - period];
      if (i >= period - 1) out[i] = sum / period;
    }
    return out;
  }

  List<double> _ema(List<double> vals, int period) {
    if (vals.isEmpty) return [];
    final k = 2 / (period + 1);
    final out = List<double>.filled(vals.length, double.nan);
    double prev = vals.first;
    out[0] = prev;
    for (int i = 1; i < vals.length; i++) {
      final ema = vals[i] * k + prev * (1 - k);
      out[i] = ema;
      prev = ema;
    }
    return out;
  }
}
