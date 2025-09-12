class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;
  final int timestamp; // ms since epoch

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.timestamp,
  });

  factory CandleData.fromTwelve(List<dynamic> k) {
    // TwelveData time_series returns objects; their websocket might be arrays.
    // For REST OHLCV, we will parse map instead (see service), this covers array shape if used.
    final int ts = (k[0] as num).toInt();
    return CandleData(
      open: (k[1] as num).toDouble(),
      high: (k[2] as num).toDouble(),
      low: (k[3] as num).toDouble(),
      close: (k[4] as num).toDouble(),
      volume: (k[5] as num).toDouble(),
      timestamp: ts,
    );
  }

  int get time => timestamp;
  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(timestamp);
}
