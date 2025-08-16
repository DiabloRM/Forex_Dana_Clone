import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool confirmOpenClose = true;
  bool confirmDeposit = true;
  bool confirmOrder = true;
  bool securityCode = false;
  bool enableNotifications = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // App bar with title and back button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Settings',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Balance the back button
                ],
              ),
            ),

            // Settings list
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 0),
                children: [
                  const SizedBox(height: 8),

                  // Language
                  _buildSettingItem(
                    'Language',
                    'English',
                    Icons.language,
                    onTap: () {},
                  ),

                  // Check Version
                  _buildSettingItem(
                    'Check Version',
                    'Is the latest version',
                    Icons.system_update,
                    onTap: () {},
                  ),

                  // Display Settings
                  _buildSettingItem(
                    'Display Settings',
                    'Green for bull candle',
                    Icons.display_settings,
                    onTap: () {},
                  ),

                  // Local Currency
                  _buildSettingItem(
                    'Local Currency',
                    'USD',
                    Icons.attach_money,
                    onTap: () {},
                  ),

                  // About Us
                  _buildSettingItem(
                    'About Us',
                    '',
                    Icons.info_outline,
                    onTap: () {},
                  ),

                  // Feedback
                  _buildSettingItem(
                    'Feedback',
                    '',
                    Icons.feedback_outlined,
                    onTap: () {},
                  ),

                  // Anti-Money Laundering
                  _buildSettingItem(
                    'Anti-Money Laundering',
                    '',
                    Icons.security,
                    onTap: () {},
                  ),

                  // Privacy Policy
                  _buildSettingItem(
                    'Privacy Policy',
                    '',
                    Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),

                  // Network detection
                  _buildSettingItem(
                    'Network detection',
                    '',
                    Icons.network_check,
                    onTap: () {},
                  ),

                  // Upload log
                  _buildSettingItem(
                    'Upload log',
                    '',
                    Icons.upload_file,
                    onTap: () {},
                  ),

                  const SizedBox(height: 16),

                  // Toggle settings
                  _buildToggleItem(
                    'Confirm Open/Close P...',
                    confirmOpenClose,
                    (value) => setState(() => confirmOpenClose = value),
                  ),

                  _buildToggleItem(
                    'Confirm Deposit',
                    confirmDeposit,
                    (value) => setState(() => confirmDeposit = value),
                  ),

                  _buildToggleItem(
                    'Confirm your order',
                    confirmOrder,
                    (value) => setState(() => confirmOrder = value),
                  ),

                  _buildToggleItem(
                    'Security Code',
                    securityCode,
                    (value) => setState(() => securityCode = value),
                  ),

                  _buildToggleItem(
                    'Enable Notifications',
                    enableNotifications,
                    (value) => setState(() => enableNotifications = value),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Icon(icon, color: Colors.black87, size: 22),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            : null,
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.black54,
          size: 18,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildToggleItem(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.orange,
          activeTrackColor: Colors.orange.shade200,
          inactiveThumbColor: Colors.grey.shade400,
          inactiveTrackColor: Colors.grey.shade300,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}
