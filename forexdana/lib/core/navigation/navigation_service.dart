import 'package:flutter/material.dart';

/// Centralized navigation service for consistent navigation flow
class NavigationService {
  static final NavigationService _instance = NavigationService._internal();
  factory NavigationService() => _instance;
  NavigationService._internal();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Get current context
  BuildContext? get currentContext => navigatorKey.currentContext;

  /// Navigate to a named route
  Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushNamed(routeName, arguments: arguments);
  }

  /// Navigate to a named route and replace current route
  Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!
        .pushReplacementNamed(routeName, arguments: arguments);
  }

  /// Navigate to a named route and clear all previous routes
  Future<dynamic> navigateToAndClear(String routeName, {Object? arguments}) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  /// Navigate to a page using MaterialPageRoute
  Future<dynamic> navigateToPage(Widget page, {bool replace = false}) {
    if (replace) {
      return navigatorKey.currentState!.pushReplacement(
        MaterialPageRoute(builder: (context) => page),
      );
    }
    return navigatorKey.currentState!.push(
      MaterialPageRoute(builder: (context) => page),
    );
  }

  /// Go back to previous page
  void goBack({dynamic result}) {
    navigatorKey.currentState!.pop(result);
  }

  /// Check if can go back
  bool canGoBack() {
    return navigatorKey.currentState!.canPop();
  }

  /// Pop until a specific route
  void popUntil(String routeName) {
    navigatorKey.currentState!.popUntil(ModalRoute.withName(routeName));
  }

  /// Show a dialog
  Future<dynamic> showDialog({
    required Widget child,
    bool barrierDismissible = true,
    Color? barrierColor,
  }) {
    return showGeneralDialog(
      context: currentContext!,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor ?? Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.8, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOut),
            ),
            child: child,
          ),
        );
      },
    );
  }

  /// Show a bottom sheet
  Future<dynamic> showBottomSheet({
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = false,
  }) {
    return showModalBottomSheet(
      context: currentContext!,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (context) => child,
    );
  }

  /// Show a snackbar
  void showSnackBar({
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    ScaffoldMessenger.of(currentContext!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: duration,
        action: action,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}

/// Navigation routes constants
class AppRoutes {
  static const String splash = '/';
  static const String main = '/main';
  static const String login = '/login';
  static const String register = '/register';
  static const String markets = '/markets';
  static const String trading = '/trading';
  static const String positions = '/positions';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String deposit = '/deposit';
  static const String withdraw = '/withdraw';
  static const String chat = '/chat';
  static const String support = '/support';
  static const String demo = '/demo';
  static const String task = '/task';
  static const String referral = '/referral';
  static const String mining = '/mining';
  static const String verification = '/verification';
  static const String calculator = '/calculator';
}

/// Navigation arguments for passing data between screens
class NavigationArguments {
  final Map<String, dynamic> _arguments;

  NavigationArguments(this._arguments);

  T? get<T>(String key) => _arguments[key] as T?;
  T getRequired<T>(String key) => _arguments[key] as T;

  static NavigationArguments fromMap(Map<String, dynamic> map) {
    return NavigationArguments(map);
  }

  Map<String, dynamic> toMap() => Map.from(_arguments);
}

/// Navigation observer for tracking navigation events
class AppNavigationObserver extends NavigatorObserver {
  final List<Route<dynamic>> _routeStack = [];

  List<Route<dynamic>> get routeStack => List.unmodifiable(_routeStack);

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _routeStack.add(route);
    _logNavigation('PUSH', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _routeStack.remove(route);
    _logNavigation('POP', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (oldRoute != null) _routeStack.remove(oldRoute);
    if (newRoute != null) _routeStack.add(newRoute);
    _logNavigation('REPLACE', newRoute, oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    _routeStack.remove(route);
    _logNavigation('REMOVE', route, previousRoute);
  }

  void _logNavigation(
      String action, Route<dynamic>? route, Route<dynamic>? previousRoute) {
    if (route != null) {
      debugPrint('Navigation $action: ${route.settings.name}');
    }
  }
}

/// Navigation guard for authentication and permission checks
class NavigationGuard {
  static bool _isAuthenticated = false;
  static bool _isVerified = false;

  static bool get isAuthenticated => _isAuthenticated;
  static bool get isVerified => _isVerified;

  static void setAuthenticationStatus(bool authenticated) {
    _isAuthenticated = authenticated;
  }

  static void setVerificationStatus(bool verified) {
    _isVerified = verified;
  }

  /// Check if user can access a route
  static bool canAccessRoute(String routeName) {
    // Public routes that don't require authentication
    const publicRoutes = {
      AppRoutes.splash,
      AppRoutes.login,
      AppRoutes.register,
      AppRoutes.support,
    };

    if (publicRoutes.contains(routeName)) {
      return true;
    }

    // Routes that require authentication
    const protectedRoutes = {
      AppRoutes.main,
      AppRoutes.markets,
      AppRoutes.trading,
      AppRoutes.positions,
      AppRoutes.profile,
      AppRoutes.settings,
      AppRoutes.deposit,
      AppRoutes.withdraw,
      AppRoutes.chat,
      AppRoutes.demo,
      AppRoutes.task,
      AppRoutes.referral,
      AppRoutes.mining,
      AppRoutes.calculator,
    };

    if (protectedRoutes.contains(routeName)) {
      return _isAuthenticated;
    }

    // Routes that require verification
    const verifiedRoutes = {
      AppRoutes.deposit,
      AppRoutes.withdraw,
      AppRoutes.trading,
    };

    if (verifiedRoutes.contains(routeName)) {
      return _isAuthenticated && _isVerified;
    }

    return true;
  }

  /// Get redirect route if user cannot access the requested route
  static String? getRedirectRoute(String routeName) {
    if (!canAccessRoute(routeName)) {
      if (!_isAuthenticated) {
        return AppRoutes.login;
      } else if (!_isVerified) {
        return AppRoutes.verification;
      }
    }
    return null;
  }
}
