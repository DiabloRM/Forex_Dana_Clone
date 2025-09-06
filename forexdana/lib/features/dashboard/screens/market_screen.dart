import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import '../../../core/models/instrument_quote.dart';
import '../../../core/network/api_client.dart';
import '../../../core/network/binance_client.dart';
import '../../market/state/market_provider.dart';
import '../../trading/screens/trading_screen.dart';
import '../widgets/action_icon.dart';
// import '../widgets/instrument_row.dart';
import 'user_screen.dart';
import '../../chat/screens/customer_support.dart' as chat;
import '../../../core/theme/app_theme.dart';
import '../../wallet/screens/deposit_screen.dart';
import 'demo_screen.dart';
import 'task_screen.dart';
import 'referral_screen.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/navigation/navigation_service.dart';
import '../widgets/expandable_analysis_sheet.dart';

class MarketScreen extends StatefulWidget {
  final Function(int)? onGoToSquare;
  final Function(AppThemeMode)? onThemeChanged;

  const MarketScreen({Key? key, this.onGoToSquare, this.onThemeChanged})
      : super(key: key);

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> with SingleTickerProviderStateMixin {
  int selectedTabIndex = 0;
  Set<String> favoriteInstruments = {}; // Store user's favorite instruments
  int _currentBannerIndex = 0;
  late Timer _bannerTimer;
  late PageController _pageController;
  
  final List<String> _bannerImages = [
    'assets/market_1.jpeg',
    'assets/market_2.jpeg',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Start the banner timer. First image stays for 10 seconds, then switch every 10s.
    _bannerTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      final next = (_currentBannerIndex + 1) % _bannerImages.length;
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
      setState(() {
        _currentBannerIndex = next;
      });
    });
  }

  @override
  void dispose() {
    _bannerTimer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  final List<String> tabNames = [
    'Recommend',
    'My List',
    'Forex',
    'Crypto',
    'Metals',
    'Stocks'
  ];

  List<InstrumentQuote> allQuotes = [];

  String _toTradingSymbol(String name) {
    if (name == 'XAUUSD') return 'XAU/USD';
    if (name.endsWith('/USDT')) return name.replaceAll('/USDT', '/USD');
    return name;
  }

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

  List<InstrumentQuote> _getFilteredInstruments() {
    switch (selectedTabIndex) {
      case 0: // Recommend
        return allQuotes;
      case 1: // My List
        return allQuotes
            .where((q) => favoriteInstruments.contains(q.name))
            .toList();
      case 2: // Forex
        return allQuotes.where((q) => q.category == 'forex').toList();
      case 3: // Crypto
        return allQuotes.where((q) => q.category == 'crypto').toList();
      case 4: // Metals
        return allQuotes.where((q) => q.category == 'metals').toList();
      case 5: // Stocks
        return allQuotes.where((q) => q.category == 'stocks').toList();
      default:
        return allQuotes;
    }
  }

  String _formatSpread(double buyPrice, double sellPrice) {
    final spread = (buyPrice - sellPrice).abs();
    return spread.toStringAsFixed(spread < 1 ? 3 : 2);
  }

  int _getDecimalPlaces(String instrumentName) {
    if (instrumentName.contains('BTC') || instrumentName.contains('ETH')) {
      return 2;
    } else if (instrumentName.contains('USD')) {
      return 5;
    }
    return 3;
  }

  // Builds price text like 110314.10 with heavier decimals as in screenshot
  // Build price text with adjustable decimal places. Integer part and decimals
  // use slightly different weights so decimals appear heavier (like screenshot).
  Widget _buildPillPriceText(double price, int decimalPlaces) {
    final parts = price.toStringAsFixed(decimalPlaces).split('.');
    final integer = parts[0];
    final decimal = parts.length > 1 ? parts[1] : '';
    // Use FittedBox to make long prices scale down inside compact pills.
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: integer,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (decimal.isNotEmpty) ...[
              const TextSpan(
                text: '.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: decimal,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAccurateInstrumentRow(InstrumentQuote q) {
  final isFavorite = favoriteInstruments.contains(q.name);
  final decimalPlaces = _getDecimalPlaces(q.name);

    return InkWell(
      onTap: () {
        final sym = _toTradingSymbol(q.name);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => TradingScreen(initialSymbol: sym),
          ),
        );
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.shade100,
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            // Left section - Instrument info
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  // Star icon
                  GestureDetector(
                    onTap: () => _toggleFavorite(q.name),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      margin: const EdgeInsets.only(right: 12),
                      child: Icon(
                        isFavorite ? Icons.star : Icons.star_border,
                        color:
                            isFavorite ? Colors.orange : Colors.grey.shade400,
                        size: 18,
                      ),
                    ),
                  ),

                  // Instrument details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Instrument name
                        Text(
                          q.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),

                        // Price change row
                        Row(
                          children: [
                            // Change amount with arrow
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  q.changeFormatted,
                                  style: TextStyle(
                                    color: q.isUp ? Colors.red : Colors.green,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(width: 2),
                                Icon(
                                  q.isUp
                                      ? Icons.keyboard_arrow_down
                                      : Icons.keyboard_arrow_up,
                                  color: q.isUp ? Colors.red : Colors.green,
                                  size: 16,
                                ),
                              ],
                            ),
                            const SizedBox(width: 8),

                            // Percentage change
                            Text(
                              q.percentFormatted,
                              style: TextStyle(
                                color: q.isUp ? Colors.red : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Fire icon (trending indicator)
                            Icon(
                              Icons.local_fire_department,
                              color: Colors.orange,
                              size: 14,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Right section - Price pills with center spread bubble (match screenshot)
            Expanded(
              flex: 4,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Green buy pill (left)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 100,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFF5FAE8E), // soft green
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: _buildPillPriceText(q.buyPrice, decimalPlaces),
                      ),
                    ),
                  ),

                  // Red sell pill (right)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 100,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD96666), // soft red
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: _buildPillPriceText(q.sellPrice, decimalPlaces),
                      ),
                    ),
                  ),

                  // Center white spread bubble overlapping both pills
                  Center(
                    child: Container(
                      width: 56,
                      height: 24,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200, width: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        _formatSpread(q.buyPrice, q.sellPrice),
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                        textAlign: TextAlign.center,
                      ),
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => MarketProvider(ApiClient(), BinanceClient())..load(),
        child: Scaffold(
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
                  child: AppIcons.getIcon(AppIcons.user,
                      color: Colors.grey.shade600, size: AppIcons.sizeMedium),
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
                  AppIcons.getIcon(AppIcons.search,
                      color: Colors.grey.shade500, size: AppIcons.sizeMedium),
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
              // Auto-refresh toggle button
              Consumer<MarketProvider>(
                builder: (context, marketProvider, _) {
                  return IconButton(
                    icon: Icon(
                      marketProvider.isAutoRefreshEnabled
                          ? Icons.timer
                          : Icons.timer_off,
                      color: marketProvider.isAutoRefreshEnabled
                          ? Colors.green
                          : Colors.grey,
                    ),
                    onPressed: () => marketProvider.toggleAutoRefresh(),
                    tooltip: marketProvider.isAutoRefreshEnabled
                        ? 'Auto-refresh enabled'
                        : 'Auto-refresh disabled',
                  );
                },
              ),
              // Refresh button
              Consumer<MarketProvider>(
                builder: (context, marketProvider, _) {
                  return IconButton(
                    icon: Icon(
                      marketProvider.loading
                          ? Icons.refresh
                          : Icons.refresh_outlined,
                      color:
                          marketProvider.loading ? Colors.blue : Colors.black,
                    ),
                    onPressed: marketProvider.loading
                        ? null
                        : () => marketProvider.load(),
                  );
                },
              ),
              IconButton(
                icon:
                    const Icon(Icons.headset_mic_outlined, color: Colors.black),
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
          body: Consumer<MarketProvider>(builder: (context, mp, _) {
            if (mp.loading && mp.quotes.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text(
                      'Loading market data...',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Fetching real-time forex data',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            if (mp.error != null && mp.quotes.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading market data',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      mp.error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => mp.load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            allQuotes = mp.quotes;
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // removed top banner (kept small spacer)
                      const SizedBox(height: 8),
                      // My Assets section
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'My Assets',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 14),
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
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 12),
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
                              icon: AppIcons.task,
                              label: 'Task',
                              isNew: true,
                              onTap: () {
                                NavigationService()
                                    .navigateToPage(const BDCMiningApp());
                              },
                            ),
                            ActionIcon(
                              icon: AppIcons.demo,
                              label: 'Demo',
                              onTap: () {
                                NavigationService().navigateToPage(DemoScreen(
                                  onGoToSquare: widget.onGoToSquare,
                                ));
                              },
                            ),
                            ActionIcon(
                              icon: AppIcons.referral,
                              label: 'Referral',
                              onTap: () {
                                NavigationService()
                                    .navigateToPage(const ReferralScreen());
                              },
                            ),
                            ActionIcon(
                              icon: AppIcons.mining,
                              label: 'Mining',
                              onTap: () {
                                // TODO: Navigate to Mining screen
                                NavigationService().showSnackBar(
                                  message: 'Mining feature coming soon!',
                                  duration: const Duration(seconds: 2),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // Banner carousel (swaps right-to-left) — size increased
                      Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: _bannerImages.length,
                              onPageChanged: (idx) {
                                setState(() {
                                  _currentBannerIndex = idx;
                                });
                              },
                              itemBuilder: (context, index) {
                                // map index to url
                                final url = index == 0
                                    ? Uri.parse('https://www.youtube.com/watch?v=Gk143pJ43D4')
                                    : Uri.parse('https://www.btcdana.com/');
                                return GestureDetector(
                                  onTap: () async {
                                    try {
                                      final launched = await launchUrl(url,
                                          mode: LaunchMode.externalApplication);
                                      if (!launched) {
                                        if (!mounted) return;
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Could not open link.'),
                                          ),
                                        );
                                      }
                                    } on MissingPluginException {
                                      // Plugin not registered on this platform (common after adding a new plugin without rebuilding)
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Platform plugin not registered. Stop the app and rebuild.'),
                                        ),
                                      );
                                    } catch (e) {
                                      if (!mounted) return;
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Error opening link: $e'),
                                        ),
                                      );
                                    }
                                  },
                                  child: Image.asset(
                                    _bannerImages[index],
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                            ),
                            // Dots indicator
                            Positioned(
                              right: 8,
                              bottom: 8,
                              child: Row(
                                children: List.generate(_bannerImages.length,
                                    (i) {
                                  final active = i == _currentBannerIndex;
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 2),
                                    width: active ? 10 : 6,
                                    height: active ? 10 : 6,
                                    decoration: BoxDecoration(
                                      color: active
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Coupon and Mining cards
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
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
                        padding:
                            const EdgeInsets.only(left: 16, top: 16, bottom: 8),
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
                                            bottom: BorderSide(
                                                color: Colors.black, width: 2),
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
                                      color: isSelected
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                      // Refresh Animation (below tabs)
                      Consumer<MarketProvider>(
                        builder: (context, marketProvider, _) {
                          if (marketProvider.loading &&
                              marketProvider.quotes.isNotEmpty) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.blue.shade600),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Refreshing market data...',
                                    style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Market Overview Summary
                      Consumer<MarketProvider>(
                        builder: (context, marketProvider, _) {
                          final quotes = marketProvider.quotes;
                          if (quotes.isEmpty) return const SizedBox.shrink();

                          final forexCount =
                              quotes.where((q) => q.category == 'forex').length;
                          final cryptoCount = quotes
                              .where((q) => q.category == 'crypto')
                              .length;
                          final metalsCount = quotes
                              .where((q) => q.category == 'metals')
                              .length;
                          final stocksCount = quotes
                              .where((q) => q.category == 'stocks')
                              .length;
                          final openMarkets = quotes
                              .where((q) => q.isMarketOpen == true)
                              .length;

                          // Get latest update time
                          final quotesWithDateTime = quotes
                              .where((q) =>
                                  q.datetime != null && q.datetime!.isNotEmpty)
                              .toList();
                          String latestUpdate = 'Unknown';
                          if (quotesWithDateTime.isNotEmpty) {
                            try {
                              final latest = quotesWithDateTime
                                  .map((q) => DateTime.parse(q.datetime!))
                                  .reduce((a, b) => a.isAfter(b) ? a : b);
                              latestUpdate =
                                  '${latest.hour.toString().padLeft(2, '0')}:${latest.minute.toString().padLeft(2, '0')}';
                            } catch (e) {
                              latestUpdate = 'Unknown';
                            }
                          }

                          return Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            padding: const EdgeInsets.all(16),
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
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Market Overview',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey.shade800,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    _buildSummaryItem('Forex', '$forexCount',
                                        Colors.blue.shade600),
                                    const SizedBox(width: 16),
                                    _buildSummaryItem('Crypto', '$cryptoCount',
                                        Colors.orange.shade600),
                                    const SizedBox(width: 16),
                                    _buildSummaryItem('Metals', '$metalsCount',
                                        Colors.amber.shade600),
                                    const SizedBox(width: 16),
                                    _buildSummaryItem('Stocks', '$stocksCount',
                                        Colors.purple.shade600),
                                    const SizedBox(width: 16),
                                    _buildSummaryItem('Open', '$openMarkets',
                                        Colors.green.shade600),
                                    const Spacer(),
                                    _buildSummaryItem('Updated', latestUpdate,
                                        Colors.grey.shade600),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),

                      // Table header
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 3,
                              child: Text(
                                'Trading Instruments',
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Buy Price',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                            SizedBox(width: 8),
                            SizedBox(
                              width: 80,
                              child: Text(
                                'Sell Price',
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Trading instrument rows based on selected tab
                      Builder(
                        builder: (context) {
                          final filteredInstruments = _getFilteredInstruments();

                          if (selectedTabIndex == 1 &&
                              filteredInstruments.isEmpty) {
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
                              final q = filteredInstruments[index];
                              return _buildAccurateInstrumentRow(q);
                            },
                          );
                        },
                      ),
                      // Risk warning
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
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
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          bottomNavigationBar: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                // Views Tab
                GestureDetector(
                  onTap: () {
                    showExpandableAnalysisSheet(context, initialTabIndex: 0);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Views',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Calendar Tab
                GestureDetector(
                  onTap: () {
                    showExpandableAnalysisSheet(context, initialTabIndex: 1);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Calendar',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                // Analysis Tab
                GestureDetector(
                  onTap: () {
                    showExpandableAnalysisSheet(context, initialTabIndex: 2);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Analysis',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                // Up Arrow Button
                GestureDetector(
                  onTap: () {
                    showExpandableAnalysisSheet(context, initialTabIndex: 0);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: AppIcons.getIcon(
                      AppIcons.up,
                      color: Colors.blue.shade700,
                      size: AppIcons.sizeMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildSummaryItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
          ),
        ),
      ],
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
