// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/firebase/config/firebase_config.dart';
import 'core/auth/views/login_view.dart';
import 'core/firebase/firebase/test/firebase_test_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseConfig.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Surv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5EE0C5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5EE0C5),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5EE0C5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
      ),
      //home: const LoginView(),
      home: const FirebaseTestView(),
    );
  }
}