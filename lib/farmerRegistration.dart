import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FarmerRegistrationPage extends StatefulWidget {
  const FarmerRegistrationPage({super.key});

  @override
  _FarmerRegistrationPageState createState() => _FarmerRegistrationPageState();
}

class _FarmerRegistrationPageState extends State<FarmerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String name = '';
  String email = '';
  String contact = '';
  String govtId = '';
  String address = '';
  String place = '';
  String district = '';
  String state = '';
  String pin = '';
  String password = '';
  String confirmPassword = '';
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  Future<void> _registerFarmer() async {
    if (_formKey.currentState!.validate()) {
      if (password == confirmPassword) {
        try {
          // Create a new user in Firebase Authentication
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          String uid = userCredential.user!.uid;

          // Save to Firestore with the user's UID
          await _firestore.collection('farmers').doc(uid).set({
            'name': name,
            'email': email,
            'contact': contact,
            'govt_id': govtId,
            'address': address,
            'place': place,
            'district': district,
            'state': state,
            'pin': pin,
          });

          // Clear fields and show success message
          _formKey.currentState!.reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration successful!')),
          );
          Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);

          // Optionally navigate to another page
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

        } catch (e) {
          print("Failed to sign up: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Registration failed: $e')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Farmer Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) => value!.isEmpty ? 'Enter your name' : null,
                  onChanged: (value) => name = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) => value!.isEmpty || !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)
                      ? 'Enter a valid email'
                      : null,
                  onChanged: (value) => email = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Contact'),
                  validator: (value) => value!.isEmpty ? 'Enter your contact number' : null,
                  onChanged: (value) => contact = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Government ID'),
                  validator: (value) => value!.isEmpty ? 'Enter your government ID' : null,
                  onChanged: (value) => govtId = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Address'),
                  validator: (value) => value!.isEmpty ? 'Enter your address' : null,
                  onChanged: (value) => address = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Place'),
                  validator: (value) => value!.isEmpty ? 'Enter your place' : null,
                  onChanged: (value) => place = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'District'),
                  validator: (value) => value!.isEmpty ? 'Enter your district' : null,
                  onChanged: (value) => district = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'State'),
                  validator: (value) => value!.isEmpty ? 'Enter your state' : null,
                  onChanged: (value) => state = value,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'PIN'),
                  validator: (value) => value!.isEmpty ? 'Enter your PIN' : null,
                  onChanged: (value) => pin = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                  validator: (value) => value!.isEmpty ? 'Enter your password' : null,
                  onChanged: (value) => password = value,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
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
                  validator: (value) => value!.isEmpty ? 'Confirm your password' : null,
                  onChanged: (value) => confirmPassword = value,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerFarmer,
                  child: Text('Register'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
