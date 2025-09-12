import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_client.dart';
import '../../trading/state/trading_provider.dart';
import '../../../core/models/candle_data.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/navigation/navigation_service.dart';

class TradingScreen extends StatefulWidget {
  final String? initialSymbol;
  const TradingScreen({super.key, this.initialSymbol});

  @override
  _TradingScreenState createState() => _TradingScreenState();
}

class _TradingScreenState extends State<TradingScreen> {
  String selectedTimeframe = '5M';
  List<String> timeframes = ['1M', '5M', '15M', '30M', '1H', '4H', '1D'];
  final Map<String, String> _tfMap = {
    '1M': '1min',
    '5M': '5min',
    '15M': '15min',
    '30M': '30min',
    '1H': '1h',
    '4H': '4h',
    '1D': '1day',
  };
  late String _symbol;

  // Zoom and scroll state
  double _chartZoom = 1.0;
  double _chartOffset = 0.0;
  bool _isZoomed = false;

  @override
  void initState() {
    super.initState();
    _symbol = widget.initialSymbol ?? 'EUR/USD';
  }

  String _lastValue(List<double> series) {
    for (int i = series.length - 1; i >= 0; i--) {
      final v = series[i];
      if (!v.isNaN && v.isFinite) {
        return v.toStringAsFixed(5);
      }
    }
    return '--';
  }

  void _resetZoom() {
    setState(() {
      _chartZoom = 1.0;
      _chartOffset = 0.0;
      _isZoomed = false;
    });
  }

  void _zoomIn() {
    setState(() {
      _chartZoom = (_chartZoom * 1.5).clamp(1.0, 5.0);
      _isZoomed = _chartZoom > 1.0;
    });
  }

  void _zoomOut() {
    setState(() {
      _chartZoom = (_chartZoom / 1.5).clamp(1.0, 5.0);
      _isZoomed = _chartZoom > 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradingProvider(ApiClient(), mockOnly: false),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: AppIcons.getIconButton(
            AppIcons.back,
            onPressed: () => NavigationService().goBack(),
            size: AppIcons.sizeMedium,
            color: Colors.black,
          ),
          title: Row(
            children: [
              Text(
                _symbol.replaceAll('/', ''),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              AppIcons.getIcon(AppIcons.down,
                  color: Colors.black, size: AppIcons.sizeMedium),
              const SizedBox(width: 8),
              AppIcons.getIcon(AppIcons.help,
                  color: Colors.grey, size: AppIcons.sizeMedium),
            ],
          ),
          actions: [
            // Refresh button
            Consumer<TradingProvider>(
              builder: (context, tp, _) {
                return AppIcons.getIconButton(
                  AppIcons.refresh,
                  onPressed: tp.loading
                      ? null
                      : () => tp.loadAll(
                          symbol: _symbol,
                          interval: _tfMap[selectedTimeframe] ?? '5min'),
                  color: tp.loading ? Colors.blue : Colors.black,
                  tooltip: tp.loading ? 'Refreshing...' : 'Refresh data',
                );
              },
            ),
            Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade600,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'LIVE',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Consumer<TradingProvider>(
          builder: (context, tp, _) {
            // Load data when the provider is first created
            if (!tp.loading && tp.candles.isEmpty && tp.error == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                tp.loadAll(
                    symbol: _symbol,
                    interval: _tfMap[selectedTimeframe] ?? '5min');
              });
            }

            final t = tp.ticker;
            final isUp = (t?.priceChange ?? 0) >= 0;
            final priceColor =
                isUp ? Colors.green.shade600 : Colors.red.shade600;

            // Show loading state
            if (tp.loading && tp.candles.isEmpty) {
              return const Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading trading data...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fetching real-time market data from TwelveData',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
      ),
    );
  }

            // Show error state
            if (tp.error != null && tp.candles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
            children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    const Text(
                      'Error loading trading data',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        tp.error!,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => tp.loadAll(
                          symbol: _symbol,
                          interval: _tfMap[selectedTimeframe] ?? '5min'),
                      child: const Text('Retry'),
              ),
            ],
          ),
    );
  }

            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          // Price Section
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
        ),
                            margin: const EdgeInsets.all(16),
      child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
              children: [
                                      Text(
                                        t != null
                                            ? t.lastPrice.toStringAsFixed(5)
                                            : '--',
                      style: TextStyle(
                        fontSize: 32,
                                          fontWeight: FontWeight.w500,
                        color: priceColor,
                      ),
                ),
                                      const SizedBox(height: 8),
                Row(
                  children: [
                          Text(
                                            t != null
                                                ? '${t.priceChangePercent.toStringAsFixed(2)}%'
                                                : '--',
                            style: TextStyle(
                              color: priceColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                            ),
                          ),
                                          const SizedBox(width: 12),
                          Text(
                                            t != null
                                                ? t.priceChange
                                                    .toStringAsFixed(5)
                                                : '--',
                            style: TextStyle(
                                              color: priceColor,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
                                    Row(
                                      children: [
                                        AppIcons.getIcon(
                                            AppIcons.notificationBorder,
                                            size: AppIcons.sizeMedium,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 12),
                                        AppIcons.getIcon(AppIcons.starBorder,
                                            size: AppIcons.sizeMedium,
                                            color: Colors.grey.shade600),
                                        const SizedBox(width: 12),
                                        AppIcons.getIcon(AppIcons.share,
                                            size: AppIcons.sizeMedium,
                                            color: Colors.grey.shade600),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
      children: [
        Text(
                                          'H: ${t != null ? t.highPrice.toStringAsFixed(5) : '--'}',
          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600),
        ),
        Text(
                                          'L: ${t != null ? t.lowPrice.toStringAsFixed(5) : '--'}',
          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600),
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
                            height: 50,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: timeframes.length,
        itemBuilder: (context, index) {
          String timeframe = timeframes[index];
                                bool isSelected =
                                    timeframe == selectedTimeframe;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedTimeframe = timeframe;
                                      _resetZoom(); // Reset zoom when timeframe changes
              });
              final mapped = _tfMap[timeframe] ?? '5min';
                                    context.read<TradingProvider>().loadAll(
                                        symbol: _symbol, interval: mapped);
            },
            child: Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                                          ? Colors.blue.shade100
                    : Colors.transparent,
                                      borderRadius: BorderRadius.circular(20),
                                      border: isSelected
                                          ? Border.all(
                                              color: Colors.blue.shade300,
                                              width: 2)
                                          : Border.all(
                                              color: Colors.grey.shade300,
                                              width: 1),
                                    ),
                child: Text(
                  timeframe,
                  style: TextStyle(
                    color: isSelected
                                            ? Colors.blue.shade700
                                            : Colors.grey.shade600,
                                        fontSize: 14,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
                          ),

                          // Indicators Row
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
                                    border: Border.all(color: Colors.orange),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Indicators',
                                        style: TextStyle(
                                            color: Colors.orange, fontSize: 12),
                                      ),
                                      Icon(Icons.keyboard_arrow_down,
                                          color: Colors.orange, size: 16),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
                                        _buildIndicatorText(
                                            'MA5',
                                            _lastValue(tp.ma5),
                                            Colors.purple.shade300),
          const SizedBox(width: 16),
                                        _buildIndicatorText(
                                            'MA10',
                                            _lastValue(tp.ma10),
                                            Colors.blue.shade300),
          const SizedBox(width: 16),
                                        _buildIndicatorText(
                                            'MA30',
                                            _lastValue(tp.ma30),
                                            Colors.orange.shade300),
                                        const SizedBox(width: 16),
                                        _buildIndicatorText(
                                            'Close',
                                            tp.candles.isNotEmpty
                                                ? tp.candles.last.close
                                                    .toStringAsFixed(5)
                                                : '--',
                                            Colors.grey.shade600),
                                      ],
                ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Chart Controls
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                                  'Chart (${_chartZoom.toStringAsFixed(1)}x)',
                    style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade700,
            ),
          ),
          Row(
            children: [
                                    AppIcons.getIconButton(
                                      AppIcons.zoomOut,
                                      onPressed: _zoomOut,
                    color: _chartZoom > 1.0
                                          ? Colors.blue
                                          : Colors.grey,
                                      size: AppIcons.sizeMedium,
                                      tooltip: 'Zoom out',
                                    ),
                                    AppIcons.getIconButton(
                                      AppIcons.zoomIn,
                                      onPressed: _zoomIn,
                    color: _chartZoom < 5.0
                                          ? Colors.blue
                                          : Colors.grey,
                                      size: AppIcons.sizeMedium,
                                      tooltip: 'Zoom in',
              ),
              if (_isZoomed)
                                      AppIcons.getIconButton(
                                        AppIcons.refresh,
                  onPressed: _resetZoom,
                                        color: Colors.orange,
                                        size: AppIcons.sizeMedium,
                                        tooltip: 'Reset zoom',
                ),
            ],
          ),
        ],
      ),
                          ),

                          // Chart Area
                          Container(
                            height: 300,
                            margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                              color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                                  color: Colors.grey.shade200,
                                  blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
                child: tp.candles.isNotEmpty
                    ? InteractiveViewer(
                        minScale: 0.5,
                        maxScale: 3.0,
                        child: CandlestickChart(
                          candles: tp.candles,
                          ma5: tp.ma5,
                          ma10: tp.ma10,
                          ma30: tp.ma30,
                          zoom: _chartZoom,
                          offset: _chartOffset,
                        ),
                      )
                                : const Center(
                        child: Text(
                          'No chart data available',
                                      style: TextStyle(color: Colors.grey),
                        ),
                      ),
              ),

                          // MACD Indicator
          if (tp.macd.isNotEmpty && tp.signal.isNotEmpty)
            Container(
                              height: 120,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
              ),
                                ],
                              ),
                child: MacdChart(
                  macd: tp.macd,
                  signal: tp.signal,
                  hist: tp.hist,
                ),
              ),

                          // Time labels
                          Container(
                            height: 30,
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('16:10',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                                Text('16:50',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                                Text('17:30',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                                Text('18:10',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                                Text('18:50',
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey.shade600)),
                              ],
              ),
            ),

                          // Bottom Action Buttons
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
      children: [
        Expanded(
                                  child: Column(
                                    children: [
                                      AppIcons.getIcon(AppIcons.positions,
                                          color: Colors.grey.shade600,
                                          size: AppIcons.sizeMedium),
                                      const SizedBox(height: 4),
                                      Text('Position',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600)),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
              children: [
                                      AppIcons.getIcon(AppIcons.time,
                                          color: Colors.grey.shade600,
                                          size: AppIcons.sizeMedium),
                                      const SizedBox(height: 4),
                                      Text('Pending...',
                      style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600)),
              ],
            ),
          ),
        Expanded(
                                  flex: 2,
                                  child: Container(
                                    height: 48,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade600,
                                      borderRadius: BorderRadius.circular(24),
              ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
              children: [
                                          Text('BUY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text('Market',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
                  ],
                ),
            ),
          ),
        ),
            Expanded(
                                  flex: 2,
              child: Container(
                                    height: 48,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                decoration: BoxDecoration(
                                      color: Colors.red.shade600,
                                      borderRadius: BorderRadius.circular(24),
                ),
                                    child: const Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                  children: [
                                          Text('SELL',
                      style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600)),
                                          Text('Market',
                        style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12)),
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
            ),
          ],
        ),
                // Loading overlay when refreshing
                Consumer<TradingProvider>(
                  builder: (context, tp, _) {
                    if (tp.loading && tp.candles.isNotEmpty) {
                      return Container(
                        color: Colors.black.withValues(alpha: 0.3),
                        child: const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
                              CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
          ),
                              SizedBox(height: 16),
          Text(
                                'Refreshing data...',
            style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildIndicatorText(String label, String value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
          children: [
            Text(
          '$label: ',
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
  final List<CandleData> candles;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma30;
  final double zoom;
  final double offset;

  const CandlestickChart({
    super.key,
    required this.candles,
    this.ma5,
    this.ma10,
    this.ma30,
    this.zoom = 1.0,
    this.offset = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: CandlestickPainter(
        candles: candles,
        ma5: ma5,
        ma10: ma10,
        ma30: ma30,
        zoom: zoom,
        offset: offset,
      ),
    );
  }
}

class CandlestickPainter extends CustomPainter {
  final List<CandleData> candles;
  final List<double>? ma5;
  final List<double>? ma10;
  final List<double>? ma30;
  final double zoom;
  final double offset;

  CandlestickPainter({
    required this.candles,
    this.ma5,
    this.ma10,
    this.ma30,
    this.zoom = 1.0,
    this.offset = 0.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (candles.isEmpty) return;

  final paint = Paint()..strokeWidth = 1;

    final minPrice = candles.map((c) => c.low).reduce((a, b) => a < b ? a : b);
    final maxPrice = candles.map((c) => c.high).reduce((a, b) => a > b ? a : b);
    final priceRange = (maxPrice - minPrice).abs();
    if (priceRange <= 0) return;

    // Apply zoom and offset transformations
    canvas.save();
    canvas.translate(offset, 0);
    canvas.scale(zoom, 1.0);

    // Draw grid lines
    paint.color = Colors.grey.shade200;
    for (int i = 0; i <= 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Draw candlesticks
    final double candleWidth = size.width / candles.length;
    for (int i = 0; i < candles.length; i++) {
      final c = candles[i];
      final x = i * candleWidth + candleWidth / 2;
      final highY = size.height * (1 - (c.high - minPrice) / priceRange);
      final lowY = size.height * (1 - (c.low - minPrice) / priceRange);
      final openY = size.height * (1 - (c.open - minPrice) / priceRange);
      final closeY = size.height * (1 - (c.close - minPrice) / priceRange);
      final isBullish = c.close >= c.open;
      final candleColor = isBullish ? Colors.green : Colors.red;

      // Draw wick
      paint
        ..color = candleColor
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;
      canvas.drawLine(Offset(x, highY), Offset(x, lowY), paint);

      // Draw body
      final bodyTop = isBullish ? closeY : openY;
      final bodyBottom = isBullish ? openY : closeY;
      final bodyWidth = candleWidth * 0.6;
      final rect = Rect.fromLTRB(
          x - bodyWidth / 2, bodyTop, x + bodyWidth / 2, bodyBottom);
      paint.style = isBullish ? PaintingStyle.stroke : PaintingStyle.fill;
      canvas.drawRect(rect, paint);
  }

    // Draw moving averages
    void drawMA(List<double>? series, Color color) {
      if (series == null || series.length != candles.length) return;
      final path = Path();
      bool started = false;
      for (int i = 0; i < series.length; i++) {
        final v = series[i];
        if (v.isNaN || !v.isFinite) continue;
        final x = i * (size.width / candles.length) +
            (size.width / candles.length) / 2;
        final y = size.height * (1 - (v - minPrice) / priceRange);
        if (!started) {
          path.moveTo(x, y);
          started = true;
        } else {
          path.lineTo(x, y);
        }
      }
      final p = Paint()
        ..color = color
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, p);
    }

    drawMA(ma5, Colors.purple.shade300);
    drawMA(ma10, Colors.blue.shade300);
    drawMA(ma30, Colors.orange.shade300);

    canvas.restore();
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

class MacdChart extends StatelessWidget {
  final List<double> macd;
  final List<double> signal;
  final List<double> hist;

  const MacdChart({
    super.key,
    required this.macd,
    required this.signal,
    required this.hist,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.infinite,
      painter: MacdPainter(macd: macd, signal: signal, hist: hist),
    );
  }
}

class MacdPainter extends CustomPainter {
  final List<double> macd;
  final List<double> signal;
  final List<double> hist;

  MacdPainter({required this.macd, required this.signal, required this.hist});

  @override
  void paint(Canvas canvas, Size size) {
    if (hist.isEmpty || macd.isEmpty || signal.isEmpty) return;

    final paint = Paint()..strokeWidth = 1;
    final n = hist.length;
    final barWidth = size.width / n;
    final zeroLine = size.height * 0.6;

    // Draw histogram bars
    for (int i = 0; i < n; i++) {
      final x = i * barWidth + barWidth / 2;
      final value = hist[i];
      if (!value.isFinite) continue;

      final height = value.abs() * 1.5;
      paint.color = value >= 0 ? Colors.green : Colors.red;
      final bar = Rect.fromLTWH(
        x - barWidth * 0.3,
        value >= 0 ? zeroLine - height : zeroLine,
        barWidth * 0.6,
        value >= 0 ? height : -height,
      );
      canvas.drawRect(bar, paint);
    }

    // Draw MACD and Signal lines
    Path drawLine(List<double> s, Color color, double k) {
      final path = Path();
      for (int i = 0; i < n; i++) {
        final x = i * barWidth + barWidth / 2;
        final value = s[i];
        if (!value.isFinite) continue;
        final y = zeroLine - value * k;
        if (i == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      paint
        ..color = color
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;
      canvas.drawPath(path, paint);
      return path;
    }

    drawLine(macd, Colors.blue, 0.8);
    drawLine(signal, Colors.purple, 0.8);

    // Draw zero line
    paint
      ..color = Colors.grey.shade300
      ..strokeWidth = 0.5;
    canvas.drawLine(Offset(0, zeroLine), Offset(size.width, zeroLine), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
