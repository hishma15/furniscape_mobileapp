import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:furniscapemobileapp/models/category.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';

import 'package:furniscapemobileapp/screens/product_details_screen.dart';
import 'package:furniscapemobileapp/screens/favorites_screen.dart';
import 'package:furniscapemobileapp/screens/offline_products_screen.dart';

import 'package:furniscapemobileapp/widgets/product_card.dart';

class ExploreScreen extends StatefulWidget {
  final Category? category;

  const ExploreScreen({Key? key, this.category}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ExploreProvider exploreProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
      final categoryId = widget.category?.id.toString() ?? 'all';
      exploreProvider.loadExploreData(categoryId: categoryId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.isOffline) {
          return _buildOfflineUI(context);
        }

        final filteredProducts = provider.filteredProducts;
        final isAllCategory = widget.category == null;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isAllCategory ? 'FurniScape' : widget.category!.name,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            leading: isAllCategory ? null : BackButton( color: Theme.of(context).colorScheme.onPrimary, ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            actions: isAllCategory
                ? [
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
            ]
                : null,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isAllCategory)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Explore Products',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                Expanded(
                  child: GridView.builder(
                    itemCount: filteredProducts.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7, // This controls height:width ratio of card
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        onAddToCart: () {
                          final cartProvider =
                          Provider.of<CartProvider>(context, listen: false);
                          cartProvider.addItem(
                            product.id.toString(),
                            product.name,
                            product.price,
                            product.image != null
                                ? 'http://ec2-13-217-196-244.compute-1.amazonaws.com/storage/${product.image}'
                                : '',
                          );

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOfflineUI(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('You are Offline',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,

      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.signal_wifi_off, size: 60, color: Colors.red),
                const SizedBox(height: 16),
                const Text(
                  'You are offline',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Unable to fetch data from the server.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => OfflineProductsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                  child: const Text('View Offline Products',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
