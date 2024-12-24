// lib/core/firebase/services/firestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_error.dart';
import '../../auth/models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Surveyors Collection
  Future<void> createSurveyor(String uid, Map<String, dynamic> surveyorData) async {
    try {
      await _firestore.collection('surveyors').doc(uid).set(surveyorData);
    } catch (e) {
      throw FirebaseError(message: 'Failed to create surveyor: $e');
    }
  }

  Future<UserModel?> getSurveyor(String uid) async {
    try {
      final doc = await _firestore.collection('surveyors').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(uid, doc.data()!);
    } catch (e) {
      throw FirebaseError(message: 'Failed to get surveyor: $e');
    }
  }

  Future<List<UserModel>> getAllSurveyors() async {
    try {
      final snapshot = await _firestore.collection('surveyors').get();
      return snapshot.docs
          .map((doc) => UserModel.fromMap(doc.id, doc.data()))
          .toList();
    } catch (e) {
      throw FirebaseError(message: 'Failed to get surveyors: $e');
    }
  }

  // Admin Collection
  Future<void> createAdmin(String uid, Map<String, dynamic> adminData) async {
    try {
      await _firestore.collection('admins').doc(uid).set(adminData);
    } catch (e) {
      throw FirebaseError(message: 'Failed to create admin: $e');
    }
  }

  Future<UserModel?> getAdmin(String uid) async {
    try {
      final doc = await _firestore.collection('admins').doc(uid).get();
      if (!doc.exists) return null;
      return UserModel.fromMap(uid, doc.data()!);
    } catch (e) {
      throw FirebaseError(message: 'Failed to get admin: $e');
    }
  }

  // Analytics
  Future<void> createSurveyorStats(String surveyorId) async {
    try {
      await _firestore
          .collection('analytics')
          .doc('surveyors')
          .collection(surveyorId)
          .doc('stats')
          .set({
        'completedSurveys': 0,
        'averageResponseTime': 0,
        'responseQuality': 0,
      });
    } catch (e) {
      throw FirebaseError(message: 'Failed to create surveyor stats: $e');
    }
  }

  // Surveys Collection
  Future<void> createSurvey(Map<String, dynamic> surveyData) async {
    try {
      await _firestore.collection('surveys').add(surveyData);
    } catch (e) {
      throw FirebaseError(message: 'Failed to create survey: $e');
    }
  }

  // Survey Responses
  Future<void> submitSurveyResponse(Map<String, dynamic> responseData) async {
    try {
      await _firestore.collection('survey_responses').add(responseData);
    } catch (e) {
      throw FirebaseError(message: 'Failed to submit response: $e');
    }
  }

  // Assignments
  Future<void> createSurveyorAssignment({
    required String surveyorId,
    required String surveyId,
    required String assignedBy,
  }) async {
    try {
      await _firestore.collection('surveyor_assignments').add({
        'surveyorId': surveyorId,
        'surveyId': surveyId,
        'assignedAt': FieldValue.serverTimestamp(),
        'assignedBy': assignedBy,
        'status': 'pending',
        'progress': 0,
      });
    } catch (e) {
      throw FirebaseError(message: 'Failed to create assignment: $e');
    }
  }

  // Settings
  Future<Map<String, dynamic>> getAppConfig() async {
    try {
      final doc = await _firestore
          .collection('settings')
          .doc('app_config')
          .get();
      return doc.data() ?? {};
    } catch (e) {
      throw FirebaseError(message: 'Failed to get app config: $e');
    }
  }
}