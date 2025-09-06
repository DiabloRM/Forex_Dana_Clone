import '../models/candle_data.dart';
import '../models/ticker_data.dart';

class MockTradingData {
  static List<CandleData> candles() {
    final List<CandleData> out = [];
    int ts = DateTime.now().millisecondsSinceEpoch - 60 * 1000 * 25;
    double base = 1.0840;
    for (int i = 0; i < 30; i++) {
      final open = base + (i % 3 - 1) * 0.0005;
      final high = open + 0.0010;
      final low = open - 0.0010;
      final close = open + ((i % 2 == 0) ? 0.0004 : -0.0003);
      out.add(CandleData(
        open: open,
        high: high,
        low: low,
        close: close,
        volume: 1000 + i * 10,
        timestamp: ts + i * 60 * 1000,
      ));
    }
    return out;
  }

  static TickerData ticker(String symbol) => TickerData(
        symbol: symbol,
        lastPrice: 1.0845,
        priceChange: 0.0020,
        priceChangePercent: 0.18,
        highPrice: 1.0860,
        lowPrice: 1.0820,
        volume: 123456,
      );
}
