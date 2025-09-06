import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../screens/login_screen.dart';

/// Widget that listens to authentication state changes and handles UI updates
class AuthListener extends StatefulWidget {
  final Widget child;

  const AuthListener({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<AuthListener> createState() => _AuthListenerState();
}

class _AuthListenerState extends State<AuthListener> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    AuthService.instance.authStateChanges.listen((User? user) {
      if (mounted) {
        setState(() {
          _currentUser = user;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: AuthService.instance.authStateChanges,
      builder: (context, snapshot) {
        // Show loading indicator while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // If user is authenticated, show the main app
        if (snapshot.hasData && snapshot.data != null) {
          return widget.child;
        }

        // If user is not authenticated, show login screen
        return const LoginPage();
      },
    );
  }
}
