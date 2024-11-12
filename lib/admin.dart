import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> createSystemAdminIfNeeded() async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  const String adminEmail = "admin@agriconnect.com";
  const String adminPassword = "securePassword123";  // Change to a secure password

  // Check if the admin document exists in Firestore
  var adminSnapshot = await firestore.collection('admins').doc(adminEmail).get();

  if (!adminSnapshot.exists) {
    try {
      // Attempt to create an admin user in Firebase Authentication
      UserCredential userCredential;
      try {
        userCredential = await auth.createUserWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
        print("Admin user created in Firebase Auth.");
      } catch (e) {
        print("Admin user may already exist in Firebase Auth: $e");
        userCredential = await auth.signInWithEmailAndPassword(
          email: adminEmail,
          password: adminPassword,
        );
      }

      // Set admin details in Firestore
      await firestore.collection('admins').doc(adminEmail).set({
        'email': adminEmail,
        'role': 'admin',
        'uid': userCredential.user!.uid,
      });

      print("System Admin created and verified in Firestore.");
    } catch (e) {
      print("Error managing system admin: $e");
    }
  } else {
    print("System Admin already exists in Firestore.");
  }
}
