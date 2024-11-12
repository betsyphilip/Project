import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class PlaceBidPage extends StatefulWidget {
  final DocumentSnapshot auction;

  PlaceBidPage({required this.auction});

  @override
  _PlaceBidPageState createState() => _PlaceBidPageState();
}

class _PlaceBidPageState extends State<PlaceBidPage> {
  final TextEditingController _bidController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Place Bid'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Auction: ${widget.auction['name']}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Starting Price: \$${widget.auction['starting_price']}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Last Bid: \$${widget.auction['bid'] ?? 'No bids yet'}',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _bidController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter your bid',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitBid,
              child: Text('Place Bid'),
            ),
          ],
        ),
      ),
    );
  }

  // Function to submit a new bid
  void _submitBid() async {
    final bid = double.tryParse(_bidController.text);
    if (bid == null || bid <= (widget.auction['bid'] ?? 0)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter a higher bid than the last bid')),
      );
      return;
    }

    try {
      // Update the bid field in the Firestore document
      await _firestore.collection('auctions').doc(widget.auction.id).update({
        'bid': bid,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bid placed successfully!')),
      );
      Navigator.pop(context); // Return to the previous page after placing the bid
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to place bid')),
      );
    }
  }
}
