class PhoneUtility {
  // Standardize phone number format
  static String standardizePhoneNumber(String phoneNumber) {
    // Remove any non-digit characters
    String cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');

    // If number starts with 251, convert to 0 format
    if (cleaned.startsWith('251')) {
      cleaned = '0${cleaned.substring(3)}';
    }
    // If number starts with neither 0 nor 251, add 0
    else if (!cleaned.startsWith('0')) {
      cleaned = '0$cleaned';
    }

    return cleaned;
  }

  // Create email for Firebase Authentication
  static String createFirebaseAuthEmail(String phoneNumber) {
    String cleaned = standardizePhoneNumber(phoneNumber);
    // Keep the exact phone number format for email
    return '$cleaned@surv.app';
  }

  // Validate Ethiopian phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    String cleaned = standardizePhoneNumber(phoneNumber);
    // Ethiopian format: 09XXXXXXXX or 251XXXXXXXXX
    final phoneRegex = RegExp(r'^(0|251)?9\d{8}$');
    return phoneRegex.hasMatch(cleaned);
  }

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    String cleaned = standardizePhoneNumber(phoneNumber);
    if (cleaned.length != 10) return phoneNumber;
    return '${cleaned.substring(0, 4)} ${cleaned.substring(4, 7)} ${cleaned.substring(7)}';
  }
}