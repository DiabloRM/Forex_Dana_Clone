import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../core/network/api_client.dart';
import '../../trading/state/trading_provider.dart';
import '../../../core/models/ticker_data.dart';
import '../../trading/widgets/trading_chart.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TradingProvider(ApiClient(), mockOnly: false),
      child: Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Row(
            children: [
              Text(
                _symbol.replaceAll('/', ''),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w600),
              ),
              const Icon(Icons.keyboard_arrow_down,
                  color: Colors.black, size: 24),
              const SizedBox(width: 8),
              const Icon(Icons.help_outline, color: Colors.grey, size: 22),
            ],
          ),
          actions: [
            Consumer<TradingProvider>(builder: (context, tp, _) {
              return IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: tp.loading
                    ? null
                    : () => tp.loadAll(
                        symbol: _symbol,
                        interval: _tfMap[selectedTimeframe] ?? '5min'),
                color: tp.loading ? Colors.grey : Colors.black,
                tooltip: tp.loading ? 'Refreshing...' : 'Refresh data',
              );
            }),
            Container(
              margin: const EdgeInsets.only(right: 16, top: 12, bottom: 12),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(8)),
              child: const Center(
                child: Text('LIVE',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: Consumer<TradingProvider>(
          builder: (context, tp, _) {
            if (!tp.loading && tp.candles.isEmpty && tp.error == null) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                tp.loadAll(
                    symbol: _symbol,
                    interval: _tfMap[selectedTimeframe] ?? '5min');
              });
            }
            if (tp.loading && tp.candles.isEmpty) {
              return const Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Loading trading data...',
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ]));
            }
            if (tp.error != null && tp.candles.isEmpty) {
              return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red),
                    SizedBox(height: 16),
                    Text('Error loading data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32),
                      child: Text(tp.error ?? 'An unknown error occurred.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[600])),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => tp.loadAll(
                          symbol: _symbol,
                          interval: _tfMap[selectedTimeframe] ?? '5min'),
                      child: Text('Retry'),
                    ),
                  ]));
            }
            return Stack(
              children: [
                CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          _buildPriceHeader(tp.ticker),
                          _buildTimeframeSelector(context, tp),
                          _buildIndicatorsInfo(tp),
                          _buildChart(tp),
                          const SizedBox(height: 24),
                          _buildActionButtons(),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
                if (tp.loading && tp.candles.isNotEmpty) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPriceHeader(TickerData? t) {
    final isUp = (t?.priceChange ?? 0) >= 0;
    final priceColor = isUp ? Colors.green.shade600 : Colors.red.shade600;
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t != null ? t.lastPrice.toStringAsFixed(5) : '--',
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w500,
                        color: priceColor)),
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
                            fontWeight: FontWeight.bold)),
                    const SizedBox(width: 12),
                    Text(t != null ? t.priceChange.toStringAsFixed(5) : '--',
                        style: TextStyle(
                            color: priceColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
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
                  Icon(Icons.notifications_none,
                      size: 22, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Icon(Icons.star_border,
                      size: 22, color: Colors.grey.shade600),
                ],
              ),
              const SizedBox(height: 16),
              Text('H: 27${t != null ? t.highPrice.toStringAsFixed(5) : '--'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
              Text('L: 27${t != null ? t.lowPrice.toStringAsFixed(5) : '--'}',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeframeSelector(BuildContext context, TradingProvider tp) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        physics: const BouncingScrollPhysics(),
        itemCount: timeframes.length,
        itemBuilder: (context, index) {
          String timeframe = timeframes[index];
          bool isSelected = timeframe == selectedTimeframe;
          return GestureDetector(
            onTap: tp.loading
                ? null
                : () {
                    setState(() => selectedTimeframe = timeframe);
                    tp.loadAll(symbol: _symbol, interval: _tfMap[timeframe]!);
                  },
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.shade100 : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                    color: isSelected
                        ? Colors.blue.shade300
                        : Colors.grey.shade300),
              ),
              child: Center(
                child: Text(timeframe,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.blue.shade700
                          : Colors.grey.shade600,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    )),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIndicatorsInfo(TradingProvider tp) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(children: [
          const Text("Indicators:",
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black54)),
          const SizedBox(width: 16),
          _buildIndicatorText(
              'MA5', _lastValue(tp.ma5), Colors.purple.shade300),
          const SizedBox(width: 16),
          _buildIndicatorText(
              'MA10', _lastValue(tp.ma10), Colors.blue.shade300),
          const SizedBox(width: 16),
          _buildIndicatorText(
              'MA30', _lastValue(tp.ma30), Colors.orange.shade300),
        ]));
  }

  Widget _buildIndicatorText(String label, String value, Color color) {
    return Row(mainAxisSize: MainAxisSize.min, children: [
      Text('$label: ',
          style: TextStyle(
              color: color, fontSize: 12, fontWeight: FontWeight.w500)),
      Text(value, style: TextStyle(color: color, fontSize: 12)),
    ]);
  }

  Widget _buildChart(TradingProvider tp) {
    return Container(
      height: 450,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: (tp.candles.isNotEmpty)
          ? TradingChart(
              candles: tp.candles,
              ma5: tp.ma5,
              ma10: tp.ma10,
              ma30: tp.ma30,
              macd: tp.macd,
              signal: tp.signal,
              hist: tp.hist,
            )
          : const Center(
              child: Text('No chart data available',
                  style: TextStyle(color: Colors.grey))),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          Expanded(
              flex: 2, child: _buildActionButton('SELL', Colors.red.shade600)),
          const SizedBox(width: 16),
          Expanded(
              flex: 2, child: _buildActionButton('BUY', Colors.green.shade600)),
        ],
      ),
    );
  }

  Widget _buildActionButton(String title, Color color) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 16)),
      onPressed: () {},
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600)),
          const Text('Market',
              style: TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
        SizedBox(height: 16),
        Text('Refreshing data...',
            style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ])),
    );
  }
}
