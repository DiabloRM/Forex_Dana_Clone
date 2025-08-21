import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trading App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: TradingScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class TradingScreen extends StatefulWidget {
  @override
  _TradingScreenState createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  String selectedTimeframe = '5M';
  List<String> timeframes = ['1M', '5M', '15M', '30M', '1H', 'More'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
            Text(
              'BTC/USDT',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.black),
            SizedBox(width: 8),
            Icon(Icons.help_outline, color: Colors.grey, size: 20),
          ],
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade600,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Demo',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        ],
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          // Price Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '113190.10',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            '-0.998%',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '-1140.80',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.notifications_none,
                            size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Icon(Icons.star_border, size: 20, color: Colors.grey),
                        SizedBox(width: 8),
                        Icon(Icons.share_outlined,
                            size: 20, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'H: 114776.90',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                        Text(
                          'L: 112902.50',
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Timeframe Selector
          Container(
            height: 40,
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: timeframes.length,
              itemBuilder: (context, index) {
                String timeframe = timeframes[index];
                bool isSelected = timeframe == selectedTimeframe;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTimeframe = timeframe;
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: 16),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? Border(
                              bottom:
                                  BorderSide(color: Colors.orange, width: 2))
                          : null,
                    ),
                    child: Text(
                      timeframe,
                      style: TextStyle(
                        color: isSelected ? Colors.orange : Colors.grey,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Indicators Row - Fixed overflow
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Indicator',
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                      Icon(Icons.keyboard_arrow_down,
                          color: Colors.orange, size: 16),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildIndicatorText(
                            'MA5', '113102.48', Colors.purple.shade300),
                        SizedBox(width: 12),
                        _buildIndicatorText(
                            'MA10', '113126.06', Colors.blue.shade300),
                        SizedBox(width: 12),
                        _buildIndicatorText(
                            'MA30', '113223.73', Colors.orange.shade300),
                        SizedBox(width: 12),
                        Text(
                          '113564.82',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Chart Area - Improved
          Expanded(
            child: Container(
              margin: EdgeInsets.all(16),
              child: CandlestickChart(),
            ),
          ),

          // MACD Indicator - Improved
          Container(
            height: 100,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: MacdChart(),
          ),

          // Time labels
          Container(
            height: 30,
            margin: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('16:10',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('16:50',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('17:30',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('18:10',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text('18:50',
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
              ],
            ),
          ),

          // Bottom Action Buttons
          Container(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.list_alt, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('Position',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey),
                      SizedBox(height: 4),
                      Text('Pending...',
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Buy',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Text('113200.20',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    height: 48,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Sell',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                          Text('113190.10',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicatorText(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '$label ',
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(color: color, fontSize: 12),
        ),
      ],
    );
  }
}

class CandlestickChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Price labels on the right
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: 70,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('113391.36',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('113200.20',
                    style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('113190.10',
                    style: TextStyle(fontSize: 10, color: Colors.white)),
              ),
              Text('113044.42',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('112902.5',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
              Text('112870.96',
                  style: TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ),
        ),
        // Candlestick chart
        Padding(
          padding: EdgeInsets.only(right: 80),
          child: CustomPaint(
            size: Size.infinite,
            painter: CandlestickPainter(),
          ),
        ),
      ],
    );
  }
}

class CandlestickPainter extends CustomPainter {
  // Realistic Bitcoin price data simulation
  final List<CandleData> candleData = [
    CandleData(113800, 113900, 113750, 113850),
    CandleData(113850, 113950, 113800, 113920),
    CandleData(113920, 113980, 113850, 113900),
    CandleData(113900, 113950, 113820, 113880),
    CandleData(113880, 113920, 113780, 113800),
    CandleData(113800, 113850, 113720, 113750),
    CandleData(113750, 113800, 113650, 113700),
    CandleData(113700, 113750, 113600, 113650),
    CandleData(113650, 113700, 113580, 113620),
    CandleData(113620, 113680, 113550, 113600),
    CandleData(113600, 113650, 113520, 113580),
    CandleData(113580, 113620, 113480, 113520),
    CandleData(113520, 113570, 113450, 113500),
    CandleData(113500, 113550, 113420, 113480),
    CandleData(113480, 113520, 113400, 113450),
    CandleData(113450, 113500, 113380, 113420),
    CandleData(113420, 113470, 113350, 113400),
    CandleData(113400, 113450, 113320, 113380),
    CandleData(113380, 113420, 113300, 113350),
    CandleData(113350, 113400, 113280, 113320),
    CandleData(113320, 113370, 113250, 113300),
    CandleData(113300, 113350, 113220, 113280),
    CandleData(113280, 113320, 113200, 113250),
    CandleData(113250, 113300, 113180, 113220),
    CandleData(113220, 113270, 113160, 113200),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;

    // Calculate price range for scaling
    double minPrice = 113000;
    double maxPrice = 114000;
    double priceRange = maxPrice - minPrice;

    // Draw horizontal grid lines
    paint.color = Colors.grey.shade200;
    for (int i = 0; i <= 10; i++) {
      double y = size.height * i / 10;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw vertical grid lines
    for (int i = 0; i <= 5; i++) {
      double x = size.width * i / 5;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw candlesticks
    double candleWidth = size.width / candleData.length;

    for (int i = 0; i < candleData.length; i++) {
      double x = i * candleWidth + candleWidth / 2;
      CandleData candle = candleData[i];

      // Scale prices to canvas coordinates
      double highY = size.height * (1 - (candle.high - minPrice) / priceRange);
      double lowY = size.height * (1 - (candle.low - minPrice) / priceRange);
      double openY = size.height * (1 - (candle.open - minPrice) / priceRange);
      double closeY =
          size.height * (1 - (candle.close - minPrice) / priceRange);

      bool isBullish = candle.close > candle.open;
      Color candleColor = isBullish ? Colors.green : Colors.red;

      // Draw wick
      paint.color = candleColor;
      paint.strokeWidth = 1;
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      // Draw body
      double bodyTop = isBullish ? closeY : openY;
      double bodyBottom = isBullish ? openY : closeY;
      double bodyWidth = candleWidth * 0.6;

      Rect candleBody = Rect.fromLTRB(
          x - bodyWidth / 2, bodyTop, x + bodyWidth / 2, bodyBottom);

      if (isBullish) {
        paint.style = PaintingStyle.stroke;
        paint.strokeWidth = 1;
      } else {
        paint.style = PaintingStyle.fill;
      }

      canvas.drawRect(candleBody, paint);
    }

    // Draw moving averages
    _drawMovingAverage(canvas, size, Colors.purple.shade300, 5);
    _drawMovingAverage(canvas, size, Colors.blue.shade300, 10);
    _drawMovingAverage(canvas, size, Colors.orange.shade300, 30);
  }

  void _drawMovingAverage(Canvas canvas, Size size, Color color, int period) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    Path path = Path();
    double minPrice = 113000;
    double maxPrice = 114000;
    double priceRange = maxPrice - minPrice;
    double candleWidth = size.width / candleData.length;

    for (int i = period - 1; i < candleData.length; i++) {
      double sum = 0;
      for (int j = 0; j < period; j++) {
        sum += candleData[i - j].close;
      }
      double ma = sum / period;

      double x = i * candleWidth + candleWidth / 2;
      double y = size.height * (1 - (ma - minPrice) / priceRange);

      if (i == period - 1) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class MacdChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // MACD labels
          Container(
            height: 20,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text('MACD(12,26,9) ',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('MACD ',
                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                  Text('27.65 ',
                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                  Text('DIF ',
                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                  Text('-56.75 ',
                      style: TextStyle(fontSize: 10, color: Colors.blue)),
                  Text('DEA ',
                      style: TextStyle(fontSize: 10, color: Colors.purple)),
                  Text('-70.57',
                      style: TextStyle(fontSize: 10, color: Colors.purple)),
                  SizedBox(width: 16),
                  Text('46.42',
                      style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ),
          ),
          // MACD chart
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: MacdPainter(),
            ),
          ),
        ],
      ),
    );
  }
}

class MacdPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 1;

    // Generate realistic MACD data
    List<double> macdHistogram = [
      15,
      12,
      8,
      5,
      2,
      -1,
      -5,
      -8,
      -12,
      -15,
      -18,
      -20,
      -22,
      -20,
      -18,
      -15,
      -12,
      -8,
      -5,
      -2,
      1,
      5,
      8,
      12,
      15,
      18,
      20,
      22,
      20,
      18
    ];

    // Draw histogram
    double barWidth = size.width / macdHistogram.length;
    double zeroLine = size.height * 0.6;

    for (int i = 0; i < macdHistogram.length; i++) {
      double x = i * barWidth + barWidth / 2;
      double value = macdHistogram[i];
      double height = value * 1.5; // Scale for visibility

      paint.color = value > 0 ? Colors.green : Colors.red;

      Rect bar = Rect.fromLTWH(
        x - barWidth * 0.3,
        value > 0 ? zeroLine - height : zeroLine,
        barWidth * 0.6,
        value > 0 ? height : -height,
      );

      canvas.drawRect(bar, paint);
    }

    // Draw MACD line
    paint.color = Colors.blue;
    paint.strokeWidth = 1.5;
    paint.style = PaintingStyle.stroke;

    Path macdPath = Path();
    for (int i = 0; i < macdHistogram.length; i++) {
      double x = i * barWidth + barWidth / 2;
      double y = zeroLine - macdHistogram[i] * 0.8;

      if (i == 0) {
        macdPath.moveTo(x, y);
      } else {
        macdPath.lineTo(x, y);
      }
    }
    canvas.drawPath(macdPath, paint);

    // Draw signal line
    paint.color = Colors.purple;
    Path signalPath = Path();
    for (int i = 0; i < macdHistogram.length; i++) {
      double x = i * barWidth + barWidth / 2;
      double y = zeroLine - (macdHistogram[i] * 0.6); // Signal line is smoother

      if (i == 0) {
        signalPath.moveTo(x, y);
      } else {
        signalPath.lineTo(x, y);
      }
    }
    canvas.drawPath(signalPath, paint);

    // Draw zero line
    paint.color = Colors.grey.shade300;
    paint.strokeWidth = 0.5;
    canvas.drawLine(Offset(0, zeroLine), Offset(size.width, zeroLine), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;

  CandleData(this.open, this.high, this.low, this.close);
}
