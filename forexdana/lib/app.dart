import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'features/dashboard/screens/market_screen.dart';
import 'features/dashboard/screens/positions_screen.dart';
import 'features/dashboard/screens/profile_screen.dart';
import 'features/dashboard/screens/square_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/services/auth_service.dart';
import 'core/theme/app_theme.dart';
import 'core/state/app_state.dart';
import 'core/navigation/navigation_service.dart';
import 'core/constants/app_icons.dart';

class App extends StatefulWidget {
  final Function(AppThemeMode)? onThemeChanged;

  const App({Key? key, this.onThemeChanged}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late AppState _appState;
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _appState = AppState();
    _initializeAuth();
  }

  void _initializeAuth() {
    // Listen to auth state changes
    AuthService.instance.authStateChanges.listen((User? user) {
      if (mounted) {
        final wasAuthenticated = _currentUser != null;
        final isNowAuthenticated = user != null;

        // Update current user state safely
        setState(() {
          _currentUser = user;
        });

        // Update app state with user information
        try {
          _appState.setAuthenticationStatus(
            user != null,
            token: user?.uid,
            profile: user != null
                ? {
                    'uid': user.uid,
                    'email': user.email,
                    'displayName': user.displayName,
                    'phoneNumber': user.phoneNumber,
                  }
                : null,
          );
        } catch (e) {
          debugPrint('Error updating authentication status: $e');
          // Continue with the flow even if there's an error in updating app state
        }

        // Handle authentication state changes
        if (!wasAuthenticated && isNowAuthenticated) {
          // User just logged in - navigate to profile screen
          // Use a longer delay to ensure the app state is fully updated
          Future.delayed(const Duration(milliseconds: 500), () {
            if (mounted) {
              try {
                _appState.setBottomNavIndex(3); // Profile tab
              } catch (e) {
                debugPrint('Error navigating to profile tab: $e');
              }
            }
          });
        } else if (wasAuthenticated && !isNowAuthenticated) {
          // User just logged out - navigate to login screen
          Future.delayed(const Duration(milliseconds: 300), () {
            if (mounted) {
              try {
                // Use the global navigator key to navigate
                NavigationService().navigatorKey.currentState?.pushReplacement(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
              } catch (e) {
                debugPrint('Error navigating to login page: $e');
              }
            }
          });
        }
      }
    });
  }

  void _onItemTapped(int index) {
    try {
      // Check if user is trying to access profile section
      if (index == 3) {
        // Check authentication state
        if (!_appState.isAuthenticated || _currentUser == null) {
          // Navigate to login screen instead of profile
          try {
            // Check if we can pop before navigating
            if (NavigationService().canGoBack()) {
              NavigationService().navigateToPage(const LoginPage(), replace: true);
            } else {
              NavigationService().navigateToPage(const LoginPage());
            }
          } catch (e) {
            debugPrint('Error navigating to login page: $e');
            // Fallback: If navigation fails, stay on current tab
            return;
          }
          return; // Don't change the selected index
        } else {
          // User is authenticated, navigate to profile
          _appState.setBottomNavIndex(index);
          return;
        }
      }

      // For other tabs, simply update the index
      _appState.setBottomNavIndex(index);
      
      // Reset square tab index when switching to square tab
      if (index == 2) {
        _appState.setSquareTabIndex(0);
      }
    } catch (e) {
      debugPrint('Error in _onItemTapped: $e');
      // If there's an error, try to recover by staying on the current tab
    }
  }

  void _onGoToSquare(int tabIndex) {
    _appState.navigateToSquare(tabIndex);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _appState,
      builder: (context, _) {
        return MaterialApp(
          navigatorKey: NavigationService().navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'ForexDana Clone',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _appState.themeMode,
          home: AppStateProvider(
            appState: _appState,
            child: Scaffold(
          body: AnimatedBuilder(
            animation: _appState,
            builder: (context, child) {
              return _appState.currentBottomNavIndex == 2
                  ? SquareScreen(initialIndex: _appState.currentSquareTabIndex)
                  : _buildScreen(_appState.currentBottomNavIndex);
            },
          ),
          bottomNavigationBar: AnimatedBuilder(
            animation: _appState,
            builder: (context, child) {
              return BottomNavigationBar(
                currentIndex: _appState.currentBottomNavIndex,
                selectedItemColor: Colors.black,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.white,
                type: BottomNavigationBarType.fixed,
                onTap: _onItemTapped,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.markets),
                    label: 'Markets',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.positions),
                    label: 'Positions',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.square),
                    label: 'Square',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(AppIcons.profile),
                    label: 'Profile',
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
      },
    );
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return MarketScreen(
          onGoToSquare: _onGoToSquare,
          onThemeChanged: widget.onThemeChanged,
        );
      case 1:
        return PositionsScreen();
      case 3:
        return ProfileScreen();
      default:
        return Container(); // Should not reach here
    }
  }
}
