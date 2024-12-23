// lib/core/auth/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String email;  // Changed from optional to required
  final String? location;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? profileImage;
  final Map<String, dynamic>? subscriptionInfo;  // Added for admin users

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.email,  // Now required
    this.location,
    this.notificationsEnabled = true,
    required this.createdAt,
    required this.lastLogin,
    this.profileImage,
    this.subscriptionInfo,
  });

  Map<String, dynamic> toMap() {
    final map = {
      'email': email,
      'phoneNumber': phoneNumber,
      'fullName': fullName,
      'role': role,
      'location': location,
      'notificationsEnabled': notificationsEnabled,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastLogin': Timestamp.fromDate(lastLogin),
      'profileImage': profileImage,
    };

    // Only include subscriptionInfo if it exists
    if (subscriptionInfo != null) {
      map['subscriptionInfo'] = subscriptionInfo;
    }

    return map;
  }

  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      email: map['email'] ?? '${map['phoneNumber']}@surv.app',
      phoneNumber: map['phoneNumber'] ?? '',
      fullName: map['fullName'] ?? '',
      role: map['role'] ?? 'surveyor',
      location: map['location'],
      notificationsEnabled: map['notificationsEnabled'] ?? true,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastLogin: (map['lastLogin'] as Timestamp?)?.toDate() ?? DateTime.now(),
      profileImage: map['profileImage'],
      subscriptionInfo: map['subscriptionInfo'],
    );
  }
}