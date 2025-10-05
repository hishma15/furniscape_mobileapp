import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:furniscapemobileapp/models/cartitem.dart';
import 'package:furniscapemobileapp/providers/cart_provider.dart';

import 'package:furniscapemobileapp/services/location_service.dart';
import 'package:geolocator/geolocator.dart';


class CartScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),

      ),
      body: Padding(
          padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: cart.items.isEmpty
                  ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      //   Image
                        Image.asset('assets/images/emptycart.jpg',
                          width: 180,
                          height: 180,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 20,),
                      //   Text
                        Text('Your cart is Empty!',
                        style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(height: 8,),
                        Text('Looks like you haven\'t added anything yet.',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withOpacity(0.6),
                          ),
                        )
                      ],
                    )
                  )
                  : ListView.separated(
                    itemBuilder: (ctx, index) {
                      var cartItem = cart.items.values.toList()[index];
                      return CartItemWidget(cartItem: cartItem);
                    },
                    separatorBuilder: (_, __) => SizedBox(height: 12,),
                    itemCount: cart.items.length
                  ),
              ),
          SizedBox(height: 20,),
          PriceSummarySection(
            subtotal: cart.subTotal,
            delivery: cart.deliveryFee,
            tax: cart.tax,
          ),
          SizedBox(height: 20,),
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //       onPressed: cart.items.isEmpty
          //           ? null
          //           : () {
          //       //   Simulate checkout
          //         showDialog(
          //             context: context,
          //             builder: (_) => AlertDialog(
          //               title: Text('Order placed!'),
          //               content: Text(
          //                 'Total paid: Rs. ${cart.totalAmount.toStringAsFixed(0)}'
          //               ),
          //               actions: [
          //                 TextButton(
          //                     onPressed: () {
          //                       cart.clear();
          //                       Navigator.of(context).pop();
          //                     },
          //                   child: Text('OK'),
          //                 )
          //               ],
          //             )
          //         );
          //       },
          //     style: ElevatedButton
          //         .styleFrom(
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //       padding: EdgeInsets.symmetric(vertical: 16),
          //     ),
          //     child: Text('Proceed to checkout'),
          //   ),
          // )
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
                    title: Text('Order placed!'),
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
                        child: Text('OK'),
                      )
                    ],
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Proceed to checkout'),
            ),
          ),
        ],
      ),),
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
                      ),
                      child: Text('-'),
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
                      onPressed: () => cart.increaseQuantity(cartItem.productId),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size(36, 30),
                      ),
                      child: Text('+'),
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

// class CartScreen extends StatelessWidget {
//   const CartScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Cart'),),
//       body: const Center(child: Text('Cart Screen'),),
//     );
//   }
// }