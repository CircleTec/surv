// lib/core/auth/controllers/auth_controller.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utilities/phone_utility.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables
  final Rx<User?> firebaseUser = Rx<User?>(null);
  final Rx<UserModel?> userModel = Rx<UserModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isInitialized = false.obs;
  final RxBool inSurveyorMode = false.obs;  // For admins viewing surveyor UI

  @override
  void onInit() {
    super.onInit();
    print("[Auth Debug] Initializing AuthController");
    // Initialize with current user if exists
    firebaseUser.value = _auth.currentUser;
    // Bind to auth state changes
    firebaseUser.bindStream(_authService.authStateChanges);
    ever(firebaseUser, _handleAuthChanged);
    print("[Auth Debug] AuthController initialized");
  }

  // Handle authentication state changes
  Future<void> _handleAuthChanged(User? user) async {
    print("[Auth Debug] Auth state changed. User: ${user?.uid}");

    if (user == null) {
      print("[Auth Debug] User is null, redirecting to login");
      userModel.value = null;
      inSurveyorMode.value = false;
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

        // Only set initialized after successful data retrieval
        isInitialized.value = true;

        // Handle navigation based on role and mode
        await _handleNavigation(userData);

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

  // Handle navigation based on user role and mode
  Future<void> _handleNavigation(UserModel user) async {
    if (user.isAdmin && !inSurveyorMode.value) {
      print("[Auth Debug] Navigating to admin view");
      await Get.offAllNamed('/admin');
    } else if (user.isSurveyor || inSurveyorMode.value) {
      print("[Auth Debug] Navigating to surveyor view");
      await Get.offAllNamed('/surveyor');
    } else {
      print("[Auth Debug] Invalid role configuration");
      Get.snackbar(
        'Error',
        'Invalid user role configuration',
        snackPosition: SnackPosition.BOTTOM,
      );
      await signOut();
    }
  }

  // Sign in method
  Future<void> signIn(String phoneNumber, String password) async {
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      print("[Auth Debug] Starting sign in process");

      // Validate inputs
      if (!PhoneUtility.isValidPhoneNumber(phoneNumber)) {
        throw Exception('Invalid phone number format');
      }
      if (password.isEmpty) {
        throw Exception('Password is required');
      }

      String standardizedPhone = PhoneUtility.standardizePhoneNumber(phoneNumber);
      print("[Auth Debug] Attempting sign in with phone: $standardizedPhone");

      // Attempt sign in
      final user = await _authService.signIn(standardizedPhone, password);

      if (user != null) {
        print("[Auth Debug] Sign in successful, triggering auth state change");
        // Auth state change will handle navigation
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

  // Sign out method
  Future<void> signOut() async {
    try {
      print("[Auth Debug] Initiating sign out");
      await _authService.signOut();
      // Clear local state
      firebaseUser.value = null;
      userModel.value = null;
      inSurveyorMode.value = false;
    } catch (e) {
      print("[Auth Debug] Sign out error: $e");
      Get.snackbar(
        'Error',
        'Failed to sign out',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Toggle between admin and surveyor mode (for admin users)
  void toggleSurveyorMode() {
    if (userModel.value?.isAdmin ?? false) {
      inSurveyorMode.value = !inSurveyorMode.value;
      // Trigger navigation update
      _handleNavigation(userModel.value!);
    }
  }

  // Helper getters
  bool get isAuthenticated => firebaseUser.value != null;
  bool get isAdmin => userModel.value?.isAdmin ?? false;
  bool get isSuperAdmin => userModel.value?.isSuperAdmin ?? false;
  bool get isSurveyor => userModel.value?.isSurveyor ?? false;
  bool get canAccessSurveyorUI => isAdmin || isSurveyor;
  bool get canAccessAdminUI => isAdmin && !inSurveyorMode.value;
}