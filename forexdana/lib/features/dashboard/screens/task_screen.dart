import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BDCMiningApp extends StatefulWidget {
  const BDCMiningApp({Key? key}) : super(key: key);

  @override
  State<BDCMiningApp> createState() => _BDCMiningAppState();
}

class _BDCMiningAppState extends State<BDCMiningApp>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: const Color(0xFF00C896),
      // Updated AppBar to match the screenshot
      appBar: AppBar(
        backgroundColor: const Color(0xFF00C896),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  color: Color(0xFF4A90E2),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    'B',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                '4.98',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ),
        // Added action icons to the AppBar
        actions: [
          IconButton(
              icon: const Icon(Icons.calendar_month, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.card_giftcard, color: Colors.white),
              onPressed: () {}),
          IconButton(
              icon: const Icon(Icons.airplane_ticket_rounded,
                  color: Colors.white),
              onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Status bar and header
          Container(
            padding: EdgeInsets.only(
              top: 8,
              left: 16,
              right: 16,
              bottom: 0,
            ),
            child: Column(
              children: [
                // Title section
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Mining for BDC:',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Accumulate BDC, and enjoy\ndividends and recovery rewards!',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      child: Stack(
                        children: [
                          // Main coin
                          Positioned(
                            right: 0,
                            top: 10,
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4A90E2),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'B',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Secondary coin
                          Positioned(
                            left: 0,
                            bottom: 0,
                            child: Container(
                              width: 35,
                              height: 35,
                              decoration: const BoxDecoration(
                                color: Color(0xFF6B73FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text(
                                  'B',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          // Content area
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8F9FA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  // Tab bar
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: TabBar(
                      controller: _tabController,
                      indicator: const BoxDecoration(),
                      labelColor: const Color(0xFF00C896),
                      unselectedLabelColor: const Color(0xFF9CA3AF),
                      labelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'System tasks (9)'),
                        Tab(text: 'Daily mission (4)'),
                      ],
                    ),
                  ),
                  // Active tab indicator
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 8),
                    child: Row(
                      children: [
                        Container(
                          width: 120,
                          height: 3,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00C896),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tasks list
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTasksList(),
                        _buildDailyMissionsList(), // Implemented this
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTasksList() {
    final tasks = [
      TaskItem(
        icon: Icons.phone_android,
        iconColor: const Color(0xFF4ADE80),
        title: 'Bind Phone Number',
        reward: 'x1',
        rewardIcon: '🧩',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.person_outline,
        iconColor: const Color(0xFFF59E0B),
        title: 'Identity Verification',
        reward: 'x1',
        rewardIcon: '🧩',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.gamepad_outlined,
        iconColor: const Color(0xFFEF4444),
        title: 'Open Demo Account Order',
        reward: '+5',
        rewardIcon: '🎁',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.person_add_outlined,
        iconColor: const Color(0xFF10B981),
        title: 'Invite Your Friends',
        subtitle: '0/3',
        reward: '+100',
        rewardIcon: 'B',
        rewardIconColor: const Color(0xFF4A90E2),
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.people_outline,
        iconColor: const Color(0xFF10B981),
        title: 'Referred Friends: ID Verified',
        subtitle: '0/3',
        reward: '+100',
        rewardIcon: 'B',
        rewardIconColor: const Color(0xFF4A90E2),
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.trending_up,
        iconColor: const Color(0xFF10B981),
        title: 'Referred Friends: Trade in Re...',
        subtitle: '0/3',
        reward: 'x1',
        rewardIcon: '🟪',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.show_chart,
        iconColor: const Color(0xFFEF4444),
        title: 'Set Take Profit/Stop Loss',
        reward: '+5',
        rewardIcon: '🎁',
        buttonText: 'Complete Now',
        buttonColor: const Color(0xFFEAB308),
      ),
      TaskItem(
        icon: Icons.account_balance_wallet_outlined,
        iconColor: const Color(0xFFEF4444),
        title: 'Demo Account Profit',
        reward: '+10',
        rewardIcon: '🎁',
        buttonText: 'Complete Now',
        buttonColor: const Color(0xFFEAB308),
      ),
      TaskItem(
        icon: Icons.timeline,
        iconColor: const Color(0xFFEF4444),
        title: 'Trade a Demo Account for 3 D...',
        reward: '+20',
        rewardIcon: '🎁',
        buttonText: 'Complete Now',
        buttonColor: const Color(0xFFEAB308),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(tasks[index]);
      },
    );
  }

  // Implementation for the "Daily mission" tab
  Widget _buildDailyMissionsList() {
    final dailyMissions = [
      TaskItem(
        icon: Icons.bar_chart,
        iconColor: const Color(0xFF4ADE80),
        title: 'Daily Trading',
        reward: '+500',
        rewardIcon: 'B',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.gamepad_outlined,
        iconColor: const Color(0xFFF472B6),
        title: 'Profit on Demo Account',
        reward: '+500',
        rewardIcon: 'B',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.credit_card,
        iconColor: const Color(0xFF8B5CF6),
        title: 'Saving Account Balance',
        reward: '+5000',
        rewardIcon: 'B',
        buttonText: 'Go',
        buttonColor: const Color(0xFF10B981),
      ),
      TaskItem(
        icon: Icons.calendar_today,
        iconColor: const Color(0xFFF59E0B),
        title: 'Daily Check-In',
        reward: 'x1',
        rewardIcon: '🎁',
        buttonText: 'Checked in',
        buttonColor: const Color(0xFFE5E7EB),
        buttonTextColor: const Color(0xFF6B7280),
      ),
    ];

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: dailyMissions.length,
      itemBuilder: (context, index) {
        return _buildTaskItem(dailyMissions[index]);
      },
    );
  }

  Widget _buildTaskItem(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: task.iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              task.icon,
              color: task.iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                if (task.subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    task.subtitle!,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                // Reward
                Row(
                  children: [
                    if (task.rewardIcon == 'B')
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color:
                              task.rewardIconColor ?? const Color(0xFF4A90E2),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Text(
                            'B',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                    else
                      Text(
                        task.rewardIcon,
                        style: const TextStyle(fontSize: 16),
                      ),
                    const SizedBox(width: 6),
                    Text(
                      task.reward,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: task.buttonColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              task.buttonText,
              style: TextStyle(
                // Updated to handle different text colors
                color: task.buttonTextColor ?? Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Updated TaskItem model to support custom button text color
class TaskItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final String reward;
  final String rewardIcon;
  final Color? rewardIconColor;
  final String buttonText;
  final Color buttonColor;
  final Color? buttonTextColor;

  TaskItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.reward,
    required this.rewardIcon,
    this.rewardIconColor,
    required this.buttonText,
    required this.buttonColor,
    this.buttonTextColor,
  });
}
