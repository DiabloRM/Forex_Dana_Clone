class InstrumentQuote {
  final String name; // display symbol, e.g., EUR/USD or BTC/USDT or XAUUSD
  final String category; // forex | crypto | metals
  final double buyPrice; // usually ask/bestAsk
  final double sellPrice; // usually bid/bestBid
  final double change; // absolute change over 24h or session
  final double percent; // percent change
  final bool isUp;
  final bool showFire;

  // Additional fields for enhanced market data
  final double? open;
  final double? high;
  final double? low;
  final double? close;
  final bool? isMarketOpen;
  final String? exchange;
  final String? datetime;
  final Map<String, dynamic>? fiftyTwoWeek;

  InstrumentQuote({
    required this.name,
    required this.category,
    required this.buyPrice,
    required this.sellPrice,
    required this.change,
    required this.percent,
    required this.isUp,
    this.showFire = false,
    this.open,
    this.high,
    this.low,
    this.close,
    this.isMarketOpen,
    this.exchange,
    this.datetime,
    this.fiftyTwoWeek,
  });

  // Factory constructor for creating from API data
  factory InstrumentQuote.fromTwelveData(
      Map<String, dynamic> data, String category) {
    final close = _parseDouble(data['close']);
    final change = _parseDouble(data['change']);
    final percent = _parseDouble(data['percent_change']);

    // Calculate bid/ask with spread simulation
    final spread = (close ?? 0) * 0.0001; // 1 pip spread for forex
    final bid = close ?? 0;
    final ask = (close ?? 0) + spread;

    return InstrumentQuote(
      name: data['symbol'] ?? '',
      category: category,
      buyPrice: ask,
      sellPrice: bid,
      change: change ?? 0,
      percent: percent ?? 0,
      isUp: (change ?? 0) >= 0,
      showFire: false,
      open: _parseDouble(data['open']),
      high: _parseDouble(data['high']),
      low: _parseDouble(data['low']),
      close: close,
      isMarketOpen: data['is_market_open'],
      exchange: data['exchange'],
      datetime: data['datetime'],
      fiftyTwoWeek: data['fifty_two_week'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  // Get formatted change string
  String get changeFormatted {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(5)}';
  }

  // Get formatted percent string
  String get percentFormatted {
    final sign = percent >= 0 ? '+' : '';
    return '$sign${percent.toStringAsFixed(2)}%';
  }

  // Get price range (high - low)
  double? get priceRange {
    if (high != null && low != null) {
      return high! - low!;
    }
    return null;
  }

  // Get volatility as percentage
  double? get volatility {
    if (close != null && low != null) {
      return ((close! - low!) / low!) * 100;
    }
    return null;
  }
}
