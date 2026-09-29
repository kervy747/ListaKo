import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;

  // login
  Future<void> handleLogin({
    required String email,
    required String password,
    required void Function(String username) onSuccess,
  }) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final username = credential.user?.displayName?.isNotEmpty == true
          ? credential.user!.displayName!
          : (credential.user?.email?.split('@').first ?? 'there');

      onSuccess(username);
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
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect password or email';
      case 'invalid-email':
        return 'That email address looks invalid.';
      default:
        return 'Could not sign in. Please try again.';
    }
  }

  // clear error
  void clearError() {
    errorMessage = null;
    notifyListeners();
  }
}