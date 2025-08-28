import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forexdana/features/auth/screens/login_screen.dart';
import 'package:flutter_svg/flutter_svg.dart'; // Import for SvgPicture

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  String? _selectedCountryCode;
  bool _showReferral = false;

  final List<_CountryCode> _countryCodes = const [
    _CountryCode(label: '🇮🇳 India (+91)', code: '+91'),
    _CountryCode(label: '🇺🇸 United States (+1)', code: '+1'),
    _CountryCode(label: '🇬🇧 United Kingdom (+44)', code: '+44'),
    _CountryCode(label: '🇦🇪 UAE (+971)', code: '+971'),
    _CountryCode(label: '🇸🇬 Singapore (+65)', code: '+65'),
    _CountryCode(label: '🇦🇺 Australia (+61)', code: '+61'),
    _CountryCode(label: '🇵🇰 Pakistan (+92)', code: '+92'),
    _CountryCode(label: '🇧🇩 Bangladesh (+880)', code: '+880'),
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountryCode = _countryCodes.first.code;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color green = const Color(0xFF0FA958);
    final Color greyBorder = Colors.grey.shade300;

    final bool canProceed = (_selectedCountryCode?.isNotEmpty ?? false) &&
        _emailController.text.isNotEmpty;

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
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.headset_mic_outlined, color: Colors.black54),
            tooltip: 'Support',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Sign up to receive ',
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  Text(
                    ' 41000',
                    style: TextStyle(
                        fontSize: 16,
                        color: green,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '  bonus',
                    style: TextStyle(
                        fontSize: 16,
                        color: green,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Country code dropdown field
              _buildDropdownField(
                context: context,
                label: null,
                value: _selectedCountryCode,
                items: _countryCodes
                    .map((c) => DropdownMenuItem<String>(
                          value: c.code,
                          child: Text('${c.label}'),
                        ))
                    .toList(),
                onChanged: (val) => setState(() => _selectedCountryCode = val),
              ),

              const SizedBox(height: 16),

              // Email field
              _buildTextField(
                controller: _emailController,
                hint: 'Enter Email',
                inputType: TextInputType.emailAddress,
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 16),

              // Referral code collapsible
              InkWell(
                onTap: () => setState(() => _showReferral = !_showReferral),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Enter your referral code (Optional)',
                        style: TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                    ),
                    Icon(
                      _showReferral
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.grey.shade600,
                    ),
                  ],
                ),
              ),

              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _showReferral
                    ? Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: _buildTextField(
                          controller: _referralController,
                          hint: 'Referral code',
                          inputType: TextInputType.text,
                        ),
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 28),

              // Next button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: canProceed
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Proceeding to next step...')),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        canProceed ? Colors.black87 : Colors.grey.shade300,
                    disabledBackgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Have an account? ',
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(
                          color: green,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 36),

              Row(
                children: [
                  Expanded(child: Container(height: 1, color: greyBorder)),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('Register Via',
                        style: TextStyle(color: Colors.black45)),
                  ),
                  Expanded(child: Container(height: 1, color: greyBorder)),
                ],
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _socialButton(
                    context: context,
                    color: Colors.white,
                    borderColor: greyBorder,
                    child: SvgPicture.asset(
                      // Use 'child' here
                      'assets/Google_Symbol_0.svg',
                      height: 24,
                      width: 24,
                    ),
                    onTap: () {},
                  ),
                  const SizedBox(width: 24),
                  _socialButton(
                    context: context,
                    color: Colors.white,
                    borderColor: greyBorder,
                    child: const Icon(Icons.facebook, // Use 'child' here
                        color: Color(0xFF1877F2),
                        size: 28),
                    onTap: () {},
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required BuildContext context,
    required String? value,
    required List<DropdownMenuItem<String>> items,
    required ValueChanged<String?> onChanged,
    String? label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          ),
          hint: label != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child:
                      Text(label, style: const TextStyle(color: Colors.grey)),
                )
              : null,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required TextInputType inputType,
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
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _socialButton({
    required BuildContext context,
    required Color color,
    required Color borderColor,
    required Widget child, // Changed parameter name to 'child'
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor),
        ),
        alignment: Alignment.center,
        child: child, // Use 'child' here
      ),
    );
  }
}

class _CountryCode {
  final String label;
  final String code;
  const _CountryCode({required this.label, required this.code});
}
