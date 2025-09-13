import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forexdana/features/auth/services/auth_service.dart';
import 'package:forexdana/core/navigation/navigation_service.dart';
import 'package:forexdana/features/auth/screens/register_screen.dart';

enum ManualLoginTab { email, phone }

class ManualLoginScreen extends StatefulWidget {
  final ManualLoginTab initialTab;
  const ManualLoginScreen({super.key, this.initialTab = ManualLoginTab.email});

  @override
  State<ManualLoginScreen> createState() => _ManualLoginScreenState();
}

class _ManualLoginScreenState extends State<ManualLoginScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Email
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscure = true;
  bool _emailLoading = false;

  // Phone
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _phonePasswordController =
      TextEditingController(); // Added for phone tab password
  bool _otpSent = false;
  bool _phoneLoading = false;
  String? _verificationId;

  // Country code dropdown
  String _selectedCountryCode = '+977';
  final List<Map<String, String>> _countryCodes = [
    {'code': '+977', 'flag': '🇳🇵', 'country': 'Nepal'},
    {'code': '+1', 'flag': '🇺🇸', 'country': 'USA'},
    {'code': '+44', 'flag': '🇬🇧', 'country': 'UK'},
    {'code': '+91', 'flag': '🇮🇳', 'country': 'India'},
    {'code': '+86', 'flag': '🇨🇳', 'country': 'China'},
    {'code': '+81', 'flag': '🇯🇵', 'country': 'Japan'},
    {'code': '+82', 'flag': '🇰🇷', 'country': 'Korea'},
    {'code': '+61', 'flag': '🇦🇺', 'country': 'Australia'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTab == ManualLoginTab.email ? 0 : 1,
    );

    // Pre-fill dummy credentials for testing
    //_emailController.text = 'test@forexdana.com';
    //_passwordController.text = 'test123';
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _phonePasswordController.dispose(); // Dispose phone password controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        // Added Padding to the body
        padding: const EdgeInsets.symmetric(
            horizontal: 20.0), // Padding for the whole body content
        child: Column(
          children: [
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Log In',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Promotional section with image
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        children: [
                          const TextSpan(text: 'Deposit to Get Up to '),
                          TextSpan(
                            text: '\$1000 Bonus',
                            style: TextStyle(
                              color: Colors.green.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Login illustration image
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Image.asset(
                      'assets/login_img.png', // Ensure this asset path is correct
                      fit: BoxFit.contain,
                    ),
                  ),
                ],
              ),
            ),
            // Tab bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey.shade500,
                indicatorColor: Colors.black,
                indicatorWeight: 2,
                labelStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: 'Email'),
                  Tab(text: 'Phone'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildEmailTab(context),
                  _buildPhoneTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailTab(BuildContext context) {
    final bool canLogin =
        _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _input(
              hint: 'Enter Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            _input(
              hint: 'Enter Password',
              controller: _passwordController,
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password logic
                },
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Spacer(),
            // Log In button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: !_emailLoading && canLogin
                    ? () async {
                        setState(() => _emailLoading = true);
                        final user =
                            await AuthService.instance.signInWithEmailPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );
                        if (!mounted) return;
                        setState(() => _emailLoading = false);
                        if (user == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Invalid credentials or error')),
                          );
                        } else {
                          // Show success message
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Welcome back, ${user.displayName ?? user.email}!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                          // Navigate back to main app - the app state will handle profile navigation
                          // Add a small delay to ensure app state is updated
                          await Future.delayed(
                              const Duration(milliseconds: 300));
                          if (!mounted) return;

                          // Check if we can pop or need to use NavigationService
                          if (Navigator.of(context).canPop()) {
                            Navigator.of(context).pop();
                          } else {
                            // If there's no route to pop to, use NavigationService to navigate to main
                            try {
                              NavigationService()
                                  .navigateToAndClear(AppRoutes.main);
                            } catch (e) {
                              debugPrint('Error navigating after login: $e');
                              // Fallback navigation if the above fails
                              NavigationService()
                                  .navigatorKey
                                  .currentState
                                  ?.pushNamedAndRemoveUntil(
                                    AppRoutes.main,
                                    (route) => false,
                                  );
                            }
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canLogin ? Colors.black87 : Colors.grey.shade300,
                  foregroundColor:
                      canLogin ? Colors.white : Colors.grey.shade600,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _emailLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.white)),
                      )
                    : const Text(
                        'Log In',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Register link
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneTab(BuildContext context) {
    // Determine if the "Log In" button should be enabled for phone tab
    // It should be enabled if both phone number and password are not empty.
    final bool canLoginPhone = _phoneController.text.trim().isNotEmpty &&
        _phonePasswordController.text.trim().isNotEmpty;

    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone number input with country code dropdown
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  // Country code dropdown
                  InkWell(
                    onTap: () => _showCountryCodePicker(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _countryCodes.firstWhere(
                              (c) => c['code'] == _selectedCountryCode,
                              orElse: () => {'flag': '🇳🇵'},
                            )['flag']!,
                            style: const TextStyle(fontSize: 20),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedCountryCode,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_drop_down, size: 20),
                        ],
                      ),
                    ),
                  ),
                  // Phone number input
                  Expanded(
                    child: TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        hintText: 'Enter Phone Number',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      ),
                      onChanged: (_) =>
                          setState(() {}), // Update state on change
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Password field (for phone number login)
            _input(
              hint: 'Enter Password',
              controller:
                  _phonePasswordController, // Use _phonePasswordController
              obscure: _obscure,
              suffix: IconButton(
                icon: Icon(
                  _obscure
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              onChanged: (_) => setState(() {}), // Update state on change
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () {
                  // TODO: Implement forgot password logic for phone
                },
                child: const Text(
                  'Forgot Password ?',
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const Spacer(),
            // Log In button for phone tab
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: !_phoneLoading && canLoginPhone
                    ? () async {
                        // Implement phone number and password login logic here
                        setState(() => _phoneLoading = true);
                        // For demonstration, let's just show a success message
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Logging in with ${_selectedCountryCode}${_phoneController.text} and password'),
                            backgroundColor: Colors.blue,
                          ),
                        );
                        await Future.delayed(const Duration(
                            seconds: 1)); // Simulate network request
                        setState(() => _phoneLoading = false);
                        // In a real app, you would call your AuthService here
                        // For example:
                        // final user = await AuthService.instance.signInWithPhoneNumberAndPassword(
                        //   phoneNumber: '${_selectedCountryCode}${_phoneController.text}',
                        //   password: _phonePasswordController.text,
                        // );
                        // if (user != null) {
                        //   // Handle successful login
                        // } else {
                        //   // Handle error
                        // }

                        // After successful login, you would navigate.
                        // For this example, let's just pop or navigate to main.
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop();
                        } else {
                          try {
                            NavigationService()
                                .navigateToAndClear(AppRoutes.main);
                          } catch (e) {
                            debugPrint(
                                'Error navigating after phone login: $e');
                            NavigationService()
                                .navigatorKey
                                .currentState
                                ?.pushNamedAndRemoveUntil(
                                  AppRoutes.main,
                                  (route) => false,
                                );
                          }
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      canLoginPhone ? Colors.black87 : Colors.grey.shade300,
                  foregroundColor:
                      canLoginPhone ? Colors.white : Colors.grey.shade600,
                  disabledBackgroundColor: Colors.grey.shade300,
                  disabledForegroundColor: Colors.grey.shade600,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                  ),
                  elevation: 0,
                ),
                child: _phoneLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white)),
                      )
                    : const Text(
                        'Log In', // Changed to "Log In" as per screenshot
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 16),
            // Register link
            Center(
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const RegisterScreen(),
                    ),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    children: [
                      const TextSpan(text: "Don't have an account? "),
                      TextSpan(
                        text: 'Register',
                        style: TextStyle(
                          color: Colors.blue.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showCountryCodePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Select Country Code',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _countryCodes.length,
                  itemBuilder: (context, index) {
                    final country = _countryCodes[index];
                    return ListTile(
                      leading: Text(
                        country['flag']!,
                        style: const TextStyle(fontSize: 24),
                      ),
                      title: Text(country['country']!),
                      trailing: Text(
                        country['code']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedCountryCode = country['code']!;
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _input({
    required String hint,
    required TextEditingController controller,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    Widget? suffix,
    bool obscure = false,
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        obscureText: obscure,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          suffixIcon: suffix,
        ),
      ),
    );
  }
}
