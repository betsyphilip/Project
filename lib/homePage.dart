import 'package:agri_connect/placebid.dart';
import 'package:agri_connect/rentalpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agri_connect/rentaldetail.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetching collections from Firestore
  Stream<QuerySnapshot> _auctionStream = FirebaseFirestore.instance.collection('auctions').snapshots();
  Stream<QuerySnapshot> _availableProductStream = FirebaseFirestore.instance.collection('available_product').snapshots();
  Stream<QuerySnapshot> _featuredProductStream = FirebaseFirestore.instance.collection('product_sales').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('AgriConnect')),
      body: _selectedIndex == 0 ? _buildHomePage() : RentalPage(), // Rent page content can go here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bento), label: 'Rent'),
        ],
      ),
    );
  }

  // Handle navigation between pages
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
        
    });
  }
  

  // Home page content with auctions, available products, and featured products
  Widget _buildHomePage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildAuctionSection(),
          _buildAvailableProductSection(),
          _buildFeaturedProductSection(),
        ],
      ),
    );
  }

  // Auction section
  Widget _buildAuctionSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _auctionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Text("No auctions available.");
        }

        var auctions = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Upcoming Auctions', style: TextStyle(fontSize: 20)),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: auctions.length,
                itemBuilder: (context, index) {
                  var auction = auctions[index];
                  return GestureDetector(
                    onTap: () => _showAuctionPopup(auction),
                    child: Card(
                      child: CachedNetworkImage(
                        imageUrl: auction['url'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Available products section
  Widget _buildAvailableProductSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _availableProductStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Text("No available products.");
        }

        var products = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Available Products', style: TextStyle(fontSize: 20)),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return GestureDetector(
                    onTap: () => _showProductPopup(product),
                    child: Card(
                      child: CachedNetworkImage(
                        imageUrl: product['url'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Featured products section
  Widget _buildFeaturedProductSection() {
    return StreamBuilder<QuerySnapshot>(
      stream: _featuredProductStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Text("No featured products available.");
        }

        var products = snapshot.data!.docs;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Featured Products', style: TextStyle(fontSize: 20)),
            ),
            Container(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                itemBuilder: (context, index) {
                  var product = products[index];
                  return GestureDetector(
                    onTap: () => _showFeaturedProductPopup(product),
                    child: Card(
                      child: CachedNetworkImage(
                        imageUrl: product['url'],
                        height: 150,
                        width: 150,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Show auction details in a pop-up
  // 
  void _showAuctionPopup(DocumentSnapshot auction) {
  DateTime startTime = (auction['starting_time'] as Timestamp).toDate();
  DateTime endTime = (auction['ending_time'] as Timestamp).toDate();
  DateTime currentTime = DateTime.now();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: auction['url'], width: double.infinity),
              SizedBox(height: 10),
              Text('Name: ${auction['name']}', style: TextStyle(fontSize: 16)),
              Text('Description: ${auction['description']}', style: TextStyle(fontSize: 16)),
              Text('Starting Price: \$${auction['starting_price']}', style: TextStyle(fontSize: 16)),
              Text('Start Time: ${startTime.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 16)),
              Text('End Time: ${endTime.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              if (currentTime.isAfter(startTime) && currentTime.isBefore(endTime))
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the popup
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PlaceBidPage(auction: auction),
                      ),
                    );
                  },
                  child: Text('Place Bid'),
                ),
            ],
          ),
        ),
      );
    },
  );
}


  // Show available product details in a pop-up
  void _showProductPopup(DocumentSnapshot product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: product['url'], width: double.infinity),
              SizedBox(height: 10),
              Text('Name: ${product['name']}', style: TextStyle(fontSize: 16)),
            ],
          ),
        );
      },
    );
  }

  // Show featured product details in a pop-up
  void _showFeaturedProductPopup(DocumentSnapshot product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(imageUrl: product['url'], width: double.infinity),
              SizedBox(height: 10),
              Text('Name: ${product['name']}', style: TextStyle(fontSize: 16)),
              Text('Price: \$${product['Price']}', style: TextStyle(fontSize: 16)),
              Text('Quantity: ${product['Quantity']}', style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Handle purchase logic
                  print('Buy Now');
                },
                child: Text('Buy'),
              ),
            ],
          ),
        );
      },
    );
  }
}
