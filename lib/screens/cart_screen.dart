import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:furniscapemobileapp/models/cartitem.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';
import 'package:furniscapemobileapp/services/location_service.dart';
import 'package:geolocator/geolocator.dart';
import 'package:furniscapemobileapp/screens/favorites_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
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
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final cart = Provider.of<CartProvider>(context);

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Cart',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    // List or empty message inside a ConstrainedBox with max height
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: constraints.maxHeight * 0.6, // 60% of available height
                      ),
                      child: cart.items.isEmpty
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/emptycart.jpg',
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Your cart is Empty!',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Looks like you haven\'t added anything yet.',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      )
                          : isWide
                          ? GridView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cart.items.length,
                        gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 3.5,
                        ),
                        itemBuilder: (context, index) {
                          var cartItem = cart.items.values.toList()[index];
                          return CartItemWidget(cartItem: cartItem);
                        },
                      )
                          : ListView.separated(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: cart.items.length,
                        itemBuilder: (ctx, index) {
                          var cartItem = cart.items.values.toList()[index];
                          return CartItemWidget(cartItem: cartItem);
                        },
                        separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                      ),
                    ),

                    const SizedBox(height: 20),

                    PriceSummarySection(
                      subtotal: cart.subTotal,
                      delivery: cart.deliveryFee,
                      tax: cart.tax,
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: cart.items.isEmpty
                            ? null
                            : () async {
                          Position position;
                          String address = '';

                          try {
                            position = await LocationService.determinePosition();
                            address = await LocationService.getAddressFromLatLng(
                              position.latitude,
                              position.longitude,
                            );
                          } catch (e) {
                            address = 'Location unavailable';
                          }

                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Order placed!'),
                              content: Text(
                                'Total paid: Rs. ${cart.totalAmount.toStringAsFixed(0)}\n\n'
                                    'Delivery Address:\n$address',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    cart.clear();
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('OK'),
                                )
                              ],
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        ),
                        child: Text('Proceed to checkout',
                        style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItem cartItem;
  const CartItemWidget({required this.cartItem});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          //   Image
          SizedBox(
            width: 50,
            height: 50,
            child: Image.network(
              cartItem.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => Icon(Icons.image),
            ),
          ),
          SizedBox(width: 12,),

          //   Title and price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(cartItem.title,
                  style: Theme.of(context).textTheme.bodyLarge,),
                SizedBox(height: 4,),
                Text(
                  'Rs. ${cartItem.price.toStringAsFixed(0)}',
                  style: TextStyle(
                    color:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                )
              ],
            ),
          ),

          //   Quantity controls  and delete
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 36,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () => cart.decreaseQuantity(cartItem.productId),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36, 30),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Text('-',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      '${cartItem.quantity}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    width: 36,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () => cart.decreaseQuantity(cartItem.productId),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36, 30),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                      ),
                      child: Text('+',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                  ),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Text(
                    'Rs. ${(cartItem.price * cartItem.quantity).toStringAsFixed(0)}',
                  ),
                  SizedBox(width: 4),
                  GestureDetector(
                    onTap: () => cart.removeItem(cartItem.productId),
                    child: Icon(Icons.delete, color: Colors.red),
                  )
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

class PriceSummarySection extends StatelessWidget {
  final double subtotal;
  final double delivery;
  final double tax;

  const PriceSummarySection({
    required this.subtotal,
    required this.delivery,
    required this.tax,
  });

  @override
  Widget build(BuildContext context) {
    final total = subtotal + delivery + tax;
    final theme = Theme.of(context);

    Widget summaryRow(String label, double amount, {bool isBold = false}) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isBold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium,
          ),
          Text(
            'Rs. ${amount.toInt()}',
            style: isBold ? theme.textTheme.titleMedium : theme.textTheme.bodyMedium,
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          summaryRow('Subtotal', subtotal),
          SizedBox(height: 8),
          summaryRow('Delivery Fee', delivery),
          SizedBox(height: 8),
          summaryRow('Tax', tax),
          Divider(
            thickness: 1,
            color: theme.colorScheme.outline.withOpacity(0.5),
          ),
          SizedBox(height: 8),
          summaryRow('Total', total, isBold: true),
        ],
      ),
    );
  }
}
