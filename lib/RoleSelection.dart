import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoleSelectionPage extends StatefulWidget {
  const RoleSelectionPage({super.key});

  @override
  _RoleSelectionPageState createState() => _RoleSelectionPageState();
}


class _RoleSelectionPageState extends State<RoleSelectionPage> {
  String? selectedRole;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Your Role")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            // Role selection using Radio buttons
            ListTile(
              title: Text("Farmer"),
              leading: Radio<String>(
                value: 'Farmer',
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Company"),
              leading: Radio<String>(
                value: 'Company',
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Customer"),
              leading: Radio<String>(
                value: 'Customer',
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Laborer"),
              leading: Radio<String>(
                value: 'Laborer',
                groupValue: selectedRole,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value;
                  });
                },
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (selectedRole != null) {
                  try {
                    // Create a new user in Firebase Authentication
                    UserCredential userCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text,
                            password: passwordController.text);

                    // Store user data and selected role in Firestore
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userCredential.user!.uid)
                        .set({
                      'email': emailController.text,
                      'role': selectedRole,
                    });

                    // Navigate to specific registration page based on role
                    if (selectedRole == 'Farmer') {
                      
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FarmerRegistrationPage()),
                      );
                    } else if (selectedRole == 'Company') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompanyRegistrationPage()),
                      );
                    } else if (selectedRole == 'Customer') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerRegistrationPage()),
                      );
                    } else if (selectedRole == 'Laborer') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => LaborerRegistrationPage()),
                      );
                    }
                  } catch (e) {
                    print("Failed to sign up: $e");
                  }
                }
              },
              child: Text("Continue"),
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder for different registration pages for each role

class FarmerRegistrationPage extends StatelessWidget {
  const FarmerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Farmer Registration")),
      body: Center(child: Text("Farmer Registration Page")),
    );
  }
}

class CompanyRegistrationPage extends StatelessWidget {
  const CompanyRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Company Registration")),
      body: Center(child: Text("Company Registration Page")),
    );
  }
}

class CustomerRegistrationPage extends StatelessWidget {
  const CustomerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Customer Registration")),
      body: Center(child: Text("Customer Registration Page")),
    );
  }
}

class LaborerRegistrationPage extends StatelessWidget {
  const LaborerRegistrationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Laborer Registration")),
      body: Center(child: Text("Laborer Registration Page")),
    );
  }
}
