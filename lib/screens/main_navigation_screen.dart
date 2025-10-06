import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

import 'package:google_fonts/google_fonts.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;

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
        backgroundColor: colorScheme.secondaryContainer,
        selectedItemColor: colorScheme.onSurface,
        unselectedItemColor: colorScheme.onSecondaryContainer,
        selectedIconTheme: IconThemeData(color: colorScheme.onSurface, size: 30),
        unselectedIconTheme: IconThemeData(color: colorScheme.onSecondaryContainer, size: 24),
        selectedLabelStyle: GoogleFonts.lustria(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.lustria(
          color: colorScheme.onSecondaryContainer,
          fontWeight: FontWeight.normal,
        ),
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
      page: ExploreScreen(key: UniqueKey(), categoryId: 'all'),
      title: 'Explore',
      icon: const Icon(Icons.search),
    ),
    TabNavigationItem(
      page: CartScreen(),
      title: 'Cart',
      icon: const Icon(Icons.shopping_cart),
    ),
    TabNavigationItem(
      page: ProfileScreen(
        // onLogOutClick: () {
        //   // TODO: logout logic
        //   print("Logout clicked");
        // },
      ),
      title: 'Profile',
      icon: const Icon(Icons.person),
    ),
  ];

}
