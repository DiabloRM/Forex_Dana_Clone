import 'package:flutter/material.dart';
import '../../auth/screens/account_setting.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AccountSettingScreen(),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: Colors.grey.shade300,
                          child: Icon(
                            Icons.person,
                            color: Colors.grey.shade700,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Demo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Demo@gmail.com',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.verified_user,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.email, color: Colors.orange, size: 22),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.phone_android,
                        color: Colors.grey.shade400,
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.nightlight_round, color: Colors.black, size: 26),
                  const SizedBox(width: 8),
                  Icon(Icons.settings, color: Colors.black, size: 26),
                ],
              ),
            ),
            // Phone binding banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Container(
                    decoration: BoxDecoration(
                      color: Colors.green.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Icon(
                      Icons.phone_android,
                      color: Colors.green.shade700,
                      size: 32,
                    ),
                  ),
                  title: const Text(
                    'Phone binding',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: const Text(
                    'Receive a 1000 BDC reward.',
                    style: TextStyle(color: Colors.white70),
                  ),
                  trailing: Container(
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ),
            ),
            // Recommend grid
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        'Recommend',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 0.9,
                        children: const [
                          _RecommendIcon(
                            icon: Icons.event_available,
                            label: 'Check in',
                          ),
                          _RecommendIcon(
                            icon: Icons.favorite_border,
                            label: 'Referral',
                          ),
                          _RecommendIcon(
                            icon: Icons.sports_esports,
                            label: 'DEMO',
                          ),
                          _RecommendIcon(
                            icon: Icons.calculate,
                            label: 'Calculator',
                          ),
                          _RecommendIcon(
                            icon: Icons.verified_user,
                            label: 'Verificati…',
                          ),
                          _RecommendIcon(icon: Icons.send, label: 'Social'),
                          _RecommendIcon(
                            icon: Icons.security,
                            label: 'Security',
                          ),
                          _RecommendIcon(
                            icon: Icons.help_outline,
                            label: 'Tutorial',
                          ),
                          _RecommendIcon(
                            icon: Icons.card_giftcard,
                            label: 'Coupon',
                          ),
                          _RecommendIcon(
                            icon: Icons.headset_mic,
                            label: 'Live Chat',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Switch network
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.language, color: Colors.black),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Switch network',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Switch(value: false, onChanged: null),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Turn this on when network connection is abnormal. If it does not work, please close it.',
                        style: TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Version info
                    Center(
                      child: Text(
                        'Current version:  1.8.4Build1184',
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecommendIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _RecommendIcon({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade100,
          radius: 24,
          child: Icon(icon, color: Colors.black, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: Colors.black),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
