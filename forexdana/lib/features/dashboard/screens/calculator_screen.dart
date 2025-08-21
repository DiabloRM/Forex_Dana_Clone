import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  double lotSize = 0.01;
  double profitPoints = 0.0;
  double currentPrice = 116324.60;
  bool isProfit = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {
        isProfit = _tabController.index == 1;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildLotSizeButton(double value) {
    bool isSelected = lotSize == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          lotSize = value;
        });
      },
      child: Container(
        width: 80,
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFF1DB584) : Colors.grey.shade300,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? Colors.transparent : Colors.white,
        ),
        child: Center(
          child: Text(
            value.toString(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isSelected ? const Color(0xFF1DB584) : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1DB584),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1DB584),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => _tabController.animateTo(0),
              child: Text(
                'Margin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: _tabController.index == 0
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _tabController.animateTo(1),
              child: Text(
                'Profit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: _tabController.index == 1
                      ? FontWeight.w600
                      : FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(top: 16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildMarginTab(),
                  _buildProfitTab(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarginTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Margin',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '\$3.64',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildTradingPairSection(),
          const SizedBox(height: 30),
          _buildLotSizeSection(),
          const SizedBox(height: 40),
          _buildPriceSection(),
          const SizedBox(height: 60),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildProfitTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Profit',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
              const Spacer(),
              Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
            ],
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              '\$0.00',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          const SizedBox(height: 40),
          _buildTradingPairSection(),
          const SizedBox(height: 30),
          _buildLotSizeSection(),
          const SizedBox(height: 30),
          _buildProfitPointsSection(),
          const SizedBox(height: 40),
          _buildPriceSection(),
          const SizedBox(height: 60),
          _buildCalculateButton(),
        ],
      ),
    );
  }

  Widget _buildTradingPairSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose variety/species',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
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
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '₿',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'BTC/USDT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: Colors.grey.shade400),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLotSizeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose lot size',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Icon(Icons.remove, color: Colors.grey.shade400),
            Expanded(
              child: Center(
                child: Text(
                  lotSize.toString(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
            Icon(Icons.add, color: Colors.grey.shade400),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildLotSizeButton(0.01),
            _buildLotSizeButton(0.1),
            _buildLotSizeButton(0.5),
            _buildLotSizeButton(1),
            _buildLotSizeButton(2),
            _buildLotSizeButton(5),
            _buildLotSizeButton(8),
            _buildLotSizeButton(10),
          ],
        ),
      ],
    );
  }

  Widget _buildProfitPointsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFF1DB584),
                    width: 3,
                  ),
                ),
              ),
              child: const Text(
                'Profit points',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 30),
            Text(
              'Opening/Closing price',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          'Enter points/units',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Center(
            child: Text(
              '0.00',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BTC/USDT',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                'Bitcoin/USDT',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                isProfit ? '116324.60' : '116320.10',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Icon(
                    isProfit ? Icons.arrow_upward : Icons.arrow_downward,
                    color: isProfit ? const Color(0xFF1DB584) : Colors.red,
                    size: 12,
                  ),
                  Text(
                    isProfit ? '-1222.50 -1.041%' : '-1237.10 -1.053%',
                    style: TextStyle(
                      fontSize: 12,
                      color: isProfit ? const Color(0xFF1DB584) : Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(Icons.chevron_right, color: Colors.grey.shade400),
        ],
      ),
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          // Calculate logic here
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1DB584),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Calculate',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
