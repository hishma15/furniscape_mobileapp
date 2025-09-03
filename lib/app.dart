import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth_provider.dart';
import 'screens/get_started_screen.dart';

class FurniScapeApp extends StatelessWidget {
  const FurniScapeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MaterialApp(
        title: 'FurniScape',
        home: const GetStartedScreen(),
      ),
    );
  }
}
