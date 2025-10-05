import 'package:flutter/material.dart';

import 'package:furniscapemobileapp/main.dart';
import 'package:furniscapemobileapp/models/product.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:contacts_service_plus/contacts_service_plus.dart';

import 'package:flutter/services.dart';


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
  bool isLiked = false;

  @override
  void initState() {
    super.initState();

    // Animation controller for fade and scale animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(_fadeAnimation);

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _handleBack() async {
    await _animationController.reverse();
    if (widget.onBack != null) widget.onBack!();
    Navigator.of(context).pop();
  }

  Future<void> _shareWithContact() async {
  //   Request permission
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

  //   Fetch contacts
    Iterable<Contact> contacts = await ContactsService.getContacts(withThumbnails: false);

  //   Show contacts in bottom sheet
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (context) {
        if (contacts.isEmpty) {
          return Container(
            height: 150,
            alignment: Alignment.center,
            child: Text('No contact found'),
          );
        }

        // Filter contacts with name and phone
        final filteredContacts = contacts
            .where((c) => c.displayName != null && c.phones!.isNotEmpty)
            .toList();

        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header/title with padding and styling
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
                          _showShareConfirmation(contact.displayName ?? '', phone);
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
    final Url = 'http://ec2-13-217-196-244.compute-1.amazonaws.com'; //  URL
    final message = 'Check out this $productName I found on FurnisCape! See more here: $Url';

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You prepared to share $productName details with $contactName.')),
    );
  }

  // void _showShareConfirmation(String contactName, String phone) {
  //   final productName = widget.product.name;
  //   final message = 'Check out this $productName I found on FurnisCape!';
  //
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(content: Text('You shared $productName details with $contactName.')),
  //   );
  //
  //   // Optional: open SMS app with prefilled message
  //   _launchSMS(phone, message);
  // }
  //
  // void _launchSMS(String phoneNumber, String message) async {
  //   final Uri smsUri = Uri(
  //     scheme: 'sms',
  //     path: phoneNumber,
  //     queryParameters: {'body': message},
  //   );
  //
  //   if (await canLaunchUrl(smsUri)) {
  //     await launchUrl(smsUri);
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Could not open SMS app')),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Product Details'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: _handleBack,
            ),
            actions: [
              IconButton(
                icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                onPressed: () => setState(() => isLiked = !isLiked),
                color: isLiked ? Colors.red : Colors.white,
              ),
              IconButton(
                icon: const Icon(Icons.share),
                onPressed: _shareWithContact,  // call the method here
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
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
                Expanded(
                  child: _productImage(product),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _productDetails(product),
                ),
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
                // Minus button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // Primary color background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.remove),
                    color: Colors.white, // icon color white for contrast
                    onPressed: () {
                      if (quantity > 1) setState(() => quantity--);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  quantity.toString(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 8),
                // Plus button
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor, // Primary color background
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.add),
                    color: Colors.white, // icon color white for contrast
                    onPressed: () {
                      setState(() => quantity++);
                    },
                  ),
                ),
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
}