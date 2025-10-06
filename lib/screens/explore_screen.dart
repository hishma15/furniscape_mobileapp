import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/screens/product_details_screen.dart';

import 'package:furniscapemobileapp/widgets/product_card.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';

import 'package:furniscapemobileapp/screens/offline_products_screen.dart';

class ExploreScreen extends StatefulWidget {
  final String categoryId;

  const ExploreScreen({Key? key, this.categoryId = 'all'}) : super(key: key);

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  late ExploreProvider exploreProvider;

  @override
  void initState() {
    super.initState();
    // Delay provider call until after widget build context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
      exploreProvider.loadExploreData(categoryId: widget.categoryId);
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
          // Show offline message + button
          return Scaffold(
            appBar: widget.categoryId == 'all'
                ? AppBar(title: const Text('Explore'))
                : AppBar(
              title: Text(widget.categoryId[0].toUpperCase() + widget.categoryId.substring(1)),
              leading: BackButton(onPressed: () => Navigator.pop(context)),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
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
                      child: const Text('View Our Offline Products'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final filteredProducts = provider.filteredProducts;

        return Scaffold(
          appBar: widget.categoryId == 'all'
              ? AppBar(
            title: const Text('Explore'),
          )
              : AppBar(
            title: Text(
              widget.categoryId[0].toUpperCase() + widget.categoryId.substring(1),
            ),
            leading: BackButton(onPressed: () => Navigator.pop(context)),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Only show the heading for 'all' category screen
                if (widget.categoryId == 'all')
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Explore Products',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),

                // Expanded grid of products
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCard(
                        product: product,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        // onAddToCart: () {
                        //   Navigator.pushNamed(context, '/cart');
                        // },
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
              ],
            ),
          ),
        );
      },
    );
  }
}


// class ExploreScreen extends StatelessWidget {
//   const ExploreScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Explore'),),
//       body: const Center(child: Text('Explore Screen'),),
//     );
//   }
// }