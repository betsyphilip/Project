// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class AuctionDetailPage extends StatefulWidget {
//   final String auctionId;

//   AuctionDetailPage({required this.auctionId});

//   @override
//   _AuctionDetailPageState createState() => _AuctionDetailPageState();
// }

// class _AuctionDetailPageState extends State<AuctionDetailPage> {
//   late Future<DocumentSnapshot> auctionDetails;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch auction details from Firestore
//     auctionDetails = FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(widget.auctionId)
//         .get();
//   }

//   // Function to format timestamp into a readable date
//   String formatDate(Timestamp timestamp) {
//     DateTime date = timestamp.toDate();
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Auction Details")),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: auctionDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData) {
//             return Center(child: Text('No data available'));
//           }

//           // Auction data
//           var auction = snapshot.data!;
//           var startTimestamp = auction['starting_time'] as Timestamp?;
//           var endTimestamp = auction['ending_time'] as Timestamp?;
//           var bidAmount = auction['Bid'] ?? 0.0;
//           var startingPrice = auction['starting_price'];
//           var auctionName = auction['name'];
//           var imageUrl = auction['url'];

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Auction Image
//                 Image.network(imageUrl),
//                 SizedBox(height: 20),

//                 // Auction Name and Starting Price
//                 Text('Name: $auctionName', style: TextStyle(fontSize: 20)),
//                 Text('Starting Price: $startingPrice'),
//                 SizedBox(height: 20),

//                 // Display starting and ending times
//                 if (startTimestamp != null)
//                   Text('Start Time: ${formatDate(startTimestamp)}', style: TextStyle(fontSize: 16)),
//                 if (endTimestamp != null)
//                   Text('End Time: ${formatDate(endTimestamp)}', style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 20),

//                 // "Place Bid" Button
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         TextEditingController bidController = TextEditingController();
//                         return AlertDialog(
//                           title: Text("Place Your Bid"),
//                           content: TextField(
//                             controller: bidController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(hintText: "Enter your bid amount"),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 // Add bid logic here
//                                 if (bidController.text.isNotEmpty) {
//                                   double bid = double.parse(bidController.text);
//                                   _placeBid(bid);
//                                 }
//                                 Navigator.pop(context);
//                               },
//                               child: Text("Place Bid"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text('Place Bid'),
//                 ),
//                 SizedBox(height: 20),

//                 // Display Current Bid Amount
//                 Text(
//                   'Current Bid: \$${bidAmount.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Function to place a bid
//   Future<void> _placeBid(double bid) async {
//     // Update the bid in Firestore
//     await FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(widget.auctionId)
//         .update({'Bid': bid}); // Updates the highest bid in Firestore
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';

// class AuctionDetailPage extends StatefulWidget {
//   final String auctionId;

//   AuctionDetailPage({required this.auctionId, required QueryDocumentSnapshot<Object?> auction});

//   @override
//   _AuctionDetailPageState createState() => _AuctionDetailPageState();
// }

// class _AuctionDetailPageState extends State<AuctionDetailPage> {
//   late Future<DocumentSnapshot> auctionDetails;

//   @override
//   void initState() {
//     super.initState();
//     // Fetch auction details from Firestore
//     auctionDetails = FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(widget.auctionId)
//         .get();
//   }

//   // Function to format timestamp into a readable date
//   String formatDate(Timestamp timestamp) {
//     DateTime date = timestamp.toDate();
//     return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Auction Details")),
//       body: FutureBuilder<DocumentSnapshot>(
//         future: auctionDetails,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('No data available'));
//           }

//           // Auction data
//           var auction = snapshot.data!;
//           var startTimestamp = auction['starting_time'] as Timestamp;
//           var endTimestamp = auction['ending_time'] as Timestamp;
//           var bidAmount = auction['Bid'];
//           var startingPrice = auction['starting_price'];
//           var auctionName = auction['name'];
//           var imageUrl = auction['url'];

//           // Check if description exists before accessing it
//           var description = auction.data() != null && auction.data()!.containsKey('description')
//               ? auction['description']
//               : 'No description available';

//           return Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Auction Image
//                 Image.network(imageUrl),
//                 SizedBox(height: 20),

//                 // Auction Name and Starting Price
//                 Text('Name: $auctionName', style: TextStyle(fontSize: 20)),
//                 Text('Starting Price: $startingPrice'),
//                 SizedBox(height: 20),

//                 // Display starting and ending times
//                 Text('Start Time: ${formatDate(startTimestamp)}', style: TextStyle(fontSize: 16)),
//                 Text('End Time: ${formatDate(endTimestamp)}', style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 20),

//                 // Display description if available
//                 Text('Description: $description', style: TextStyle(fontSize: 16)),
//                 SizedBox(height: 20),

//                 // "Place Bid" Button
//                 ElevatedButton(
//                   onPressed: () {
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         TextEditingController bidController = TextEditingController();
//                         return AlertDialog(
//                           title: Text("Place Your Bid"),
//                           content: TextField(
//                             controller: bidController,
//                             keyboardType: TextInputType.number,
//                             decoration: InputDecoration(hintText: "Enter your bid amount"),
//                           ),
//                           actions: [
//                             TextButton(
//                               onPressed: () {
//                                 if (bidController.text.isNotEmpty) {
//                                   double bid = double.parse(bidController.text);
//                                   _placeBid(bid);
//                                 }
//                                 Navigator.pop(context);
//                               },
//                               child: Text("Place Bid"),
//                             ),
//                           ],
//                         );
//                       },
//                     );
//                   },
//                   child: Text('Place Bid'),
//                 ),
//                 SizedBox(height: 20),

//                 // Display Current Bid Amount
//                 Text(
//                   'Current Bid: $bidAmount',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   // Function to place a bid
//   Future<void> _placeBid(double bid) async {
//     await FirebaseFirestore.instance
//         .collection('auctions')
//         .doc(widget.auctionId)
//         .update({'Bid': bid}); // Update the bid in Firestore
//   }
// }
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class AuctionDetailPage extends StatefulWidget {
  final String auctionId;

  AuctionDetailPage({required this.auctionId, required QueryDocumentSnapshot<Object?> auction});

  @override
  _AuctionDetailPageState createState() => _AuctionDetailPageState();
}

class _AuctionDetailPageState extends State<AuctionDetailPage> {
  late Future<DocumentSnapshot> auctionDetails;

  @override
  void initState() {
    super.initState();
    // Fetch auction details from Firestore
    auctionDetails = FirebaseFirestore.instance
        .collection('auctions')
        .doc(widget.auctionId)
        .get();
  }

  // Function to format timestamp into a readable date
  String formatDate(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Auction Details")),
      body: FutureBuilder<DocumentSnapshot>(
        future: auctionDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No data available'));
          }

          // Auction data
          var auction = snapshot.data!;
          var startTimestamp = auction['starting_time'] as Timestamp;
          var endTimestamp = auction['ending_time'] as Timestamp;
          var bidAmount = auction['Bid'];
          var startingPrice = auction['starting_price'];
          var auctionName = auction['name'];
          var imageUrl = auction['url'];

          // Check if description exists before accessing it
          Map<String, dynamic> auctionData = auction.data() as Map<String, dynamic>;
          var description = auctionData.containsKey('description')
              ? auctionData['description']
              : 'No description available';

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Auction Image
                Image.network(imageUrl),
                SizedBox(height: 20),

                // Auction Name and Starting Price
                Text('Name: $auctionName', style: TextStyle(fontSize: 20)),
                Text('Starting Price: $startingPrice'),
                SizedBox(height: 20),

                // Display starting and ending times
                Text('Start Time: ${formatDate(startTimestamp)}', style: TextStyle(fontSize: 16)),
                Text('End Time: ${formatDate(endTimestamp)}', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),

                // Display description if available
                Text('Description: $description', style: TextStyle(fontSize: 16)),
                SizedBox(height: 20),

                // "Place Bid" Button
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController bidController = TextEditingController();
                        return AlertDialog(
                          title: Text("Place Your Bid"),
                          content: TextField(
                            controller: bidController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(hintText: "Enter your bid amount"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                if (bidController.text.isNotEmpty) {
                                  double bid = double.parse(bidController.text);
                                  _placeBid(bid);
                                }
                                Navigator.pop(context);
                              },
                              child: Text("Place Bid"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text('Place Bid'),
                ),
                SizedBox(height: 20),

                // Display Current Bid Amount
                Text(
                  'Current Bid: $bidAmount',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Function to place a bid
  Future<void> _placeBid(double bid) async {
    await FirebaseFirestore.instance
        .collection('auctions')
        .doc(widget.auctionId)
        .update({'Bid': bid}); // Update the bid in Firestore
  }
}
