import 'package:flutter/material.dart';
import '../../../core/constants/app_icons.dart';

/// Expandable Analysis Sheet Component with Views, Calendar, and Analysis tabs
class ExpandableAnalysisSheet extends StatefulWidget {
  final int initialTabIndex;

  const ExpandableAnalysisSheet({
    Key? key,
    this.initialTabIndex = 0,
  }) : super(key: key);

  @override
  State<ExpandableAnalysisSheet> createState() =>
      _ExpandableAnalysisSheetState();
}

class _ExpandableAnalysisSheetState extends State<ExpandableAnalysisSheet>
    with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedTabIndex = 0;
  int selectedDateIndex = 2; // Wednesday is selected by default

  final List<String> tabs = ['Views', 'Calendar', 'Analysis'];
  final List<String> dates = [
    '09/01 Mon',
    '09/02 Tue',
    '09/03 Wed',
    '09/04 Thu',
    '09/05 Fri',
    '09/06 Sat',
    '09/07 Sun'
  ];

  final List<String> viewCategories = [
    'Forex',
    'Index',
    'Commodities',
    'Crypto'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Set the initial tab based on the parameter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialTabIndex < _tabController.length) {
        _tabController.animateTo(widget.initialTabIndex);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  child: TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: Colors.black,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                    tabs: tabs.map((tab) => Tab(text: tab)).toList(),
                  ),
                ),
                IconButton(
                  icon: AppIcons.getIcon(AppIcons.close,
                      size: AppIcons.sizeMedium),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          // Content area
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildViewsTab(),
                _buildCalendarTab(),
                _buildAnalysisTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewsTab() {
    return Column(
      children: [
        // Date selector
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.getIcon(AppIcons.calendar,
                        size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 4),
                    Text(
                      'Sept 02',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewCategories.length,
                  itemBuilder: (context, index) {
                    final isSelected = index == 0; // Forex is selected
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.grey.shade200
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        viewCategories[index],
                        style: TextStyle(
                          color:
                              isSelected ? Colors.black : Colors.grey.shade600,
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // Market insights list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getMarketInsights().length,
            itemBuilder: (context, index) {
              final insight = _getMarketInsights()[index];
              return _buildMarketInsightCard(insight);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarTab() {
    return Column(
      children: [
        // Date selector
        Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dates.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedDateIndex;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedDateIndex = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 16),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Colors.orange.shade100
                        : Colors.transparent,
                    border: isSelected
                        ? Border.all(color: Colors.orange, width: 2)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dates[index],
                    style: TextStyle(
                      color: isSelected
                          ? Colors.orange.shade700
                          : Colors.grey.shade600,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Financial events list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _getFinancialEvents().length,
            itemBuilder: (context, index) {
              final event = _getFinancialEvents()[index];
              return _buildFinancialEventCard(event);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAnalysisTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _getAnalysisData().length,
      itemBuilder: (context, index) {
        final analysis = _getAnalysisData()[index];
        return _buildAnalysisCard(analysis);
      },
    );
  }

  Widget _buildMarketInsightCard(Map<String, dynamic> insight) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with timestamp and sentiment
          Row(
            children: [
              Text(
                insight['timestamp'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: insight['sentiment'] == 'Limited upside'
                      ? Colors.green.shade100
                      : Colors.red.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppIcons.getIcon(
                      insight['sentiment'] == 'Limited upside'
                          ? AppIcons.up
                          : AppIcons.down,
                      size: 12,
                      color: insight['sentiment'] == 'Limited upside'
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      insight['sentiment'],
                      style: TextStyle(
                        fontSize: 10,
                        color: insight['sentiment'] == 'Limited upside'
                            ? Colors.green.shade700
                            : Colors.red.shade700,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  insight['asset'],
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Headline
          Text(
            insight['headline'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 8),

          // Preference text
          Text(
            insight['preference'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),

          const SizedBox(height: 16),

          // Chart placeholder
          _buildChartPlaceholder(insight),
        ],
      ),
    );
  }

  Widget _buildFinancialEventCard(Map<String, dynamic> event) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with flag, importance, and time
          Row(
            children: [
              // Flag placeholder
              Container(
                width: 24,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Center(
                  child: Text(
                    event['country'] == 'US' ? 'US' : 'CA',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Importance stars
              Row(
                children: List.generate(3, (index) {
                  final isFilled = index < event['importance'];
                  return Icon(
                    isFilled ? Icons.star : Icons.star_border,
                    size: 16,
                    color: isFilled ? Colors.orange : Colors.grey.shade400,
                  );
                }),
              ),

              const Spacer(),

              // Time
              Text(
                event['time'],
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Event title
          Text(
            event['title'],
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          if (event['additionalInfo'] != null) ...[
            const SizedBox(height: 8),
            Text(
              event['additionalInfo'],
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Description
          Text(
            event['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisCard(Map<String, dynamic> analysis) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and time
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  analysis['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
              Text(
                analysis['time'],
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Description
          Text(
            analysis['description'],
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.4,
            ),
          ),

          // Chart
          _buildChartPlaceholder(analysis),
        ],
      ),
    );
  }

  Widget _buildChartPlaceholder(Map<String, dynamic> data) {
    return Container(
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // Mock chart line
          CustomPaint(
            size: const Size(double.infinity, 120),
            painter: ChartPainter(isPositive: data['isPositive'] ?? true),
          ),
          // Chart controls
          Positioned(
            top: 8,
            right: 8,
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade800,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    '30M',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (data['isPositive'] ?? true)
                        ? Colors.green
                        : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    (data['isPositive'] ?? true) ? 'Buy' : 'Sell',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          // Price info
          Positioned(
            bottom: 8,
            left: 8,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  (data['isPositive'] ?? true) ? '+2.45%' : '-1.23%',
                  style: TextStyle(
                    color: (data['isPositive'] ?? true)
                        ? Colors.green
                        : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '30m',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getMarketInsights() {
    return [
      {
        'timestamp': '05:54',
        'sentiment': 'Limited upside',
        'asset': 'ALGOUSD',
        'headline': 'Algorand / Dollar intraday: rebound towards 0.2407',
        'preference': 'Our preference: rebound towards 0.2407.',
        'isPositive': true,
      },
      {
        'timestamp': '05:52',
        'sentiment': 'Limited downside',
        'asset': 'DOGE/USDT',
        'headline':
            'Dogecoin / Dollar intraday: the downside prevails as long as 0.2162 is resistance',
        'preference':
            'Our preference: the downside prevails as long as 0.2162 is resistance.',
        'isPositive': false,
      },
      {
        'timestamp': '05:52',
        'sentiment': 'Limited upside',
        'asset': 'LINK/USDT',
        'headline': 'Chainlink / Dollar intraday: rebound towards 23.79',
        'preference': 'The configuration is mixed.',
        'isPositive': true,
      },
      {
        'timestamp': '05:51',
        'sentiment': 'Limited upside',
        'asset': 'ADA/USDT',
        'headline': 'Cardano / Dollar intraday: rebound towards 0.8411',
        'preference': 'Our preference: rebound towards 0.8411.',
        'isPositive': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getFinancialEvents() {
    return [
      {
        'country': 'US',
        'importance': 1,
        'time': '23:45',
        'title': 'Fed Beige Book',
        'additionalInfo': null,
        'description':
            'In the United States, the authority to set interest rates is divided between the Board of Governors of the Federal Reserve (Board) and the Federal Open Market Committee (FOMC). The Board decides on changes in discount rates after recommendations submitted by one or more of the regional Federal Reserve Banks. The FOMC decides on open market operations, including the desired levels of central bank money or the desired federal funds market rate.',
      },
      {
        'country': 'US',
        'importance': 2,
        'time': '23:15',
        'title': 'Fed Kashkari Speech',
        'additionalInfo': null,
        'description':
            'In the United States, the authority to set interest rates is divided between the Board of Governors of the Federal Reserve (Board) and the Federal Open Market Committee (FOMC). The Board decides on changes in discount rates after recommendations submitted by one or more of the regional Federal Reserve Banks. The FOMC decides on open market operations, including the desired levels of central bank money or the desired federal funds market rate.',
      },
      {
        'country': 'CA',
        'importance': 2,
        'time': '21:45',
        'title': '5-Year Bond Auction',
        'additionalInfo': '3.005% Current',
        'description':
            'Canadian government bond auction with current yield information.',
      },
    ];
  }

  List<Map<String, dynamic>> _getAnalysisData() {
    return [
      {
        'title':
            'Bitcoin / Dollar Intraday: the upside prevails as long as 110840 is support',
        'time': '4 hrs ago',
        'description':
            'Bias: Bullish above 110840\nOur preference:\nLook for further upside with 110840 as support\n\nAlternative scenario:\nBelow 110840, expect 109660 and 108960',
        'isPositive': true,
      },
      {
        'title': 'Gold / US Dollar: towards the upside',
        'time': '5 hrs ago',
        'description':
            'Our preference:\nAs long as 3290.0 is support look for 3350.0\n\nAlternative scenario:\nBelow 3290.0, expect 3265.0 and 3240.0',
        'isPositive': true,
      },
      {
        'title': 'EUR/USD Intraday: bullish bias above 1.0400',
        'time': '6 hrs ago',
        'description':
            'Our preference:\nLook for further upside with 1.0400 as support\n\nAlternative scenario:\nThe downside breakout of 1.0400 would call for 1.0385 and 1.0370',
        'isPositive': true,
      },
    ];
  }
}

// Custom painter for mock chart
class ChartPainter extends CustomPainter {
  final bool isPositive;

  ChartPainter({required this.isPositive});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isPositive ? Colors.green : Colors.red
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final width = size.width;
    final height = size.height;

    // Create a mock chart line
    path.moveTo(0, height * 0.8);

    for (int i = 0; i < 10; i++) {
      final x = (width / 9) * i;
      final y = isPositive
          ? height * (0.8 - (i * 0.05)) // Upward trend
          : height * (0.2 + (i * 0.05)); // Downward trend

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);

    // Add some grid lines
    final gridPaint = Paint()
      ..color = Colors.grey.withValues(alpha: 0.3)
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = (height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

/// Function to show the bottom sheet
void showExpandableAnalysisSheet(BuildContext context,
    {int initialTabIndex = 0}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) =>
        ExpandableAnalysisSheet(initialTabIndex: initialTabIndex),
  );
}
