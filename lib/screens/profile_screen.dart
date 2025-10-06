import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/services/api_service.dart';

import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/widgets/profile_image_picker.dart';

import 'package:furniscapemobileapp/screens/auth/login_screen.dart';
import 'package:furniscapemobileapp/screens/favorites_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final userInfo = await ApiService().getUserInfo();
    if (mounted) {
      setState(() {
        name = userInfo['name'] ?? '';
        email = userInfo['email'] ?? '';
      });
    }
  }

  void _logout() async {
    await ApiService().logout();
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FurniScape',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {},
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesScreen()),
              );
            },
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          Widget profileInfoSection = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              const ProfileImagePicker(),
              const SizedBox(height: 20),
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              Text(email, style: const TextStyle(color: Colors.grey)),
            ],
          );

          Widget optionsList = Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(Icons.shopping_cart, "My Orders", () {}),
              _buildOption(Icons.favorite, "Wishlist", () {}),
              _buildOption(Icons.lock, "Change Password", () {}),
              _buildOption(Icons.settings, "Settings", () {}),
            ],
          );

          Widget logoutButton = ElevatedButton.icon(
            onPressed: () => _confirmLogoutDialog(context),
            icon: const Icon(Icons.logout),
            label: const Text("Logout"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(50),
            ),
          );

          if (isWide) {
            // Two-column layout for wide screens
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side: profile info
                  Expanded(
                    flex: 2,
                    child: SingleChildScrollView(
                      child: profileInfoSection,
                    ),
                  ),
                  const SizedBox(width: 32),
                  // Right side: options and logout button
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(child: optionsList),
                        ),
                        logoutButton,
                      ],
                    ),
                  )
                ],
              ),
            );
          } else {
            // Single column for narrow screens
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            profileInfoSection,
                            const SizedBox(height: 40),
                            optionsList,
                          ],
                        ),
                      ),
                    ),
                    logoutButton,
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _confirmLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
              child: const Text('Yes')),
        ],
      ),
    );
  }
}
