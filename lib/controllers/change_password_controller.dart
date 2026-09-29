import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChangePasswordController extends ChangeNotifier {
  bool isLoading = false;
  bool _disposed = false;

  // current password check
  String? validateCurrent(String? val) {
    if (val == null || val.isEmpty) return 'Please enter your current password';
    return null;
  }

  // new password check
  String? validateNew(String? val, String current) {
    if (val == null || val.isEmpty) return 'Please enter a new password';
    if (val.length < 6) return 'Password must be at least 6 characters';
    if (val == current) return 'New password must differ from current password';
    return null;
  }

  // confirm password check
  String? validateConfirm(String? val, String newPassword) {
    if (val == null || val.isEmpty) return 'Please confirm your new password';
    if (val != newPassword) return 'Passwords do not match';
    return null;
  }

  // strength score 0-5
  static int strengthOf(String password) {
    if (password.isEmpty) return 0;
    int score = 0;
    if (password.length >= 6) score++;
    if (password.length >= 10) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }

  // change password (returns error message, null = success)
  Future<String?> changePassword({
    required String current,
    required String newPassword,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null || user.email == null) return 'No user logged in.';

      // confirm current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: current,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'wrong-password':
          return 'Current password is incorrect.';
        case 'weak-password':
          return 'New password is too weak. Use at least 6 characters.';
        case 'requires-recent-login':
          return 'Please log out and log back in before changing your password.';
        default:
          return e.message ?? 'Failed to change password.';
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void notifyListeners() {
    if (!_disposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}