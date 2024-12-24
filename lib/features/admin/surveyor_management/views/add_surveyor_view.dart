// lib/features/admin/surveyor_management/views/add_surveyor_view.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/auth/services/auth_service.dart';
import '../../../../core/firebase/services/firestore.dart';
import '../../../../core/firebase/models/firebase_error.dart';
import '../../../../core/auth/models/user_model.dart';
import '../../../../core/constants/user_roles.dart';

class AddSurveyorView extends StatefulWidget {
  const AddSurveyorView({Key? key}) : super(key: key);

  @override
  State<AddSurveyorView> createState() => _AddSurveyorViewState();
}

class _AddSurveyorViewState extends State<AddSurveyorView> {
  final _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _selectedLocation;
  List<String> _selectedGroups = ['General'];
  bool _isLoading = false;
  String? _error;

  // List of Ethiopian cities
  final List<String> _ethiopianCities = [
    'Addis Ababa',
    'Dire Dawa',
    'Mekelle',
    'Gondar',
    'Adama',
    'Hawassa',
    'Bahir Dar',
    'Jimma',
    'Dessie',
    'Jijiga',
    'Shashamane',
    'Bishoftu',
    'Sodo',
    'Arba Minch',
    'Hosaena',
    'Harar',
    'Dilla',
    'Nekemte',
    'Debre Birhan',
    'Asella',
  ];

  // Default groups
  final List<String> _defaultGroups = [
    'General',
    'Field Agents',
    'Market Research',
    'Customer Satisfaction',
    'Quality Control'
  ];

  @override
  void initState() {
    super.initState();
    // Generate a random password
    _passwordController.text = const Uuid().v4().substring(0, 12);
  }

  Future<void> _addSurveyor() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Format and validate phone number
      final phoneNumber = _phoneController.text.trim();
      if (phoneNumber.length != 10 || !phoneNumber.startsWith('0')) {
        throw FirebaseError(
          message: 'Invalid phone number format. Must be like: 0921331494',
        );
      }

      // Create the email from phone number
      final email = '$phoneNumber@surv.app';

      // Create auth user with email/password
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );

      if (userCredential.user == null) {
        throw FirebaseError(message: 'Failed to create user account');
      }

      // Create user model for surveyor
      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        phoneNumber: phoneNumber,
        fullName: '${_firstNameController.text} ${_lastNameController.text}',
        role: UserRoles.surveyor,
        location: _selectedLocation,
        notificationsEnabled: true,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
      );

      // Create surveyor in Firestore
      await _firestoreService.createSurveyor(
        userCredential.user!.uid,
        newUser.toMap(),
      );

      // Create analytics for the surveyor
      await _firestoreService.createSurveyorStats(userCredential.user!.uid);

      // Success - close dialog and refresh parent
      Navigator.of(context).pop(true);
    } on FirebaseAuthException catch (e) {
      setState(() {
        switch (e.code) {
          case 'email-already-in-use':
            _error = 'A surveyor with this phone number already exists';
            break;
          case 'invalid-email':
            _error = 'Invalid phone number format';
            break;
          case 'operation-not-allowed':
            _error = 'Email/password accounts are not enabled. Please contact support';
            break;
          case 'weak-password':
            _error = 'The password is too weak. Please generate a new one';
            break;
          default:
            _error = e.message ?? 'An error occurred while creating the account';
        }
      });
    } on FirebaseError catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = 'An unexpected error occurred: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Surveyor'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add Surveyor',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fill your personal details',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 24),

              // First Name and Last Name Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                        filled: true,
                        fillColor: Color(0xFFF7F7F7),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                        filled: true,
                        fillColor: Color(0xFFF7F7F7),
                      ),
                      validator: (value) =>
                      value?.isEmpty ?? true ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Phone Number
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                  hintText: '0921331494',
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Required';
                  if (value!.length != 10) return 'Phone number must be 10 digits';
                  if (!value.startsWith('0')) return 'Phone number must start with 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Location Dropdown
              DropdownButtonFormField<String>(
                value: _selectedLocation,
                decoration: const InputDecoration(
                  labelText: 'Primary Location',
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                ),
                items: _ethiopianCities
                    .map((city) => DropdownMenuItem(
                  value: city,
                  child: Text(city),
                ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                validator: (value) =>
                value == null ? 'Please select a city' : null,
              ),
              const SizedBox(height: 16),

              // Groups Dropdown
              DropdownButtonFormField<String>(
                value: _selectedGroups.first,
                decoration: const InputDecoration(
                  labelText: 'Assign to Group',
                  filled: true,
                  fillColor: Color(0xFFF7F7F7),
                ),
                items: _defaultGroups
                    .map((group) => DropdownMenuItem(
                  value: group,
                  child: Text(group),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedGroups = [value];
                    });
                  }
                },
              ),
              const SizedBox(height: 24),

              // Generated Password
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Generated Password',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordController,
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(
                            text: _passwordController.text,
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Error Message
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    _error!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                ),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _addSurveyor,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF5EE0C5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                      : const Text(
                    'Add Surveyor',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}