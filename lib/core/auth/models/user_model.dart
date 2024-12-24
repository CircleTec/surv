// lib/core/auth/models/user_model.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String id;
  final String phoneNumber;
  final String fullName;
  final String role;
  final String email;
  final String? location;
  final bool notificationsEnabled;
  final DateTime createdAt;
  final DateTime lastLogin;
  final String? profileImage;
  final Map<String, dynamic>? subscriptionInfo;

  UserModel({
    required this.id,
    required this.phoneNumber,
    required this.fullName,
    required this.role,
    required this.email,
    this.location,
    this.notificationsEnabled = true,
    required this.createdAt,
    required this.lastLogin,
    this.profileImage,
    this.subscriptionInfo,
  });

  // Role getters
  bool get isAdmin => role == 'admin' || role == 'super_admin';
  bool get isSuperAdmin => role == 'super_admin';
  bool get isSurveyor => role == 'surveyor';

  // Collection name getter
  String get collectionName => isAdmin ? 'admins' : 'surveyors';

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

  // Copy with method for making modified copies
  UserModel copyWith({
    String? phoneNumber,
    String? fullName,
    String? role,
    String? email,
    String? location,
    bool? notificationsEnabled,
    DateTime? lastLogin,
    String? profileImage,
    Map<String, dynamic>? subscriptionInfo,
  }) {
    return UserModel(
      id: this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      email: email ?? this.email,
      location: location ?? this.location,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      createdAt: this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      profileImage: profileImage ?? this.profileImage,
      subscriptionInfo: subscriptionInfo ?? this.subscriptionInfo,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, phoneNumber: $phoneNumber, fullName: $fullName, role: $role)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}