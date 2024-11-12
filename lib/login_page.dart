import 'package:agri_connect/RoleSelection.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers for text fields
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Method to handle login
  Future<void> _loginUser() async {
    try {
      // Authenticate user with email and password
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      // Get the user ID
      String uid = userCredential.user!.uid;

      // Fetch user data from the database
      DataSnapshot userData = await _database.child('users/$uid').get();

      // If user data exists, navigate to home page or other functionality
      if (userData.exists) {
        // Navigate to home page (you can create this separately)
        print("User data: ${userData.value}");
      } else {
        print("User not found in database.");
      }

    } catch (e) {
      print("Error: $e");
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
                // Navigate to sign-up page
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
