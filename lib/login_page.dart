import 'package:agri_connect/RoleSelection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'homePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _loginUser() async {
    try {
      // Authenticate user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null) {
        String uid = user.uid;

        // Fetch user data from Firestore
        DocumentSnapshot userData = await _firestore.collection('users').doc(uid).get();
        
        if (userData.exists) {
          // Redirect to HomePage if user is found
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()), // Replace HomePage with your home page widget
          );
        } else {
          // Redirect to RoleSelectionPage if user is not found
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => RoleSelectionPage()),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login failed: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loginUser,
              child: Text("Login"),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Navigate to RoleSelectionPage for new user registration
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => RoleSelectionPage()));
              },
              child: Text(
                "New User? Sign Up",
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
