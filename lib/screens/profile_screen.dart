import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/services/api_service.dart';

import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/widgets/profile_image_picker.dart';

import 'package:furniscapemobileapp/screens/auth/login_screen.dart';

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
    setState(() {
      name = userInfo['name'] ?? '';
      email = userInfo['email'] ?? '';
    });
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
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const ProfileImagePicker(),
            const SizedBox(height: 20),
            Text(name, style: Theme
                .of(context)
                .textTheme
                .titleLarge),
            Text(email, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 40),

            // Option Buttons
            _buildOption(Icons.shopping_cart, "My Orders", () {}),
            _buildOption(Icons.favorite, "Wishlist", () {}),
            _buildOption(Icons.lock, "Change Password", () {}),
            _buildOption(Icons.settings, "Settings", () {}),

            const Spacer(),

            // Logout button
            ElevatedButton.icon(
              onPressed: () => _confirmLogoutDialog(context),
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(50),
              ),
            )
          ],
        ),
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
      builder: (context) =>
          AlertDialog(
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
