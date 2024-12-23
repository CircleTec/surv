// lib/core/auth/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utilities/phone_utility.dart';
import '../views/login_view.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;  // Added this
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with current user
    firebaseUser.value = _auth.currentUser;
    // Bind to auth state changes
    firebaseUser.bindStream(_authService.authStateChanges);
    ever(firebaseUser, _handleAuthChanged);
    print("[Auth Debug] AuthController initialized");
  }

  Future<void> _handleAuthChanged(User? user) async {
    print("[Auth Debug] Auth state changed. User: ${user?.uid}");

    if (user == null) {
      print("[Auth Debug] User is null, redirecting to login");
      userModel.value = null;
      if (isInitialized.value) {
        await Get.offAllNamed('/');
      }
    } else {
      try {
        print("[Auth Debug] User authenticated: ${user.uid}");
        isLoading.value = true;

        final userData = await _authService.getCurrentUser();
        print("[Auth Debug] Retrieved user data: ${userData?.toMap()}");

        if (userData == null) {
          print("[Auth Debug] No Firestore user data found");
          await signOut();
          return;
        }

        userModel.value = userData;
        print("[Auth Debug] User role: ${userData.role}");

        // Ensure we're initialized before navigating
        isInitialized.value = true;

        // Handle navigation based on role
        final role = userData.role.toLowerCase();
        print("[Auth Debug] Navigating based on role: $role");

        switch (role) {
          case 'admin':
            print("[Auth Debug] Navigating to admin view");
            await Get.offAllNamed('/admin');
            break;
          case 'surveyor':
            print("[Auth Debug] Navigating to surveyor view");
            await Get.offAllNamed('/surveyor');
            break;
          default:
            print("[Auth Debug] Invalid role: $role");
            Get.snackbar(
              'Error',
              'Invalid user role',
              snackPosition: SnackPosition.BOTTOM,
            );
            await signOut();
        }
      } catch (e) {
        print("[Auth Debug] Error in auth flow: $e");
        Get.snackbar(
          'Error',
          'Failed to retrieve user data: $e',
          snackPosition: SnackPosition.BOTTOM,
        );
        await signOut();
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> signIn(String phoneNumber, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      print("[Auth Debug] Starting sign in process");
      if (!PhoneUtility.isValidPhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }
      if (password.isEmpty) {
        throw Exception('Password is required');
      }

      String standardizedPhone = PhoneUtility.standardizePhoneNumber(phoneNumber);
      print("[Auth Debug] Attempting sign in with phone: $standardizedPhone");

      // Get the UserModel from signIn
      final user = await _authService.signIn(standardizedPhone, password);

      if (user != null) {
        print("[Auth Debug] Sign in successful, triggering auth state change");
        // Manually trigger auth state change if needed
        firebaseUser.value = _auth.currentUser;
      } else {
        print("[Auth Debug] Sign in failed - no user returned");
        throw Exception('Sign in failed');
      }

    } catch (e) {
      print("[Auth Debug] Sign in error: $e");
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      print("[Auth Debug] Initiating sign out");
      await _authService.signOut();
      // Manually update state
      firebaseUser.value = null;
      userModel.value = null;
    } catch (e) {
      print("[Auth Debug] Sign out error: $e");
      Get.snackbar(
        'Error',
        'Failed to sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}