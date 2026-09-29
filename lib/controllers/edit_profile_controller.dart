import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:listako/services/cloudinary_service.dart';

class EditProfileController extends ChangeNotifier {
  final _picker = ImagePicker();

  Uint8List? pickedBytes;
  String? pickedFilename;
  bool isLoading = false;
  bool _disposed = false;

  User? get _user => FirebaseAuth.instance.currentUser;

  // current info
  String get initialName => _user?.displayName ?? '';
  String get email => _user?.email ?? '';
  String? get photoUrl => _user?.photoURL;

  // name check
  String? validateName(String? val) {
    if (val == null || val.trim().isEmpty) return 'Please enter your name';
    if (val.trim().length < 2) return 'Name must be at least 2 characters';
    return null;
  }

  // pick photo (false = picker failed)
  Future<bool> pickImage() async {
    try {
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      if (picked == null) return true;

      pickedBytes = await picked.readAsBytes();
      pickedFilename = picked.name;
      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  // save (returns error message, null = success)
  Future<String?> save(String name) async {
    isLoading = true;
    notifyListeners();

    try {
      final user = _user;

      // upload photo
      if (pickedBytes != null && pickedFilename != null) {
        final url = await CloudinaryService.uploadProfileImage(
          pickedBytes!,
          pickedFilename!,
        );
        await user?.updatePhotoURL(url);
      }

      // update name
      await user?.updateDisplayName(name.trim());
      await user?.reload();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'Failed to update profile.';
    } on CloudinaryUploadException catch (e) {
      return e.message;
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