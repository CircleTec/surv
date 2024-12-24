// lib/core/auth/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getCurrentUser() async {
    try {
      final User? currentUser = _auth.currentUser;
      print("[Auth Debug] Current Firebase user: ${currentUser?.uid}");

      if (currentUser == null) return null;

      // Try admins collection first
      try {
        var adminDoc = await _firestore
            .collection('admins')
            .doc(currentUser.uid)
            .get();

        if (adminDoc.exists) {
          print("[Auth Debug] Found admin document");
          return UserModel.fromMap(currentUser.uid, adminDoc.data()!);
        }
      } catch (e) {
        print("[Auth Debug] Error checking admin document: $e");
      }

      // If not in admins, try surveyors collection
      try {
        var surveyorDoc = await _firestore
            .collection('surveyors')
            .doc(currentUser.uid)
            .get();

        if (surveyorDoc.exists) {
          print("[Auth Debug] Found surveyor document");
          return UserModel.fromMap(currentUser.uid, surveyorDoc.data()!);
        }
      } catch (e) {
        print("[Auth Debug] Error checking surveyor document: $e");
      }

      print("[Auth Debug] No document found in either collection");
      return null;

    } catch (e) {
      print("[Auth Debug] Error getting user data: $e");
      throw Exception('Failed to retrieve user data: $e');
    }
  }

  Future<UserModel?> signIn(String phoneNumber, String password) async {
    try {
      print("[Auth Debug] Attempting sign in for phone: $phoneNumber");
      String email = "$phoneNumber@surv.app";
      print("[Auth Debug] Using email: $email");

      final UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );

      if (result.user == null) {
        throw Exception('Authentication failed');
      }

      print("[Auth Debug] Auth successful for UID: ${result.user!.uid}");

      // Get user data and update last login
      final userData = await getCurrentUser();
      if (userData != null) {
        // Update last login in the appropriate collection
        await _firestore
            .collection(userData.collectionName)
            .doc(result.user!.uid)
            .update({
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }

      return userData;

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