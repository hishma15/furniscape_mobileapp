import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';
import 'package:furniscapemobileapp/providers/liked_products_provider.dart';
import 'package:furniscapemobileapp/providers/notification_provider.dart';
import 'package:provider/provider.dart';
// import 'app.dart';
import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'package:furniscapemobileapp/providers/home_provider.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:furniscapemobileapp/screens/auth/login_screen.dart';
import 'package:furniscapemobileapp/screens/get_started_screen.dart';
import 'package:google_fonts/google_fonts.dart';

// import 'package:furniscapemobileapp/screens/home_screen.dart';

import 'theme/theme.dart';

// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:video_player/video_player.dart';

// import 'providers/auth_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => HomeProvider()),
        ChangeNotifierProvider(create: (_) => ExploreProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => LikedProductsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'FurniScape',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.system,
        home: const GetStartedScreen(), // or LoginScreen, etc.
        // home: const HomeScreen(),
      ),
    );
  }
}

// void main() {
//   runApp(
//     MultiProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => AuthProvider()),
//         ChangeNotifierProvider(create: (_) => HomeProvider()),
//       ],
//       child: const FurniScapeApp(),
//     ),
//   );
// }
