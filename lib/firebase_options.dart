// TODO Implement this library.
import 'package:firebase_core/firebase_core.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    return const FirebaseOptions(
      apiKey: 'AIzaSyC6yGopMx65XWMH11FJx_MQaZWZNVHR1ZA',
      appId: '1:148824871801:android:0e76942059798765b915a8',
      messagingSenderId: '148824871801',
      projectId: 'agriconnect-8aede',
      storageBucket: 'agriconnect-8aede.appspot.com',
      authDomain: 'noreply@agriconnect-8aede.firebaseapp.com',  // If using Firebase Auth
      databaseURL: 'https://agriconnect-8aede-default-rtdb.asia-southeast1.firebasedatabase.app', // If using Firebase Realtime Database
      measurementId: 'YOUR_MEASUREMENT_ID', // If using Firebase Analytics
    );
  }
}
