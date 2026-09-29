import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // register
  Future<void> handleRegister({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
    required void Function(String username) onSuccess,
  }) async {
    if (password != confirmPassword) {
      errorMessage = 'Passwords do not match.';
      notifyListeners();
      return;
    }

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      await credential.user?.updateDisplayName(name.trim());
      await credential.user?.reload();

      onSuccess(name.trim());
    } on FirebaseAuthException catch (e) {
      errorMessage = _messageForCode(e.code);
      notifyListeners();
    } catch (e) {
      errorMessage = 'Something went wrong. Please try again.';
      notifyListeners();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // error text
  String _messageForCode(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'weak-password':
        return 'Password is too weak — use at least 6 characters.';
      default:
        return 'Could not create account. Please try again.';
    }
  }

  // clear error
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}