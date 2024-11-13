import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FeaturedProductDetailPage extends StatelessWidget {
  final String productId; // Pass product ID to fetch specific product

  FeaturedProductDetailPage({required this.productId, required QueryDocumentSnapshot<Object?> product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('product_sales').doc(productId).get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          var product = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(product['url']),
                SizedBox(height: 20),
                Text('Name: ${product['name']}', style: TextStyle(fontSize: 20)),
                Text('Price: ${product['price']}'),
                SizedBox(height: 20),
                Spacer(), // Pushes the "Buy" button to the bottom
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Remove the navigation to payment page
                      // Define your own action here, e.g., adding the product to cart, showing a dialog, etc.
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text("Product Added"),
                          content: Text("You have added ${product['name']} to your cart."),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Buy'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
