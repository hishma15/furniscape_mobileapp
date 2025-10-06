import 'package:flutter/material.dart';
import 'package:furniscapemobileapp/models/product.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:furniscapemobileapp/providers/liked_products_provider.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;
  final VoidCallback? onBack;

  const ProductDetailsScreen({Key? key, required this.product, this.onBack})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int quantity = 1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _scaleAnimation =
        Tween<double>(begin: 0.8, end: 1.0).animate(_fadeAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleBack() async {
    await _animationController.reverse();
    widget.onBack?.call();
    Navigator.of(context).pop();
  }

  Future<void> _shareWithContact() async {
    var status = await Permission.contacts.status;
    if (!status.isGranted) {
      status = await Permission.contacts.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Contact permission Denied')),
        );
        return;
      }
    }

    Iterable<Contact> contacts =
    await ContactsService.getContacts(withThumbnails: false);

    final filteredContacts = contacts
        .where((c) => c.displayName != null && c.phones!.isNotEmpty)
        .toList();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        if (filteredContacts.isEmpty) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text('No contact found'),
          );
        }

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Contact',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Divider(height: 1),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = filteredContacts[index];
                      final phone = contact.phones!.first.value ?? '';
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            contact.initials(),
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Theme.of(context).primaryColor,
                        ),
                        title: Text(contact.displayName ?? ''),
                        subtitle: Text(phone),
                        onTap: () {
                          Navigator.pop(context);
                          _showShareConfirmation(
                              contact.displayName ?? '', phone);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showShareConfirmation(String contactName, String phone) {
    final productName = widget.product.name;
    final url = 'http://ec2-13-217-196-244.compute-1.amazonaws.com';
    final message =
        'Check out this $productName I found on FurnisCape! See more here: $url';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Share Product with $contactName'),
        content: SelectableText('Send this message to $phone:\n\n$message'),
        actions: [
          TextButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: message));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Message copied to clipboard!')),
              );
            },
            child: Text('Copy Message'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final likedProvider = Provider.of<LikedProductsProvider>(context);
    final isLiked = likedProvider.isLiked(product.id);

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Product Details',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,

            iconTheme: IconThemeData(color: Theme.of(context).colorScheme.primary),

            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _handleBack,
            ),
            actions: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () {
                  likedProvider.toggleLike(product.id);
                },
                color: isLiked ? Colors.red : Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareWithContact,
              ),
            ],
          ),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16.0).copyWith(bottom: 48),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/cart');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              child: const Text('Add to Cart'),

            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isLandscape
                ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _productImage(product)),
                const SizedBox(width: 16),
                Expanded(child: _productDetails(product)),
              ],
            )
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _productImage(product),
                const SizedBox(height: 16),
                _productDetails(product),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productImage(Product product) {
    final imageUrl = product.image != null
        ? 'http://ec2-13-217-196-244.compute-1.amazonaws.com/storage/${product.image}'
        : null;

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: imageUrl != null
          ? Image.network(
        imageUrl,
        height: 250,
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) =>
        const Icon(Icons.broken_image, size: 100),
      )
          : Image.asset(
        'assets/images/back.jpg',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _productDetails(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rs. ${product.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Row(
              children: [
                _quantityButton(Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
                const SizedBox(width: 8),
                Text(quantity.toString(),
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                _quantityButton(Icons.add, () {
                  setState(() => quantity++);
                }),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Description',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          product.description.isNotEmpty
              ? product.description
              : 'This is a high-quality ${product.name.toLowerCase()} perfect for modern home decor. Made from durable materials and built to last.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _quantityButton(IconData icon, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        onPressed: onPressed,
      ),
    );
  }
}
