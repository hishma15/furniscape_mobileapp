import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          for (final tabItem in TabNavigationItem.items) tabItem.page,
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedIconTheme: const IconThemeData(color: Color(0xFF311B92), size: 40),
        selectedItemColor: const Color(0xFF311B92),
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        unselectedIconTheme: const IconThemeData(color: Colors.deepOrangeAccent),
        unselectedItemColor: const Color.fromARGB(255, 17, 16, 16),
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          for (final tabItem in TabNavigationItem.items)
            BottomNavigationBarItem(
              icon: tabItem.icon,
              label: tabItem.title,
            )
        ],
      ),
    );
  }
}

class TabNavigationItem{
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    required this.page,
    required this.title,
    required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: const HomeScreen(),
      title: 'Home',
      icon: const Icon(Icons.home),
    ),
    TabNavigationItem(
      page: const ExploreScreen(),
      title: 'Explore',
      icon: const Icon(Icons.search),
    ),
    TabNavigationItem(
      page: const CartScreen(),
      title: 'Cart',
      icon: const Icon(Icons.shopping_cart),
    ),
    TabNavigationItem(
      page: const ProfileScreen(),
      title: 'Profile',
      icon: const Icon(Icons.person),
    ),
  ];

}
