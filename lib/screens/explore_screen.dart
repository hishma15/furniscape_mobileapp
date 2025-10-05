import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/providers/explore_provider.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/models/product.dart';

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
                          Navigator.pushNamed(context, '/product/${product.id}');
                        },
                        onAddToCart: () {
                          Navigator.pushNamed(context, '/cart');
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


class ProductCard extends StatelessWidget {
  final Product product;

  final VoidCallback? onViewDetails;
  final VoidCallback? onAddToCart;

  static const String backendUrl =
  'http://ec2-13-217-196-244.compute-1.amazonaws.com';
      // 'http://10.0.2.2:8000/api';

  const ProductCard({
    Key? key,
    required this.product,
    this.onViewDetails,
    this.onAddToCart,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final imageUrl =
    product.image != null ? '$backendUrl/storage/${product.image}' : null;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      child: SizedBox(
        width: 220, // same as Compose width
        child: Padding(
          padding: const EdgeInsets.all(16), // medium padding inside card
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageUrl != null
                    ? Image.network(
                  imageUrl,
                  height: 50, // same height as Compose
                  width: double.infinity,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                )
                    : Image.asset(
                  'assets/images/back.jpg',
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12), // space after image
              Text(
                product.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Text(
                'Rs. ${product.price.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onViewDetails,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), // reduced horizontal padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: const Text('More', overflow: TextOverflow.ellipsis),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: onAddToCart,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Icon(
                        Icons.shopping_cart,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
