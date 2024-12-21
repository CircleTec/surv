// lib/core/firebase/models/firebase_error.dart
class FirebaseError implements Exception {
  final String message;

  FirebaseError({required this.message});

  @override
  String toString() => message;
}