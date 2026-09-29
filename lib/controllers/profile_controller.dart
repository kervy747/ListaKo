import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileController extends ChangeNotifier {
  User? get _user => FirebaseAuth.instance.currentUser;

  // user info
  String get displayName => _user?.displayName ?? 'No name set';
  String get email => _user?.email ?? 'No email';
  String? get photoUrl => _user?.photoURL;
  String get initials => initialsFor(_user?.displayName ?? '');

  // refresh after edit
  void refresh() => notifyListeners();

  // initials from name
  static String initialsFor(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return '?';
    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return trimmed[0].toUpperCase();
  }
}