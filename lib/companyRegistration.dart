import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class CompanyRegistrationPage extends StatefulWidget {
  @override
  _CompanyRegistrationPageState createState() => _CompanyRegistrationPageState();
}

class _CompanyRegistrationPageState extends State<CompanyRegistrationPage> {
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController registrationIdController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  void registerCompany() async {
    // Validate email and password
    if (passwordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      print("Password fields cannot be empty!");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      print("Passwords do not match!");
      return;
    }

    try {
      // Create user with email and password
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // Save company information to Firestore
      await FirebaseFirestore.instance.collection('companies').doc(uid).set({
        'companyName': companyNameController.text.trim(),
        'registrationId': registrationIdController.text.trim(),
        'email': emailController.text.trim(),
        'role': 'Company',
      });

      // Save company information to Realtime Database
      await FirebaseDatabase.instance.ref('Company/$uid').set({
        'companyName': companyNameController.text.trim(),
        'registrationId': registrationIdController.text.trim(),
      });

      // Clear input fields or navigate to another page after successful registration
      print("Company registered successfully!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Company registered successfully!')),
      );
       print("Laborer registered successfully!");

      // Navigate to the login page
      Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

      // Optionally, navigate to another page or clear fields
      // Navigator.pop(context); // Go back or navigate to a different page

    } catch (e) {
      print("Failed to register company: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company Registration")),
      body: Container(
        color: const Color.fromARGB(255, 22, 165, 190), // Set your desired background color here
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: companyNameController,
              decoration: InputDecoration(labelText: "Company Name"),
            ),
            TextField(
              controller: registrationIdController,
              decoration: InputDecoration(labelText: "Company Registration ID"),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: "Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_passwordVisible,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: "Confirm Password",
                suffixIcon: IconButton(
                  icon: Icon(
                    _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      _confirmPasswordVisible = !_confirmPasswordVisible;
                    });
                  },
                ),
              ),
              obscureText: !_confirmPasswordVisible,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: registerCompany,
              child: Text("Register"),
            ),
          ],
        ),
      ),
    );
  }
}
