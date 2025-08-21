import 'package:flutter/material.dart';
import '../../trading/screens/trading_screen.dart';

class PositionsScreen extends StatefulWidget {
  const PositionsScreen({Key? key}) : super(key: key);

  @override
  State<PositionsScreen> createState() => _PositionsScreenState();
}

class _PositionsScreenState extends State<PositionsScreen> {
  int _selectedTabIndex = 0;

  void _showSwitchAccountModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 24), // Balance for close button
                    const Text(
                      'Switch account',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Icon(
                        Icons.close,
                        color: Colors.grey.shade600,
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Real Account option
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.attach_money,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Real Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '\$ 0.00',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.orange,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Demo Account option
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xFF5B665B),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.analytics_outlined,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Demo Account',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              '≡ 0.00',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
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
          ),
        );
      },
    );
  }

  Widget _buildPositionTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gift box illustration
        Container(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              // Main box
              Positioned(
                left: 20,
                top: 20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              // Orange coin inside box
              Positioned(
                left: 35,
                top: 35,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Small floating coin
              Positioned(
                left: 10,
                top: 30,
                child: Container(
                  width: 25,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.7),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '\$',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              // Green ribbon
              Positioned(
                left: 15,
                bottom: 15,
                child: Container(
                  width: 20,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              // Floating circles
              Positioned(
                right: 10,
                top: 25,
                child: Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 15,
                top: 45,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'No open orders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 32),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => TradingScreen(),
              ),
            );
          },
          child: Container(
            width: 200,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Center(
              child: Text(
                'Go trade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Document stack illustration
        Container(
          width: 120,
          height: 120,
          child: Stack(
            children: [
              // Back document
              Positioned(
                left: 30,
                top: 40,
                child: Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Middle document
              Positioned(
                left: 25,
                top: 30,
                child: Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              // Front document with orange header
              Positioned(
                left: 20,
                top: 20,
                child: Container(
                  width: 60,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.grey.shade400, width: 1),
                  ),
                  child: Column(
                    children: [
                      // Orange header
                      Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                        ),
                      ),
                      // Text lines - Fixed to prevent overflow
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                              Container(
                                height: 6,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade400,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Spark effect lines
              Positioned(
                right: 10,
                top: 30,
                child: Column(
                  children: [
                    Container(
                      width: 8,
                      height: 2,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 6,
                      height: 2,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 2),
                    Container(
                      width: 10,
                      height: 2,
                      color: Colors.grey.shade400,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'No data',
          style: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildWeeklyOrderTab() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.insert_drive_file_outlined,
          color: Colors.grey.shade400,
          size: 80,
        ),
        const SizedBox(height: 16),
        const Text(
          'Showing data for the last 7 days only',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.analytics_outlined,
                  color: Colors.black,
                  size: 18,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Demo',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          actions: [
            GestureDetector(
              onTap: () => _showSwitchAccountModal(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Switch',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.sync_alt, color: Colors.black, size: 20),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
      body: Column(
        children: [
          // Demo card
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF5B665B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '0.00',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'profit 0.00',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.keyboard_arrow_down, color: Colors.white),
              ],
            ),
          ),
          // Tab bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _Tab(
                    label: 'Position',
                    isActive: _selectedTabIndex == 0,
                    onTap: () => setState(() => _selectedTabIndex = 0),
                  ),
                ),
                Expanded(
                  child: _Tab(
                    label: 'Pending Order',
                    isActive: _selectedTabIndex == 1,
                    onTap: () => setState(() => _selectedTabIndex = 1),
                  ),
                ),
                Expanded(
                  child: _Tab(
                    label: 'Weekly Order',
                    isActive: _selectedTabIndex == 2,
                    onTap: () => setState(() => _selectedTabIndex = 2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Tab content
          Expanded(
            child: _selectedTabIndex == 0
                ? _buildPositionTab()
                : _selectedTabIndex == 1
                    ? _buildPendingOrderTab()
                    : _buildWeeklyOrderTab(),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _Tab({
    required this.label,
    this.isActive = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? Colors.orange : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.grey,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
