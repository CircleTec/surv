// lib/core/firebase/services/firestore.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/firebase_error.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Users Collection
  Future<void> createUser(String uid, Map<String, dynamic> userData) async {
    try {
      await _firestore.collection('users').doc(uid).set(userData);
    } catch (e) {
      throw FirebaseError(message: 'Failed to create user: $e');
    }
  }

  Future<DocumentSnapshot> getUser(String uid) async {
    try {
      return await _firestore.collection('users').doc(uid).get();
    } catch (e) {
      throw FirebaseError(message: 'Failed to get user: $e');
    }
  }

  // Surveys Collection
  Future<QuerySnapshot> getSurveys({String? category}) async {
    try {
      Query query = _firestore.collection('surveys');
      if (category != null) {
        query = query.where('category', isEqualTo: category);
      }
      return await query.get();
    } catch (e) {
      throw FirebaseError(message: 'Failed to get surveys: $e');
    }
  }

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
}