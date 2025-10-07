import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/screens/explore_screen.dart';
import 'package:furniscapemobileapp/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'package:furniscapemobileapp/providers/home_provider.dart';
import 'package:furniscapemobileapp/models/category.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'dart:async';

import 'package:furniscapemobileapp/widgets/product_card.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';
import 'package:furniscapemobileapp/screens/favorites_screen.dart';
import 'package:furniscapemobileapp/screens/notification_screen.dart';
import 'package:furniscapemobileapp/providers/notification_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";

  // To keep track of connectivity status
  bool _isOffline = false;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  @override
  void initState() {
    super.initState();

    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });

  //   Initializing connectivity
    _initConnectivity();
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    List<ConnectivityResult> results = await Connectivity().checkConnectivity();
    return _updateConnectionStatus(results);
  }

  void _updateConnectionStatus(List<ConnectivityResult> resultList) async {
    final hasNetwork = resultList.any((result) => result != ConnectivityResult.none);
    final hasInternet = await InternetConnectionChecker.instance.hasConnection;

    setState(() {
      _isOffline = !(hasNetwork && hasInternet);
    });
  }



  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  void _openNotificationsScreen(BuildContext context) async {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    await notificationProvider.fetchNotifications();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const NotificationsScreen()),
    );
  }


  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return Scaffold(
      appBar:
      AppBar(
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
            onPressed: () => _openNotificationsScreen(context),
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
      body: Column(
        children: [
          if (_isOffline)
            Container(
              color: Colors.red,
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.signal_wifi_off, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'No internet connection',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          Expanded(
            child: homeProvider.isLoading
                ? const Center(child: CircularProgressIndicator(),)
                : RefreshIndicator(
                onRefresh: () async {
                  await context.read<HomeProvider>().loadHomeData();
                },
                child:  SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16,),
                      // Search Bar
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchText = value;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search Sofas, Beds, Decor Items, ....',
                            prefixIcon: Icon(Icons.search,
                              color: Theme.of(context).colorScheme.primary,),
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondaryContainer,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16,),
                      // Banner
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(
                            'assets/images/homeimg.png',
                            width: double.infinity,
                            // height: 160,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),

                      const SizedBox(height: 24,),

                      // Categories
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text('SHOP BY ROOM', style: Theme.of(context).textTheme.headlineLarge,)
                      ),
                      const SizedBox(height: 12,),
                      SizedBox(
                        height: 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeProvider.categories.length,
                          itemBuilder: (context, index) {
                            final category = homeProvider.categories[index];
                            return CategoryCard(category: category);
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Featured products
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Featured Products', style: Theme.of(context).textTheme.headlineLarge,),
                      ),
                      SizedBox(
                        height: 300, // Adjust as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: homeProvider.featuredProducts.length,
                          itemBuilder: (context, index) {
                            final product = homeProvider.featuredProducts[index];
                            return ProductCard(
                              product: product,
                              onViewDetails: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>ProductDetailsScreen(product: product),
                                  ),
                                );
                              },
                              onAddToCart: () {
                                final cartProvider = Provider.of<CartProvider>(context, listen: false);
                                cartProvider.addItem(
                                  product.id.toString(),  // Assuming product.id is int or String
                                  product.name,
                                  product.price,
                                  product.image != null
                                      ? 'http://ec2-13-217-196-244.compute-1.amazonaws.com/storage/${product.image}'
                                      : '',  // Handle null image
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${product.name} added to cart'),
                                    duration: Duration(seconds: 2),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 32,),
                    ],
                  ),
                )

            ),
          ),
        ]
      )
    );
  }
}

class CategoryCard extends StatelessWidget {
  final Category category;
  static const String backendUrl =
      'http://ec2-13-217-196-244.compute-1.amazonaws.com';
      // 'http://10.0.2.2:8000/api';

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final imageUrl =
    category.image != null ? '$backendUrl/storage/${category.image}' : null;

    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/category/${category.id}');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExploreScreen(category: category),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              clipBehavior: Clip.hardEdge,
              child: imageUrl != null
                  ? Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
              )
                  : Image.asset('assets/images/back.jpg'),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14),
            )
          ],
        ),
      ),
    );
  }
}








