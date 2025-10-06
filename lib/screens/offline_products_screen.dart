import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:furniscapemobileapp/widgets/product_card.dart';
import 'package:furniscapemobileapp/screens/product_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';

class OfflineProductsScreen extends StatefulWidget {
  const OfflineProductsScreen({Key? key}) : super(key: key);

  @override
  _OfflineProductsScreenState createState() => _OfflineProductsScreenState();
}

class _OfflineProductsScreenState extends State<OfflineProductsScreen> {
  late ExploreProvider exploreProvider;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      exploreProvider = Provider.of<ExploreProvider>(context, listen: false);
      exploreProvider.loadOfflineProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExploreProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return Scaffold(
            appBar: AppBar(
                title: Text('Offline Products',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (provider.filteredProducts.isEmpty) {
          return Scaffold(
            appBar: AppBar(title: const Text('Offline Products')),
            body: const Center(child: Text('No offline products available.')),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Offline Products',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              itemCount: provider.filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.58, // Lower value gives more vertical space
              ),
              itemBuilder: (context, index) {
                final product = provider.filteredProducts[index];
                return LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      width: constraints.maxWidth,
                      child: ProductCard(
                        product: product,
                        onViewDetails: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailsScreen(product: product),
                            ),
                          );
                        },
                        onAddToCart: () {
                          final cartProvider = Provider.of<CartProvider>(context, listen: false);
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
                      ),
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }
}
