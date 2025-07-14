import 'package:flutter/material.dart';
import 'features/dashboard/screens/market_screen.dart';
import 'features/dashboard/screens/positions_screen.dart';
import 'features/dashboard/screens/profile_screen.dart';
import 'features/dashboard/screens/square_screen.dart';

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    MarketScreen(),
    PositionsScreen(),
    SquareScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ForexDana Clone',
      home: Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              label: 'Markets',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.sync), label: 'Positions'),
            BottomNavigationBarItem(
              icon: Icon(Icons.crop_square),
              label: 'Square',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
