import 'package:flutter/material.dart';

class PositionsScreen extends StatelessWidget {
  const PositionsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {},
          ),
          title: Row(
            children: [
              Icon(Icons.add_box_outlined, color: Colors.black, size: 22),
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
            TextButton(
              onPressed: () {},
              child: const Text(
                'Switch',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.sync_alt, color: Colors.black),
              onPressed: () {},
            ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _Tab(label: 'Position', isActive: false),
                _Tab(label: 'Pending Order', isActive: false),
                _Tab(label: 'Weekly Order', isActive: true),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // Empty state
          Expanded(
            child: Column(
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
            ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool isActive;
  const _Tab({required this.label, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: isActive ? Colors.black : Colors.grey,
        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        fontSize: 16,
      ),
    );
  }
}
