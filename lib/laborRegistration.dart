import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class LaborerRegistrationPage extends StatefulWidget {
  @override
  _LaborerRegistrationPageState createState() =>
      _LaborerRegistrationPageState();
}

class _LaborerRegistrationPageState extends State<LaborerRegistrationPage> {
  final TextEditingController laborerNameController = TextEditingController();
  final TextEditingController skillsetController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  void registerLaborer() async {
    try {
      // Assuming the user has already been authenticated (e.g., via FirebaseAuth signup)
      String uid = FirebaseAuth.instance.currentUser!.uid;

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'laborerName': laborerNameController.text,
        'skillset': skillsetController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'role': 'Laborer',
      });

      // Save to Realtime Database
      await FirebaseDatabase.instance.ref('Laborer/$uid').set({
        'laborerName': laborerNameController.text,
        'skillset': skillsetController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      });

      print("Laborer registered successfully!");

      // Navigate to the login page
      Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
    } catch (e) {
      print("Registration failed: $e");
      // Optionally, display an error message to the user here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laborer Registration")),
      body: Container(
        color: Colors.lightGreen[100],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: laborerNameController,
                decoration: InputDecoration(labelText: "Laborer Name"),
              ),
              TextField(
                controller: skillsetController,
                decoration: InputDecoration(labelText: "Skillset"),
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "Phone Number"),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerLaborer,
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
