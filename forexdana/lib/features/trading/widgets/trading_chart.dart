import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../../../core/models/candle_data.dart';

class TradingChart extends StatefulWidget {
  final List<CandleData> candles;
  final List<double> ma5;
  final List<double> ma10;
  final List<double> ma30;
  final List<double> macd;
  final List<double> signal;
  final List<double> hist;

  const TradingChart({
    super.key,
    required this.candles,
    required this.ma5,
    required this.ma10,
    required this.ma30,
    required this.macd,
    required this.signal,
    required this.hist,
  });

  @override
  State<TradingChart> createState() => _TradingChartState();
}

class _TradingChartState extends State<TradingChart> {
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.longPress,
      lineType: TrackballLineType.vertical,
      tooltipSettings: const InteractiveTooltip(
          enable: true, format: 'point.y', color: Colors.black87),
      tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.candles.isEmpty) {
      return const Center(child: Text('Chart data is not available.'));
    }
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: DateTimeAxis(
        majorGridLines: const MajorGridLines(width: 0.5, color: Colors.black12),
        axisLine: const AxisLine(width: 0),
        dateFormat: DateFormat.Hm(),
      ),
      primaryYAxis: NumericAxis(
        opposedPosition: true,
        labelPosition: ChartDataLabelPosition.inside,
        rangePadding: ChartRangePadding.round,
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
        numberFormat: NumberFormat.compact(locale: 'en_US'),
      ),
      axes: <ChartAxis>[
        NumericAxis(
          name: 'macdYAxis',
          opposedPosition: true,
          majorGridLines: const MajorGridLines(width: 0),
          axisLine: const AxisLine(width: 0),
          majorTickLines: const MajorTickLines(size: 0),
          isVisible: false,
        ),
      ],
      trackballBehavior: _trackballBehavior,
      zoomPanBehavior: _zoomPanBehavior,
      series: _getChartSeries(),
    );
  }

  List<CartesianSeries> _getChartSeries() {
    DateTime indexToTime(int index) => widget.candles[index].dateTime;
    return <CartesianSeries>[
      CandleSeries<CandleData, DateTime>(
        dataSource: widget.candles,
        xValueMapper: (CandleData data, _) => data.dateTime,
        lowValueMapper: (CandleData data, _) => data.low,
        highValueMapper: (CandleData data, _) => data.high,
        openValueMapper: (CandleData data, _) => data.open,
        closeValueMapper: (CandleData data, _) => data.close,
        bearColor: Colors.red.shade600,
        bullColor: Colors.green.shade600,
        enableSolidCandles: true,
        name: 'Price',
      ),
      _createLineSeries(widget.ma5, Colors.purple.shade300, 'MA5'),
      _createLineSeries(widget.ma10, Colors.blue.shade300, 'MA10'),
      _createLineSeries(widget.ma30, Colors.orange.shade300, 'MA30'),
      ColumnSeries<double, DateTime>(
        dataSource: widget.hist,
        xValueMapper: (_, index) => indexToTime(index),
        yValueMapper: (double val, _) => val,
        yAxisName: 'macdYAxis',
        name: 'Histogram',
        pointColorMapper: (double val, _) => val >= 0
            ? Colors.green.withOpacity(0.7)
            : Colors.red.withOpacity(0.7),
      ),
      LineSeries<double, DateTime>(
        dataSource: widget.macd,
        xValueMapper: (_, index) => indexToTime(index),
        yValueMapper: (double val, _) => val,
        yAxisName: 'macdYAxis',
        name: 'MACD',
        color: Colors.blue,
        width: 2,
      ),
      LineSeries<double, DateTime>(
        dataSource: widget.signal,
        xValueMapper: (_, index) => indexToTime(index),
        yValueMapper: (double val, _) => val,
        yAxisName: 'macdYAxis',
        name: 'Signal',
        color: Colors.purpleAccent,
        width: 2,
      ),
    ];
  }

  LineSeries<double, DateTime> _createLineSeries(
      List<double> data, Color color, String name) {
    return LineSeries<double, DateTime>(
      dataSource: data,
      xValueMapper: (_, index) => widget.candles[index].dateTime,
      yValueMapper: (double val, _) => val.isNaN ? null : val,
      color: color,
      name: name,
      width: 1.5,
      enableTooltip: true,
    );
  }
}
