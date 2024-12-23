// lib/main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'core/auth/controllers/auth_controller.dart';
import 'core/auth/views/login_view.dart';
import 'features/admin/admin_main_view.dart';
import 'features/surveyor/main/views/surveyor_main_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("[App Debug] Initializing app...");

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print("[App Debug] Firebase initialized");

  // Initialize AuthController
  final authController = Get.put(AuthController());
  print("[App Debug] AuthController initialized");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print("[App Debug] Building MyApp");
    return GetMaterialApp(
      title: 'Surv',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF5EE0C5),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF5EE0C5),
        ),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const LoginView(),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/admin',
          page: () => const AdminMainView(initialIndex: 0),
          transition: Transition.fadeIn,
        ),
        GetPage(
          name: '/surveyor',
          page: () => const SurveyorMainView(),
          transition: Transition.fadeIn,
        ),
      ],
    );
  }
}