// lib/core/firebase/test/firebase_test_view.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseTestView extends StatefulWidget {
  const FirebaseTestView({Key? key}) : super(key: key);

  @override
  State<FirebaseTestView> createState() => _FirebaseTestViewState();
}

class _FirebaseTestViewState extends State<FirebaseTestView> {
  String _status = 'Running tests...';
  List<String> _testResults = [];

  @override
  void initState() {
    super.initState();
    _runTests();
  }

  Future<void> _runTests() async {
    try {
      // Test 1: Check Firebase Initialization
      _addTest('Checking Firebase initialization...');
      if (Firebase.apps.isEmpty) {
        throw Exception('Firebase not initialized');
      }
      _addTest('✅ Firebase is initialized');

      // Test 2: Check Firestore Connection
      _addTest('Testing Firestore connection...');
      try {
        await FirebaseFirestore.instance
            .collection('test')
            .doc('test')
            .get();
        _addTest('✅ Firestore is connected');
      } catch (e) {
        _addTest('❌ Firestore error: $e');
      }

      // Test 3: Check Auth Instance
      _addTest('Testing Auth service...');
      try {
        FirebaseAuth.instance.authStateChanges().listen((user) {
          _addTest('✅ Auth is working, current user: ${user?.uid ?? 'None'}');
        });
      } catch (e) {
        _addTest('❌ Auth error: $e');
      }

      setState(() {
        _status = 'Tests completed';
      });

    } catch (e) {
      setState(() {
        _status = 'Tests failed: $e';
      });
    }
  }

  void _addTest(String result) {
    setState(() {
      _testResults.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Test'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _status,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _testResults.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Text(_testResults[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}