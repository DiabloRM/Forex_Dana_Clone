import 'package:flutter/material.dart';
import 'app_theme.dart';

class ThemeProvider extends ChangeNotifier {
  AppThemeMode _themeMode = AppThemeMode.system;
  AppThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    // For now, we'll use a simple approach without SharedPreferences
    // You can add shared_preferences package later if needed
    _themeMode = AppThemeMode.system;
    notifyListeners();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();

      // TODO: Add SharedPreferences implementation when package is added
      // try {
      //   final prefs = await SharedPreferences.getInstance();
      //   await prefs.setInt(_themeKey, mode.index);
      // } catch (e) {
      //   // Handle error silently
      // }
    }
  }

  ThemeData getTheme(Brightness systemBrightness) {
    return AppTheme.getTheme(_themeMode, systemBrightness);
  }

  bool get isDarkMode {
    if (_themeMode == AppThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == AppThemeMode.dark;
  }

  String getThemeModeName() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return 'Light';
      case AppThemeMode.dark:
        return 'Dark';
      case AppThemeMode.system:
        return 'System';
    }
  }

  IconData getThemeModeIcon() {
    switch (_themeMode) {
      case AppThemeMode.light:
        return Icons.light_mode;
      case AppThemeMode.dark:
        return Icons.dark_mode;
      case AppThemeMode.system:
        return Icons.brightness_auto;
    }
  }
}
