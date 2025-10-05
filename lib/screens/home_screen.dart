import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/auth_provider.dart';
import 'auth/login_screen.dart';
import 'package:furniscapemobileapp/providers/home_provider.dart';
import 'package:furniscapemobileapp/models/category.dart';
import 'package:furniscapemobileapp/models/product.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String searchText = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().loadHomeData();
    });
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
            onPressed: () {
              // TODO: Handle notification click
            },
            color: Theme.of(context).colorScheme.onPrimary,
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              // TODO: Handle favorite/like click
            },
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ],
      ),
      body: homeProvider.isLoading
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
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    'assets/images/homeimg.png',
                    width: double.infinity,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 24,),

              // Categories
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text('Categories', style: Theme.of(context).textTheme.headlineLarge,)
              ),
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
                    return ProductCard(product: product);
                  },
                ),
              ),

              const SizedBox(height: 32,),
            ],
          ),
        )

    )
    );
  }
}

// Category Card UI
// class CategoryCard extends StatelessWidget {
//   final Category category;
//
//   const CategoryCard({super.key, required this.category});
//
//   static const String backendUrl = 'http://ec2-13-217-196-244.compute-1.amazonaws.com';
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 100,
//       margin: const EdgeInsets.all(8),
//       child: Column(
//         children: [
//           Container(
//             width: 60,
//             height: 60,
//             child: category.image != null
//                 ? Builder(
//               builder: (_) {
//                 final imageUrl = '$backendUrl/storage/${category.image!}';
//                 print('Loading image from: $imageUrl'); // ← This is the line
//                 return Image.network(
//                   imageUrl,
//                   errorBuilder: (context, error, stackTrace) {
//                     return const Icon(Icons.error);
//                   },
//                   fit: BoxFit.cover,
//                 );
//               },
//             )
//                 : Image.asset('assets/images/back.jpg'),
//           ),
//
//           const SizedBox(height: 8),
//           Text(
//             category.name,
//             textAlign: TextAlign.center,
//             style: const TextStyle(fontSize: 14),
//           )
//         ],
//       ),
//     );
//   }
// }

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
        Navigator.pushNamed(context, '/category/${category.id}');
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
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


// Featured Product UI
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





