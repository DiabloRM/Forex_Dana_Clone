import 'package:flutter/material.dart';
import 'package:forexdana/features/auth/screens/account_setting.dart';
import 'package:forexdana/core/utils/security.dart';
import 'package:forexdana/features/dashboard/screens/settings_screen.dart';
import 'package:forexdana/features/dashboard/screens/task_screen.dart';
import 'package:forexdana/features/dashboard/screens/demo_screen.dart';
import 'package:forexdana/features/dashboard/screens/calculator_screen.dart';
import 'package:forexdana/features/auth/screens/verification_screen.dart';
import '../../../core/theme/app_theme.dart';
import 'referral_screen.dart';
import 'package:forexdana/features/chat/screens/customer_support.dart' as chat;

class UserScreen extends StatefulWidget {
  final Function(AppThemeMode)? onThemeChanged;

  const UserScreen({Key? key, this.onThemeChanged}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _switchNetworkEnabled = false;

  void _showThemeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Theme',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildThemeOption(
                context,
                Icons.light_mode,
                'Light Theme',
                'Use light colors',
                AppThemeMode.light,
              ),
              const SizedBox(height: 12),
              _buildThemeOption(
                context,
                Icons.dark_mode,
                'Dark Theme',
                'Use dark colors',
                AppThemeMode.dark,
              ),
              const SizedBox(height: 12),
              _buildThemeOption(
                context,
                Icons.brightness_auto,
                'System Theme',
                'Follow system setting',
                AppThemeMode.system,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    AppThemeMode mode,
  ) {
    return InkWell(
      onTap: () {
        if (widget.onThemeChanged != null) {
          widget.onThemeChanged!(mode);
        }
        Navigator.of(context).pop();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 24, color: Colors.grey.shade700),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined, color: Colors.black),
            onPressed: () {
              _showThemeOptions(context);
            },
            tooltip: 'Change Theme',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: Colors.black),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const AccountSettingScreen(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          // Profile Avatar
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Profile Info
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Demo',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'demo123@gmail.com',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Action Icons
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.qr_code,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.orange.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.mail,
                          size: 20,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Icon(
                          Icons.content_copy,
                          size: 20,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Phone Binding Banner
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Colors.green.shade800, Colors.green.shade600],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Phone illustration
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const BoxDecoration(
                        color: Colors.white24,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Text content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Phone binding',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                              children: [
                                const TextSpan(text: 'Receive a '),
                                TextSpan(
                                  text: '1000 BDC',
                                  style: TextStyle(
                                    color: Colors.orange.shade300,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const TextSpan(text: ' reward.'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Arrow button
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.orange.shade600,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Recommend Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Recommend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Recommend Grid
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // First row
                  Row(
                    children: [
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.assignment_turned_in_outlined,
                          'Check in',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const BDCMiningApp(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.card_giftcard_outlined,
                          'Referral',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ReferralScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.trending_up,
                          'DEMO',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const DemoScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.calculate_outlined,
                          'Calculator',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const CalculatorScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Second row
                  Row(
                    children: [
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.verified_user_outlined,
                          'Verification',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => EmailVerificationPage(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.send_outlined,
                          'Social',
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.security_outlined,
                          'Security',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const SecurityScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.help_outline,
                          'Tutorial',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Third row
                  Row(
                    children: [
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.local_offer_outlined,
                          'Coupon',
                        ),
                      ),
                      Expanded(
                        child: _buildRecommendItem(
                          Icons.mic_outlined,
                          'Live Chat',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const chat.ForexDanaChatbot(),
                              ),
                            );
                          },
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Switch Network Section
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.language, color: Colors.black, size: 24),
                      const SizedBox(width: 12),
                      const Text(
                        'Switch network',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Switch(
                        value: _switchNetworkEnabled,
                        onChanged: (bool value) {
                          setState(() {
                            _switchNetworkEnabled = value;
                          });
                        },
                        activeColor: Colors.white,
                        activeTrackColor: Colors.green,
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey.shade300,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Turn this on when network connection is abnormal. If it does not work, please close it.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Version Info
            Center(
              child: Text(
                'Current version: 1.8.4Build1184',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendItem(IconData icon, String label,
      {Function()? onPressed}) {
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        } else {
          _handleRecommendItemTap(label);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24, color: Colors.grey.shade700),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _handleRecommendItemTap(String label) {
    // Handle different recommendation item taps
    switch (label.toLowerCase()) {
      case 'check in':
        _showFeatureDialog('Check In', 'Daily check-in rewards available!');
        break;
      case 'referral':
        _showFeatureDialog(
          'Referral Program',
          'Invite friends and earn rewards!',
        );
        break;
      case 'demo':
        _showFeatureDialog(
          'Demo Account',
          'Practice trading with virtual money.',
        );
        break;
      case 'calculator':
        _showFeatureDialog(
          'Trading Calculator',
          'Calculate your potential profits.',
        );
        break;
      case 'verification':
        _showFeatureDialog(
          'Account Verification',
          'Verify your account for full access.',
        );
        break;
      case 'social':
        _showFeatureDialog('Social Trading', 'Connect with other traders.');
        break;
      case 'tutorial':
        _showFeatureDialog(
          'Trading Tutorial',
          'Learn how to trade effectively.',
        );
        break;
      case 'coupon':
        _showFeatureDialog(
          'My Coupons',
          'View your available coupons and discounts.',
        );
        break;
      case 'live chat':
        _showFeatureDialog('Live Chat', 'Connect with customer support 24/7.');
        break;
    }
  }

  void _showFeatureDialog(String title, String description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(description),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
