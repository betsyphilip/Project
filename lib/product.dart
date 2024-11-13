import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProductDetailPage extends StatelessWidget {
  final dynamic product; // Product data passed from HomePage

  // Constructor to receive the product data
  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']), // Display product name in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the product image
            CachedNetworkImage(
              imageUrl: product['url'], // Image URL from Firestore
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),
            // Display product name
            Text(
              product['name'],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            // Display product description (if available)
            Text(
              product['description'] ?? 'No description available.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 16),
            // Add any other product details here (if needed)
            ElevatedButton(
              onPressed: () {
                // Button action (e.g., add to cart or rent)
              },
              child: Text('Add to Cart'), // Example button
            ),
          ],
        ),
      ),
    );
  }
}
