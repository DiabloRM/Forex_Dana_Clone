import 'dart:math';
import '../models/candle_data.dart';
import '../models/ticker_data.dart';

/// Utilities to generate rich, repeatable mock data sets for the trading screen.
class MockTradingSets {
  /// Generate candles using a simple random walk with controlled volatility.
  static List<CandleData> generateCandles({
    required int count,
    required Duration step,
    double base = 1.0840,
    double volatility = 0.0008,
    int seed = 42,
  }) {
    final rnd = Random(seed);
    final List<CandleData> out = [];
    final int start =
        DateTime.now().subtract(step * count).millisecondsSinceEpoch;
    double lastClose = base;

    for (int i = 0; i < count; i++) {
      // Random direction and magnitude
      final double drift = (rnd.nextDouble() - 0.5) * volatility;
      final open = lastClose;
      final close = (open + drift).clamp(base * 0.7, base * 1.3);
      final high = max(open, close) + rnd.nextDouble() * volatility * 0.8;
      final low = min(open, close) - rnd.nextDouble() * volatility * 0.8;

      out.add(CandleData(
        open: open,
        high: high,
        low: low,
        close: close,
        volume: (800 + rnd.nextInt(1200)).toDouble(),
        timestamp: start + i * step.inMilliseconds,
      ));

      lastClose = close;
    }
    return out;
  }

  /// Produce a ticker snapshot derived from a candle series.
  static TickerData tickerFromCandles(String symbol, List<CandleData> candles) {
    if (candles.isEmpty) {
      return TickerData(
        symbol: symbol,
        lastPrice: 0,
        priceChange: 0,
        priceChangePercent: 0,
        highPrice: 0,
        lowPrice: 0,
        volume: 0,
      );
    }

    final last = candles.last.close;
    final prev = candles.length > 1 ? candles[candles.length - 2].close : last;
    final high = candles.map((c) => c.high).reduce(max).toDouble();
    final low = candles.map((c) => c.low).reduce(min).toDouble();
    final change = last - prev;
    final changePct = prev == 0 ? 0.0 : ((change / prev) * 100.0);
    final vol = candles.fold<double>(0.0, (a, c) => a + c.volume);

    return TickerData(
      symbol: symbol,
      lastPrice: last,
      priceChange: change,
      priceChangePercent: changePct,
      highPrice: high,
      lowPrice: low,
      volume: vol,
    );
  }

  /// Handy presets by symbol to quickly mock different instruments.
  static List<CandleData> preset(String symbol, String interval,
      {int count = 120}) {
    final step = _intervalToStep(interval);
    switch (symbol) {
      case 'EUR/USD':
        return generateCandles(
            count: count, step: step, base: 1.082, volatility: 0.0012);
      case 'BTC/USDT':
        return generateCandles(
            count: count, step: step, base: 61000, volatility: 450.0);
      case 'XAU/USD': // Gold
        return generateCandles(
            count: count, step: step, base: 2380, volatility: 6.0);
      default:
        return generateCandles(
            count: count, step: step, base: 1.100, volatility: 0.0010);
    }
  }

  static Duration _intervalToStep(String interval) {
    switch (interval) {
      case '1min':
        return const Duration(minutes: 1);
      case '5min':
        return const Duration(minutes: 5);
      case '15min':
        return const Duration(minutes: 15);
      case '30min':
        return const Duration(minutes: 30);
      case '1h':
        return const Duration(hours: 1);
      default:
        return const Duration(minutes: 5);
    }
  }
}
