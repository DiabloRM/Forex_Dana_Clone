import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../navigation/navigation_service.dart';

/// Global app state management
class AppState extends ChangeNotifier {
  static final AppState _instance = AppState._internal();
  factory AppState() => _instance;
  AppState._internal();

  // Navigation state
  int _currentBottomNavIndex = 0;
  int _currentSquareTabIndex = 0;

  // Authentication state
  bool _isAuthenticated = false;
  bool _isVerified = false;
  String? _userToken;
  Map<String, dynamic>? _userProfile;

  // Theme state
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDarkMode = false;

  // Market state
  String _selectedMarketCategory = 'Recommend';
  Set<String> _favoriteInstruments = {};

  // Trading state
  String? _selectedTradingSymbol;
  String _selectedTimeframe = '5M';

  // UI state
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  int get currentBottomNavIndex => _currentBottomNavIndex;
  int get currentSquareTabIndex => _currentSquareTabIndex;
  bool get isAuthenticated => _isAuthenticated;
  bool get isVerified => _isVerified;
  String? get userToken => _userToken;
  Map<String, dynamic>? get userProfile => _userProfile;
  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _isDarkMode;
  String get selectedMarketCategory => _selectedMarketCategory;
  Set<String> get favoriteInstruments => Set.from(_favoriteInstruments);
  String? get selectedTradingSymbol => _selectedTradingSymbol;
  String get selectedTimeframe => _selectedTimeframe;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Navigation methods
  void setBottomNavIndex(int index) {
    if (_currentBottomNavIndex != index) {
      _currentBottomNavIndex = index;
      notifyListeners();
    }
  }

  void setSquareTabIndex(int index) {
    if (_currentSquareTabIndex != index) {
      _currentSquareTabIndex = index;
      notifyListeners();
    }
  }

  void navigateToSquare(int tabIndex) {
    setBottomNavIndex(2); // Square tab index
    setSquareTabIndex(tabIndex);
  }

  // Authentication methods
  void setAuthenticationStatus(bool authenticated,
      {String? token, Map<String, dynamic>? profile}) {
    try {
      _isAuthenticated = authenticated;
      _userToken = token;
      _userProfile = profile;
      NavigationGuard.setAuthenticationStatus(authenticated);
      
      // Ensure we're on the UI thread when notifying listeners
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          notifyListeners();
        } catch (e) {
          debugPrint('Error in notifyListeners during auth status update: $e');
        }
      });
    } catch (e) {
      debugPrint('Error in setAuthenticationStatus: $e');
    }
  }

  void setVerificationStatus(bool verified) {
    _isVerified = verified;
    NavigationGuard.setVerificationStatus(verified);
    notifyListeners();
  }

  void logout() {
    _isAuthenticated = false;
    _isVerified = false;
    _userToken = null;
    _userProfile = null;
    NavigationGuard.setAuthenticationStatus(false);
    NavigationGuard.setVerificationStatus(false);
    notifyListeners();
  }

  // Theme methods
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _isDarkMode = mode == ThemeMode.dark;
      notifyListeners();
    }
  }

  void toggleTheme() {
    setThemeMode(_isDarkMode ? ThemeMode.light : ThemeMode.dark);
  }

  // Market methods
  void setSelectedMarketCategory(String category) {
    if (_selectedMarketCategory != category) {
      _selectedMarketCategory = category;
      notifyListeners();
    }
  }

  void toggleFavoriteInstrument(String instrument) {
    if (_favoriteInstruments.contains(instrument)) {
      _favoriteInstruments.remove(instrument);
    } else {
      _favoriteInstruments.add(instrument);
    }
    notifyListeners();
  }

  bool isFavoriteInstrument(String instrument) {
    return _favoriteInstruments.contains(instrument);
  }

  // Trading methods
  void setSelectedTradingSymbol(String? symbol) {
    if (_selectedTradingSymbol != symbol) {
      _selectedTradingSymbol = symbol;
      notifyListeners();
    }
  }

  void setSelectedTimeframe(String timeframe) {
    if (_selectedTimeframe != timeframe) {
      _selectedTimeframe = timeframe;
      notifyListeners();
    }
  }

  // UI state methods
  void setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void setError(String? error) {
    if (_errorMessage != error) {
      _errorMessage = error;
      notifyListeners();
    }
  }

  void clearError() {
    setError(null);
  }

  // Utility methods
  void reset() {
    _currentBottomNavIndex = 0;
    _currentSquareTabIndex = 0;
    _isAuthenticated = false;
    _isVerified = false;
    _userToken = null;
    _userProfile = null;
    _themeMode = ThemeMode.system;
    _isDarkMode = false;
    _selectedMarketCategory = 'Recommend';
    _favoriteInstruments.clear();
    _selectedTradingSymbol = null;
    _selectedTimeframe = '5M';
    _isLoading = false;
    _errorMessage = null;
    NavigationGuard.setAuthenticationStatus(false);
    NavigationGuard.setVerificationStatus(false);
    notifyListeners();
  }

  // State persistence methods (for future implementation)
  Map<String, dynamic> toJson() {
    return {
      'currentBottomNavIndex': _currentBottomNavIndex,
      'currentSquareTabIndex': _currentSquareTabIndex,
      'isAuthenticated': _isAuthenticated,
      'isVerified': _isVerified,
      'themeMode': _themeMode.index,
      'selectedMarketCategory': _selectedMarketCategory,
      'favoriteInstruments': _favoriteInstruments.toList(),
      'selectedTradingSymbol': _selectedTradingSymbol,
      'selectedTimeframe': _selectedTimeframe,
    };
  }

  void fromJson(Map<String, dynamic> json) {
    _currentBottomNavIndex = json['currentBottomNavIndex'] ?? 0;
    _currentSquareTabIndex = json['currentSquareTabIndex'] ?? 0;
    _isAuthenticated = json['isAuthenticated'] ?? false;
    _isVerified = json['isVerified'] ?? false;
    _themeMode = ThemeMode.values[json['themeMode'] ?? 0];
    _isDarkMode = _themeMode == ThemeMode.dark;
    _selectedMarketCategory = json['selectedMarketCategory'] ?? 'Recommend';
    _favoriteInstruments = Set<String>.from(json['favoriteInstruments'] ?? []);
    _selectedTradingSymbol = json['selectedTradingSymbol'];
    _selectedTimeframe = json['selectedTimeframe'] ?? '5M';

    NavigationGuard.setAuthenticationStatus(_isAuthenticated);
    NavigationGuard.setVerificationStatus(_isVerified);
    notifyListeners();
  }
}

/// App state provider for dependency injection
class AppStateProvider extends StatelessWidget {
  final AppState appState;
  final Widget child;

  const AppStateProvider({
    Key? key,
    required this.appState,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>.value(
      value: appState,
      child: child,
    );
  }

  static AppState of(BuildContext context) {
    return Provider.of<AppState>(context, listen: false);
  }

  static AppState? maybeOf(BuildContext context) {
    try {
      return Provider.of<AppState>(context, listen: false);
    } catch (e) {
      return null;
    }
  }
}
