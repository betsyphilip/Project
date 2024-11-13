import 'package:agri_connect/feature.dart';
import 'package:agri_connect/placebid.dart';
import 'package:agri_connect/rentalpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:cached_network_image/cached_network_image.dart';
import 'package:agri_connect/rentaldetail.dart';
import 'auction.dart'; // Import Auction Detail Page
import 'feature.dart';
import 'product.dart'; // Import Product Detail Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetching collections from Firestore
  final Stream<QuerySnapshot> _auctionStream = FirebaseFirestore.instance.collection('auctions').snapshots();
  final Stream<QuerySnapshot> _availableProductStream = FirebaseFirestore.instance.collection('available_product').snapshots();
  final Stream<QuerySnapshot> _featuredProductStream = FirebaseFirestore.instance.collection('product_sales').snapshots();

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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Upcoming Auctions', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: auctions.map((auction) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Auction Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuctionDetailPage(auction: auction, auctionId: '',),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: auction['url'],
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                auction['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Available Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: products.map((product) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Product Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(product: product),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: product['url'],
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Featured Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: products.map((product) {
                  return GestureDetector(
                    onTap: () {
                      // Navigate to Featured Product Detail Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FeaturedProductDetailPage(product: product, productId: '',),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 5,
                      child: Container(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CachedNetworkImage(
                              imageUrl: product['url'],
                              width: double.infinity,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                product['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
