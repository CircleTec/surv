// lib/core/firebase/config/firebase_config.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../../../firebase_options.dart';

class FirebaseConfig {
  static Future<void> init() async {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Error initializing Firebase: $e');
      rethrow;
    }
  }
}