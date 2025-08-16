import 'package:flutter/material.dart';
import 'app.dart';
import 'features/auth/screens/splash_screen.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppThemeMode _currentThemeMode = AppThemeMode.system;

  void _changeTheme(AppThemeMode mode) {
    setState(() {
      _currentThemeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forex Dana',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getTheme(_currentThemeMode,
          WidgetsBinding.instance.platformDispatcher.platformBrightness),
      darkTheme: AppTheme.darkTheme, // Add explicit dark theme
      themeMode: AppTheme.getFlutterThemeMode(_currentThemeMode),
      initialRoute: '/',
      routes: {
        '/': (context) => ForexDanaSplashScreen(onThemeChanged: _changeTheme),
        '/main': (context) => App(onThemeChanged: _changeTheme),
      },
    );
  }
}
