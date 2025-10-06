import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:furniscapemobileapp/providers/liked_products_provider.dart';
import 'package:furniscapemobileapp/widgets/product_card.dart';
import 'package:furniscapemobileapp/screens/product_details_screen.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final likedProvider = Provider.of<LikedProductsProvider>(context);
    final exploreProvider = Provider.of<ExploreProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Get all products and filter those that are liked
    final allProducts = exploreProvider.allProducts;
    final likedProductIds = likedProvider.likedProductIds;

    final likedProducts = allProducts
        .where((product) => likedProductIds.contains(product.id))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: likedProducts.isEmpty
          ? const Center(
        child: Text(
          'No favorite products yet.',
          style: TextStyle(fontSize: 18),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Your Favorite Products',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: likedProducts.length,
                itemBuilder: (context, index) {
                  final product = likedProducts[index];

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
  }
}
