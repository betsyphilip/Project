import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class CustomerRegistrationPage extends StatefulWidget {
  const CustomerRegistrationPage({super.key});

  @override
  _CustomerRegistrationPageState createState() => _CustomerRegistrationPageState();
}

class _CustomerRegistrationPageState extends State<CustomerRegistrationPage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  bool isLoading = false;

  void registerCustomer() async {
    if (passwordController.text != confirmPasswordController.text) {
      print("Passwords do not match!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Passwords do not match!')));
      return; // Early exit if passwords do not match
    }

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      print("Email or password is empty!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Email or password is empty!')));
      return;
    }

    try {
      setState(() {
        isLoading = true; // Show loading indicator
      });

      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      String uid = userCredential.user!.uid;

      // Save to Firestore
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'place': placeController.text,
        'pinCode': pinCodeController.text,
        'district': districtController.text,
        'role': 'Customer',
      });

      // Save to Realtime Database
      await FirebaseDatabase.instance.ref('Customer/$uid').set({
        'fullName': fullNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
        'place': placeController.text,
        'pinCode': pinCodeController.text,
        'district': districtController.text,
      });

      print("Customer registered successfully!");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration successful!")));

      // Navigate to the login page
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
    } catch (e) {
      print("Registration failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registration failed: $e")));
    } finally {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Registration")),
      body: Container(
        color: Colors.lightGreen[100],
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: fullNameController,
                decoration: InputDecoration(labelText: "Full Name"),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
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
              TextField(
                controller: placeController,
                decoration: InputDecoration(labelText: "Place"),
              ),
              TextField(
                controller: pinCodeController,
                decoration: InputDecoration(labelText: "Pin Code"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: districtController,
                decoration: InputDecoration(labelText: "District"),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
              TextField(
                controller: confirmPasswordController,
                decoration: InputDecoration(labelText: "Confirm Password"),
                obscureText: true,
              ),
              SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator() // Show loading indicator
                  : ElevatedButton(
                      onPressed: registerCustomer,
                      child: Text("Register"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
