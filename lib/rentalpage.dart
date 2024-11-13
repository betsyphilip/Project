import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RentalPage extends StatefulWidget {
  const RentalPage({super.key});

  @override
  _RentalPageState createState() => _RentalPageState();
}

class _RentalPageState extends State<RentalPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream to fetch rental items from Firestore
  final Stream<QuerySnapshot> _rentalStream = FirebaseFirestore.instance.collection('rentals').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rental Items')),
      body: StreamBuilder<QuerySnapshot>(
        stream: _rentalStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No rental items available.'));
          }

          var rentalItems = snapshot.data!.docs;

          return ListView.builder(
            itemCount: rentalItems.length,
            itemBuilder: (context, index) {
              var rentalItem = rentalItems[index];
              return _buildRentalItemCard(rentalItem);
            },
          );
        },
      ),
    );
  }

  // Function to build a rental item card
  Widget _buildRentalItemCard(DocumentSnapshot rentalItem) {
    // Fetch rental details from the document
    String name = rentalItem['name'];
    String price = rentalItem['price'].toString();
    String availableFrom = (rentalItem['available_from'] as Timestamp).toDate().toLocal().toString().split(' ')[0];
    String availableTo = (rentalItem['available_to'] as Timestamp).toDate().toLocal().toString().split(' ')[0];
    String imageUrl = rentalItem['url'];

    return Card(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: ListTile(
        leading: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
        ),
        title: Text(name, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Price: \$$price/day', style: TextStyle(fontSize: 16)),
            Text('Available from: $availableFrom', style: TextStyle(fontSize: 14)),
            Text('Available to: $availableTo', style: TextStyle(fontSize: 14)),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.arrow_forward),
          onPressed: () {
            // Navigate to rental details page
            _showRentalDetailsPage(rentalItem);
          },
        ),
      ),
    );
  }

  // Show rental item details in a new page
  void _showRentalDetailsPage(DocumentSnapshot rentalItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RentalDetailPage(rentalItem: rentalItem),
      ),
    );
  }
}

class RentalDetailPage extends StatelessWidget {
  final DocumentSnapshot rentalItem;

  const RentalDetailPage({super.key, required this.rentalItem});

  @override
  Widget build(BuildContext context) {
    String name = rentalItem['name'];
    String price = rentalItem['price'].toString();
    String availableFrom = (rentalItem['available_from'] as Timestamp).toDate().toLocal().toString().split(' ')[0];
    String availableTo = (rentalItem['available_to'] as Timestamp).toDate().toLocal().toString().split(' ')[0];
    String imageUrl = rentalItem['url'];

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CachedNetworkImage(
              imageUrl: imageUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text('Name: $name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Price: \$$price/day', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Available from: $availableFrom', style: TextStyle(fontSize: 14)),
            SizedBox(height: 10),
            Text('Available to: $availableTo', style: TextStyle(fontSize: 14)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle rental logic, like booking the item
                print('Rent item');
              },
              child: Text('Rent Now'),
            ),
          ],
        ),
      ),
    );
  }
}
