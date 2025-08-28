import 'package:flutter/material.dart';
import '../widgets/action_icon.dart';
import '../widgets/instrument_row.dart';
import 'user_screen.dart';
import '../../chat/screens/customer_support.dart' as chat;
import '../../../core/theme/app_theme.dart';
import '../../wallet/screens/deposit_screen.dart';
import 'demo_screen.dart';
import 'task_screen.dart';
import 'referral_screen.dart';

// Expandable Analysis Sheet Component
class ExpandableAnalysisSheet extends StatefulWidget {
  const ExpandableAnalysisSheet({Key? key}) : super(key: key);

  @override
  State<ExpandableAnalysisSheet> createState() =>
      _ExpandableAnalysisSheetState();
}

class _ExpandableAnalysisSheetState extends State<ExpandableAnalysisSheet> {
  int selectedTabIndex = 0;
  final List<String> tabs = ['Views', 'Calendar', 'Analysis'];

  // Sample analysis data
  final List<Map<String, dynamic>> analysisData = [
    {
      'title':
          'Bitcoin / Dollar Intraday: the upside prevails as long as 116716.0 is support',
      'time': '4 hrs ago',
      'description':
          'Bias: Bullish above 116716.0\nOur preference:\nLook for further upside with 116716.0 as support\n\nAlternative scenario:\nBelow 116716.0, expect 116118.0 and 115872.0',
      'chart': 'btc_chart',
      'isPositive': true,
    },
    {
      'title': 'Gold / US Dollar: towards the upside',
      'time': '5 hrs ago',
      'description':
          'Our preference:\nAs long as 3290.0 is support look for 3350.0\n\nAlternative scenario:\nBelow 3290.0, expect 3265.0 and 3240.0',
      'chart': 'gold_chart',
      'isPositive': true,
    },
    {
      'title': 'EUR/USD Intraday: bullish bias above 1.0400',
      'time': '6 hrs ago',
      'description':
          'Our preference:\nLook for further upside with 1.0400 as support\n\nAlternative scenario:\nThe downside breakout of 1.0400 would call for 1.0385 and 1.0370',
      'chart': 'eurusd_chart',
      'isPositive': true,
    },
    {
      'title': 'Gold Intraday: the favourite scenario',
      'time': '7 hrs ago',
      'description':
          'Our preference:\nAs long as 3290.0 is support look for 3350.0\n\nAlternative scenario:\nThe downside breakout of 3290.0 would call for 3265.0 and 3240.0',
      'chart': 'gold_intraday_chart',
      'isPositive': false,
    },
    {
      'title':
          'Bitcoin Gold / Dollar Intraday: the upside prevails as long as 27.27 is support',
      'time': '8 hrs ago',
      'description':
          'Our preference:\nLook for further upside with 27.27 as support\n\nAlternative scenario:\nBelow 27.27, expect 26.85 and 26.50',
      'chart': 'btg_chart',
      'isPositive': true,
    },
    {
      'title':
          'Solana / Dollar Intraday: the upside prevails as long as 184.049 is support',
      'time': '9 hrs ago',
      'description':
          'Our preference:\nLook for further upside with 184.049 as support\n\nAlternative scenario:\nBelow 184.049, expect 180.25 and 177.80',
      'chart': 'sol_chart',
      'isPositive': true,
    },
    {
      'title':
          'Chainlink / Dollar Intraday: the upside prevails as long as 27.27 is support',
      'time': '10 hrs ago',
      'description':
          'Our preference:\nLook for further upside with 27.27 as support\n\nAlternative scenario:\nThe downside breakout of 27.27 would call for 26.85 and 26.50',
      'chart': 'link_chart',
      'isPositive': true,
    },
  ];

  Widget _buildChart(String chartType, bool isPositive) {
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
            painter: ChartPainter(isPositive: isPositive),
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
                    '1D',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 4),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isPositive ? Colors.green : Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    isPositive ? 'Buy' : 'Sell',
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
                  isPositive ? '+2.45%' : '-1.23%',
                  style: TextStyle(
                    color: isPositive ? Colors.green : Colors.red,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  '24h',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ],
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
            color: Colors.grey.withOpacity(0.1),
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
          _buildChart(analysis['chart'], analysis['isPositive']),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
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
              children: List.generate(tabs.length, (index) {
                final isSelected = selectedTabIndex == index;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTabIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color:
                                isSelected ? Colors.black : Colors.transparent,
                            width: 2,
                          ),
                        ),
                      ),
                      child: Text(
                        tabs[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.black : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          // Content
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabContent() {
    switch (selectedTabIndex) {
      case 0: // Views
        return _buildViewsTab();
      case 1: // Calendar
        return _buildCalendarTab();
      case 2: // Analysis
        return _buildAnalysisTab();
      default:
        return _buildViewsTab();
    }
  }

  Widget _buildViewsTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.visibility, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Views',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Market views and insights coming soon',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarTab() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Calendar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Economic calendar coming soon',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return Container(
      color: Colors.grey.shade50,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: analysisData.length,
        itemBuilder: (context, index) {
          return _buildAnalysisCard(analysisData[index]);
        },
      ),
    );
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
      ..color = Colors.grey.withOpacity(0.3)
      ..strokeWidth = 1;

    for (int i = 1; i < 4; i++) {
      final y = (height / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// Function to show the bottom sheet
void showExpandableAnalysisSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const ExpandableAnalysisSheet(),
  );
}

class MarketScreen extends StatefulWidget {
  final Function(int)? onGoToSquare;
  final Function(AppThemeMode)? onThemeChanged;

  const MarketScreen({Key? key, this.onGoToSquare, this.onThemeChanged})
      : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  int selectedTabIndex = 0;
  Set<String> favoriteInstruments = {}; // Store user's favorite instruments

  final List<String> tabNames = [
    'Recommend',
    'My List',
    'Forex',
    'Crypto',
    'Metals'
  ];

  // Sample data - replace with your actual data
  final List<Map<String, dynamic>> allInstruments = [
    {
      'name': 'XAUUSD',
      'change': '-4.00',
      'percent': '-0.120%',
      'isUp': false,
      'buyPrice': '3332.19',
      'buyDiff': '0.15',
      'sellPrice': '3332.04',
      'showFire': true,
      'category': 'metals'
    },
    {
      'name': 'BTC/USDT',
      'change': '-1101.10',
      'percent': '-0.937%',
      'isUp': false,
      'buyPrice': '116456.10',
      'buyDiff': '10.10',
      'sellPrice': '116446.00',
      'showFire': true,
      'category': 'crypto'
    },
    {
      'name': 'ETH/USDT',
      'change': '-108.21',
      'percent': '-2.424%',
      'isUp': false,
      'buyPrice': '4358.19',
      'buyDiff': '0.96',
      'sellPrice': '4357.23',
      'showFire': true,
      'category': 'crypto'
    },
    {
      'name': 'SOL/USDT',
      'change': '-7.060',
      'percent': '-3.696%',
      'isUp': false,
      'buyPrice': '184.049',
      'buyDiff': '0.059',
      'sellPrice': '183.990',
      'showFire': true,
      'category': 'crypto'
    },
    {
      'name': 'EUR/USD',
      'change': '0.002',
      'percent': '0.18%',
      'isUp': true,
      'buyPrice': '1.0845',
      'buyDiff': '0.002',
      'sellPrice': '1.0843',
      'showFire': false,
      'category': 'forex'
    },
    {
      'name': 'GBP/USD',
      'change': '-0.005',
      'percent': '-0.39%',
      'isUp': false,
      'buyPrice': '1.2675',
      'buyDiff': '0.003',
      'sellPrice': '1.2672',
      'showFire': false,
      'category': 'forex'
    },
  ];

  void _showCustomerServiceDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CustomerServiceDialog();
      },
    );
  }

  void _toggleFavorite(String instrumentName) {
    setState(() {
      if (favoriteInstruments.contains(instrumentName)) {
        favoriteInstruments.remove(instrumentName);
      } else {
        favoriteInstruments.add(instrumentName);
      }
    });
  }

  List<Map<String, dynamic>> _getFilteredInstruments() {
    switch (selectedTabIndex) {
      case 0: // Recommend
        return allInstruments;
      case 1: // My List
        return allInstruments
            .where((instrument) =>
                favoriteInstruments.contains(instrument['name']))
            .toList();
      case 2: // Forex
        return allInstruments
            .where((instrument) => instrument['category'] == 'forex')
            .toList();
      case 3: // Crypto
        return allInstruments
            .where((instrument) => instrument['category'] == 'crypto')
            .toList();
      case 4: // Metals
        return allInstruments
            .where((instrument) => instrument['category'] == 'metals')
            .toList();
      default:
        return allInstruments;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserScreen(onThemeChanged: widget.onThemeChanged),
                ),
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.grey.shade300,
              child: Icon(Icons.person, color: Colors.grey.shade600),
            ),
          ),
        ),
        title: Container(
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Icon(Icons.search, color: Colors.grey.shade500, size: 20),
              const SizedBox(width: 12),
              const Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Enter keyword',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.black),
            onPressed: () => _showCustomerServiceDialog(context),
          ),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.mail_outline, color: Colors.black),
                onPressed: () {
                  if (widget.onGoToSquare != null) {
                    widget.onGoToSquare!(2); // Go to Messages tab (index 2)
                  }
                },
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // My Assets section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'My Assets',
                          style: TextStyle(color: Colors.grey, fontSize: 14),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          ' 240.00',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          '≈0 \$',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 10,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const DepositScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Deposit',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Action icons row
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ActionIcon(
                    icon: Icons.task_alt,
                    label: 'Task',
                    isNew: true,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const BDCMiningApp(),
                        ),
                      );
                    },
                  ),
                  ActionIcon(
                    icon: Icons.add_box_outlined,
                    label: 'Demo',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DemoScreen(
                            onGoToSquare: widget.onGoToSquare,
                          ),
                        ),
                      );
                    },
                  ),
                  ActionIcon(
                    icon: Icons.person_outline,
                    label: 'Referral',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ReferralScreen(),
                        ),
                      );
                    },
                  ),
                  ActionIcon(
                    icon: Icons.emoji_events_outlined,
                    label: 'Mining',
                    onTap: () {
                      // TODO: Navigate to Mining screen
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Mining feature coming soon!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            // Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Zero Swap Fee Banner (Placeholder)',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Coupon and Mining cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'My Coupon\nView now',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'BDCMining\nOpen treasure chest',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar (Recommend, My List, Forex, Crypto, Metals)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, bottom: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(tabNames.length, (index) {
                    final isSelected = selectedTabIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: isSelected
                            ? BoxDecoration(
                                border: Border(
                                  bottom:
                                      BorderSide(color: Colors.black, width: 2),
                                ),
                              )
                            : null,
                        child: Text(
                          tabNames[index],
                          style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 16,
                            color: isSelected ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            // Table header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: const [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Symbol',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Buy Price',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Sell Price',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            // Trading instrument rows based on selected tab
            Builder(
              builder: (context) {
                final filteredInstruments = _getFilteredInstruments();

                if (selectedTabIndex == 1 && filteredInstruments.isEmpty) {
                  // Show "Add favorites" when My List is empty
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.star_border,
                              size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'Add favorites',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Tap the star icon next to any instrument\nto add it to your favorites',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredInstruments.length,
                  itemBuilder: (context, index) {
                    final instrument = filteredInstruments[index];
                    final isFavorite =
                        favoriteInstruments.contains(instrument['name']);

                    return Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          // Star icon for favorites
                          GestureDetector(
                            onTap: () => _toggleFavorite(instrument['name']),
                            child: Container(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(
                                isFavorite ? Icons.star : Icons.star_border,
                                color: isFavorite
                                    ? Colors.orange
                                    : Colors.grey.shade400,
                                size: 20,
                              ),
                            ),
                          ),
                          // Instrument details
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      instrument['name'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    if (instrument['showFire']) ...[
                                      const SizedBox(width: 4),
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange,
                                        size: 16,
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      instrument['change'],
                                      style: TextStyle(
                                        color: instrument['isUp']
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      instrument['percent'],
                                      style: TextStyle(
                                        color: instrument['isUp']
                                            ? Colors.green
                                            : Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Icon(
                                      instrument['isUp']
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down,
                                      color: instrument['isUp']
                                          ? Colors.green
                                          : Colors.red,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Buy price
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    instrument['buyPrice'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 2),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 4, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      instrument['buyDiff'],
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Sell price
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                instrument['sellPrice'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            // Risk warning
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: const [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Trading Derivatives carries a high level of risk to your capital and you should only trade with money you can afford to lose.',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Text(
              'Views',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 40),
            Text(
              'Calendar',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(width: 40),
            Text(
              'Analysis',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => showExpandableAnalysisSheet(context),
              child: Icon(Icons.keyboard_arrow_up, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomerServiceDialog extends StatelessWidget {
  const CustomerServiceDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Customer Service',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle
            const Text(
              'Please choose the way to get the verification code',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            // Online Support Section
            Row(
              children: [
                // Icon
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: const Icon(
                    Icons.headset_mic,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                // Text content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Online support',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '7x24Hour online',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Start Chat Button
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const chat.ForexDanaChatbot(),
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.grey, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Start Chat',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Footer text
            RichText(
              text: const TextSpan(
                style: TextStyle(fontSize: 12, color: Colors.grey),
                children: [
                  TextSpan(
                    text:
                        'If you do not receive the verification code, please ',
                  ),
                  TextSpan(
                    text: 'contact customer service',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
