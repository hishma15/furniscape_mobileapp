import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabChanged(int index) {
    setState(() => _currentIndex = index);

    if (index == 1) { // Explore tab index
      // Trigger reload data
      final exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
      exploreProvider.loadExploreData(categoryId: 'all');
    }
  }


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
        onTap: _onTabChanged,
        // onTap: (int index) => setState(() => _currentIndex = index),
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
      page: const ExploreScreen(key: ValueKey('ExploreScreen'), category: null),
      title: 'Explore',
      icon: const Icon(Icons.search),
    ),
    TabNavigationItem(
      page: CartScreen(),
      title: 'Cart',
      icon: const Icon(Icons.shopping_cart),
    ),
    TabNavigationItem(
      page: ProfileScreen(),
      title: 'Profile',
      icon: const Icon(Icons.person),
    ),
  ];

}
