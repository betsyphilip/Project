import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agri_connect/main.dart';

class RentalDetailPage extends StatelessWidget {
  final DocumentSnapshot rentalItem;

  // Constructor to receive the selected rental item
  const RentalDetailPage({super.key, required this.rentalItem, required DocumentSnapshot<Object?> product});

  @override
  Widget build(BuildContext context) {
    // Extract rental details from the rentalItem DocumentSnapshot
    String name = rentalItem['name'];
    String url = rentalItem['url'];
    double price = rentalItem['price'].toDouble();  // Price per day
    String availableFrom = DateFormat('yyyy-MM-dd').format(rentalItem['available_from'].toDate());
    String availableTo = DateFormat('yyyy-MM-dd').format(rentalItem['available_to'].toDate());

    // Controller for the TextField
    TextEditingController daysController = TextEditingController();

    // Variable to hold the total amount calculated
    double totalAmount = 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rental Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the image of the rental item
            CachedNetworkImage(
              imageUrl: url,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 16),

            // Display rental details
            Text(
              name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Price per day: \$${price.toStringAsFixed(2)}'),
            SizedBox(height: 8),
            Text('Available from: $availableFrom'),
            SizedBox(height: 8),
            Text('Available to: $availableTo'),
            SizedBox(height: 16),

            // TextField to input the number of days
            TextField(
              controller: daysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter number of days to rent',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  try {
                    int days = int.parse(value);
                    totalAmount = price * days; // Calculate total rental cost
                  } catch (e) {
                    // Handle invalid input (non-numeric values)
                    totalAmount = 0.0;
                  }
                } else {
                  totalAmount = 0.0; // Reset the amount if no value entered
                }
              },
            ),
            SizedBox(height: 16),

            // Display the total amount to be paid
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            // Rent Now button
            ElevatedButton(
              onPressed: totalAmount > 0 ? () {
                // You can implement the functionality for renting the item here
                print('Rent Now clicked for $name');
              } : null, // Disable if totalAmount is 0
              child: Text('Rent Now'),
            ),
          ],
        ),
      ),
    );
  }
}
