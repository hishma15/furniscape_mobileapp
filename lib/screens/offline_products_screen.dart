import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:furniscapemobileapp/widgets/product_card.dart';
import 'package:furniscapemobileapp/screens/product_details_screen.dart';
import 'package:provider/provider.dart';

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
            appBar: AppBar(title: const Text('Offline Products')),
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
          appBar: AppBar(title: const Text('Offline Products')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: provider.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = provider.filteredProducts[index];
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
                  onAddToCart: () {
                    // Implement add to cart if needed
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
