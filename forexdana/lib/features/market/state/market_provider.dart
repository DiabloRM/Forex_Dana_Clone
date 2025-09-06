import 'package:flutter/foundation.dart';
import 'dart:async';
import '../../../core/network/api_client.dart';
import '../../../core/network/binance_client.dart';
import '../../../core/models/instrument_quote.dart';
import '../../../core/mock/mock_market_data.dart';

class MarketProvider extends ChangeNotifier {
  final ApiClient twelve;
  final BinanceClient binance;
  MarketProvider(this.twelve, this.binance);

  bool loading = false;
  String? error;
  List<InstrumentQuote> quotes = [];

  // Auto-refresh functionality
  Timer? _refreshTimer;
  bool _autoRefreshEnabled = true;
  static const Duration _refreshInterval =
      Duration(minutes: 1); // Refresh every minute

  bool _disposed = false;
  void _safeNotify() {
    if (_disposed) return;
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _refreshTimer?.cancel();
    super.dispose();
  }

  // Configure which instruments to show and where they come from
  final List<Map<String, String>> instruments = [
    // Forex Pairs (Major)
    {'name': 'EUR/USD', 'category': 'forex', 'source': 'twelve'},
    {'name': 'GBP/USD', 'category': 'forex', 'source': 'twelve'},
    {'name': 'USD/JPY', 'category': 'forex', 'source': 'twelve'},
    {'name': 'USD/CHF', 'category': 'forex', 'source': 'twelve'},
    {'name': 'AUD/USD', 'category': 'forex', 'source': 'twelve'},

    // Metals (Precious) - 2 instruments
    {'name': 'XAU/USD', 'category': 'metals', 'source': 'twelve'},
    {'name': 'XAG/USD', 'category': 'metals', 'source': 'twelve'},

    // Stocks (Major US) - 2 instruments
    {'name': 'AAPL', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'NVDA', 'category': 'stocks', 'source': 'twelve'},

    // Crypto (Major) - 4 instruments
    {'name': 'BTC/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'ETH/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'BNB/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'SOL/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'ADA/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'XRP/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'DOT/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'MATIC/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'LINK/USDT', 'category': 'crypto', 'source': 'binance'},
    {'name': 'UNI/USDT', 'category': 'crypto', 'source': 'binance'},

    // Stocks (Major US)
    {'name': 'AAPL', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'MSFT', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'GOOGL', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'AMZN', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'TSLA', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'META', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'NVDA', 'category': 'stocks', 'source': 'twelve'},
    {'name': 'NFLX', 'category': 'stocks', 'source': 'twelve'},
  ];

  Future<void> load() async {
    loading = true;
    error = null;
    _safeNotify();
    try {
      final List<InstrumentQuote> out = [];
      // TwelveData batch by iterating (free tier doesn't support big batch easily)
      final twelveDataInstruments =
          instruments.where((e) => e['source'] == 'twelve').toList();

      if (kDebugMode) {
        print(
            'Fetching TwelveData instruments: ${twelveDataInstruments.map((e) => e['name']).toList()}');
      }

      // Process instruments in batches to respect rate limits
      for (int i = 0; i < twelveDataInstruments.length; i++) {
        final m = twelveDataInstruments[i];
        final sym = m['name']!; // e.g., EUR/USD or XAUUSD

        try {
          if (kDebugMode) {
            print(
                'Fetching TwelveData quote for: $sym (${i + 1}/${twelveDataInstruments.length})');
          }

          final res = await twelve.get('/quote', query: {'symbol': sym});
          final d = res.data as Map<String, dynamic>;

          if (kDebugMode) {
            print('TwelveData response for $sym: $d');
          }

          // Check for API errors
          if (d['status'] == 'error') {
            throw Exception('API Error: ${d['message']}');
          }

          // Use the enhanced factory constructor
          final quote = InstrumentQuote.fromTwelveData(d, m['category']!);
          out.add(quote);

          if (kDebugMode) {
            print('Successfully added TwelveData: $sym (${m['category']})');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching $sym: $e');
            print('Stack trace: ${StackTrace.current}');
          }
          // Continue with other instruments instead of failing completely
          continue;
        }
      }

      // Binance for crypto
      final cryptoSymbols = instruments
          .where((e) => e['source'] == 'binance')
          .map((e) => e['name']!.replaceAll('/', ''))
          .toList();

      if (kDebugMode) {
        print('Fetching crypto symbols: $cryptoSymbols');
      }

      // Try to fetch crypto data with retry mechanism
      for (final s in cryptoSymbols) {
        try {
          if (kDebugMode) {
            print('Fetching crypto data for: $s');
          }

          // Add timeout and retry for network issues
          final res = await binance
              .fetch24hTickers([s]).timeout(const Duration(seconds: 10));
          final d = res.first as Map<String, dynamic>;

          if (kDebugMode) {
            print('Crypto response for $s: $d');
          }

          final last = double.parse(d['lastPrice']);
          final change = double.parse(d['priceChange']);
          final percent = double.parse(d['priceChangePercent']);

          // Use last for both buy/sell for simplicity (no level2 book here)
          final original = instruments
              .firstWhere((e) => e['name']!.replaceAll('/', '') == s);

          // Create enhanced crypto quote with additional data
          out.add(InstrumentQuote(
            name: original['name']!,
            category: original['category']!,
            buyPrice: last,
            sellPrice: last,
            change: change,
            percent: percent,
            isUp: change >= 0,
            showFire: true,
            // Add crypto-specific data
            close: last,
            high: double.tryParse(d['highPrice'] ?? '0'),
            low: double.tryParse(d['lowPrice'] ?? '0'),
            exchange: 'Binance',
            datetime: DateTime.now().toIso8601String(),
          ));

          if (kDebugMode) {
            print('Successfully added crypto: ${original['name']}');
          }
        } catch (e) {
          if (kDebugMode) {
            print('Error fetching crypto $s: $e');
            print('Stack trace: ${StackTrace.current}');

            // Check if it's a network/DNS issue
            if (e.toString().contains('Failed host lookup') ||
                e.toString().contains('connection error')) {
              print(
                  'Network/DNS issue detected. This might be a simulator/emulator limitation.');
              print(
                  'Crypto data will not be available until network connectivity is restored.');
            }
          }
          // Continue with other instruments
          continue;
        }
      }

      quotes = out;

      // Debug: Loaded instruments successfully

      // If we have very few instruments due to API limits, add mock data for development
      if (quotes.length < 10 && kDebugMode) {
        // API rate limits hit, adding mock data for development
        final mockQuotes = MockMarketData.quotes();
        quotes.addAll(mockQuotes);
      }

      // Start auto-refresh after successful load
      startAutoRefresh();
    } catch (e) {
      error = e.toString();
      // Fallback to mock data if network fails
      quotes = MockMarketData.quotes();
    } finally {
      loading = false;
      _safeNotify();
    }
  }

  // Auto-refresh methods
  void startAutoRefresh() {
    if (_autoRefreshEnabled && _refreshTimer == null) {
      _refreshTimer = Timer.periodic(_refreshInterval, (_) {
        if (!_disposed && !loading) {
          load();
        }
      });
    }
  }

  void stopAutoRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  void toggleAutoRefresh() {
    if (_autoRefreshEnabled) {
      stopAutoRefresh();
      _autoRefreshEnabled = false;
    } else {
      _autoRefreshEnabled = true;
      startAutoRefresh();
    }
    _safeNotify();
  }

  bool get isAutoRefreshEnabled => _autoRefreshEnabled;
}
