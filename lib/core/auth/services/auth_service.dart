import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../utilities/phone_utility.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> signIn(String phoneNumber, String password) async {
    try {
      print("[Auth Debug] Attempting sign in for phone: $phoneNumber");
      String email = PhoneUtility.createFirebaseAuthEmail(phoneNumber);
      print("[Auth Debug] Using email: $email");

      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if (result.user == null) {
        throw Exception('Authentication failed');
      }

      print("[Auth Debug] Auth successful for UID: ${result.user!.uid}");

      // Get user document using Auth UID
      final userDoc = await _firestore
          .collection('users')
          .doc(result.user!.uid)
          .get();

      if (!userDoc.exists) {
        print("[Auth Debug] No Firestore document found for UID: ${result.user!.uid}");
        throw Exception('User data not found');
      }

      print("[Auth Debug] Found Firestore document: ${userDoc.data()}");

      // Update last login
      await userDoc.reference.update({
        'lastLogin': FieldValue.serverTimestamp(),
        'email': email
      });

      print("[Auth Debug] Updated last login timestamp");

      final userModel = UserModel.fromMap(result.user!.uid, userDoc.data()!);
      print("[Auth Debug] Created UserModel with role: ${userModel.role}");

      return userModel;
    } on FirebaseAuthException catch (e) {
      print("[Auth Debug] Firebase Auth Error: ${e.code} - ${e.message}");
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found with this phone number');
        case 'wrong-password':
          throw Exception('Invalid password');
        case 'invalid-email':
          throw Exception('Invalid phone number format');
        case 'user-disabled':
          throw Exception('This account has been disabled');
        default:
          throw Exception('Authentication failed: ${e.message}');
      }
    } catch (e) {
      print("[Auth Debug] General Error: $e");
      throw Exception('Authentication failed: $e');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final User? currentUser = _auth.currentUser;
      print("[Auth Debug] Current Firebase user: ${currentUser?.uid}");

      if (currentUser == null) return null;

      // Get user document directly by Auth UID
      final userDoc = await _firestore
          .collection('users')
          .doc(currentUser.uid)
          .get();

      if (!userDoc.exists) {
        print("[Auth Debug] No Firestore document found for UID: ${currentUser.uid}");
        return null;
      }

      print("[Auth Debug] Found user document: ${userDoc.data()}");

      final userModel = UserModel.fromMap(currentUser.uid, userDoc.data()!);
      print("[Auth Debug] Created UserModel with role: ${userModel.role}");
      return userModel;

    } catch (e) {
      print("[Auth Debug] Error getting user data: $e");
      throw Exception('Failed to retrieve user data: $e');
    }
  }

  Future<void> signOut() async {
    try {
      print("[Auth Debug] Signing out");
      await _auth.signOut();
    } catch (e) {
      print("[Auth Debug] Error signing out: $e");
      throw Exception('Failed to sign out: $e');
    }
  }
}
