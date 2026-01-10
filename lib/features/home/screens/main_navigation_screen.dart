import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../screens/home_screen.dart'; // Adjust if path different
import '../../looking/screens/looking_for_screen.dart'; // Players & Teams search
import '../../messages/screens/chat_list_screen.dart'; // Messages
import '../../profile/screens/profile_screen.dart'; // Profile

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _screens = <Widget>[
    const HomeScreen(),
    const LookingForScreen(),
    const ChatListScreen(),
    const ProfileScreen(),
  ];

  static const List<BottomNavigationBarItem> _navItems = [
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search_outlined),
      activeIcon: Icon(Icons.search),
      label: 'Discover',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.message_outlined),
      activeIcon: Icon(Icons.message),
      label: 'Messages',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outlined),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _navItems,
        currentIndex: _selectedIndex,
        selectedItemColor: AppTheme.neonGreen,
        unselectedItemColor: AppTheme.textGray,
        backgroundColor: AppTheme.darkBlue,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
      ),
    );
  }
}