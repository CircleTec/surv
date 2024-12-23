// lib/core/firebase/services/firebase_auth.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../firebase/models/firebase_error.dart';
import '../../constants/user_roles.dart';
import '../../auth/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Add getCurrentUser method
  Future<UserModel?> getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user == null) return null;

      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (!doc.exists) return null;

      return UserModel.fromMap(user.uid, doc.data()!);
    } catch (e) {
      throw FirebaseError(message: 'Failed to get current user: $e');
    }
  }

  // Add signIn method that returns UserModel
  Future<UserModel?> signIn(String phoneNumber, String password) async {
    try {
      final email = '$phoneNumber@surv.app';
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) return null;

      // Update last login
      await _firestore.collection('users').doc(userCredential.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      // Return user model
      return getCurrentUser();
    } catch (e) {
      throw FirebaseError(message: 'Sign in failed: $e');
    }
  }

  Future<String> getUserRole(String uid) async {
    try {
      final userDoc = await _firestore.collection('users').doc(uid).get();
      return userDoc.data()?['role'] ?? '';
    } catch (e) {
      throw FirebaseError(message: 'Failed to get user role: $e');
    }
  }

  Future<bool> isAdmin(String uid) async {
    try {
      final role = await getUserRole(uid);
      return role == UserRoles.admin;
    } catch (e) {
      return false;
    }
  }

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String) onCodeSent,
    required Function(String) onError,
  }) async {
    try {
      // Ensure only admins can add new users
      final currentUid = _auth.currentUser?.uid;
      if (currentUid == null || !await isAdmin(currentUid)) {
        throw FirebaseError(
          message: 'Unauthorized: Only admins can add new users',
        );
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      throw FirebaseError(message: 'Phone verification failed: $e');
    }
  }

  Future<void> verifyOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      await _auth.signInWithCredential(credential);
    } catch (e) {
      throw FirebaseError(message: 'OTP verification failed: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw FirebaseError(message: 'Sign out failed: $e');
    }
  }

  // For checking access in the UI
  static Future<bool> checkAdminAccess(BuildContext context) async {
    final auth = FirebaseAuth.instance;
    final firestore = FirebaseFirestore.instance;

    try {
      final user = auth.currentUser;
      if (user == null) {
        return false;
      }

      final userDoc = await firestore.collection('users').doc(user.uid).get();
      return userDoc.data()?['role'] == UserRoles.admin;
    } catch (e) {
      return false;
    }
  }
}