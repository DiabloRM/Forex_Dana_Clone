import '../models/instrument_quote.dart';

class MockMarketData {
  static List<InstrumentQuote> quotes() => [
        InstrumentQuote(
          name: 'XAUUSD',
          category: 'metals',
          buyPrice: 3332.19,
          sellPrice: 3332.04,
          change: -4.00,
          percent: -0.12,
          isUp: false,
          showFire: true,
        ),
        InstrumentQuote(
          name: 'BTC/USDT',
          category: 'crypto',
          buyPrice: 116456.10,
          sellPrice: 116446.00,
          change: -1101.10,
          percent: -0.937,
          isUp: false,
          showFire: true,
        ),
        InstrumentQuote(
          name: 'ETH/USDT',
          category: 'crypto',
          buyPrice: 4358.19,
          sellPrice: 4357.23,
          change: -108.21,
          percent: -2.424,
          isUp: false,
          showFire: true,
        ),
        InstrumentQuote(
          name: 'SOL/USDT',
          category: 'crypto',
          buyPrice: 184.049,
          sellPrice: 183.990,
          change: -7.060,
          percent: -3.696,
          isUp: false,
          showFire: true,
        ),
        InstrumentQuote(
          name: 'EUR/USD',
          category: 'forex',
          buyPrice: 1.0845,
          sellPrice: 1.0843,
          change: 0.002,
          percent: 0.18,
          isUp: true,
        ),
        InstrumentQuote(
          name: 'GBP/USD',
          category: 'forex',
          buyPrice: 1.2675,
          sellPrice: 1.2672,
          change: -0.005,
          percent: -0.39,
          isUp: false,
        ),
      ];
}
