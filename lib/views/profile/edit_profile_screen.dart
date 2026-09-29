import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:listako/controllers/edit_profile_controller.dart';
import 'package:listako/controllers/profile_controller.dart';
import 'package:listako/views/theme/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = EditProfileController();
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: _controller.initialName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // snackbar
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // pick photo
  Future<void> _pickImage() async {
    final ok = await _controller.pickImage();
    if (!ok && mounted) {
      _showMessage('Could not open the image picker.', AppColors.red);
    }
  }

  // save
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await _controller.save(_nameController.text);
    if (!mounted) return;

    if (error != null) {
      _showMessage(error, AppColors.red);
      return;
    }

    _showMessage('Profile updated successfully!', AppColors.green);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          // app bar
          appBar: AppBar(
            backgroundColor: AppColors.green,
            foregroundColor: AppColors.white,
            elevation: 0,
            title: const Text(
              'Edit Profile',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // avatar
                  Center(
                    child: _AvatarPreview(
                      nameController: _nameController,
                      photoUrl: _controller.photoUrl,
                      pickedBytes: _controller.pickedBytes,
                      onTap: _controller.isLoading ? null : _pickImage,
                    ),
                  ),
                  const SizedBox(height: 10),
                  // photo hint
                  const Center(
                    child: Text(
                      'Tap photo to change',
                      style: TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // name label
                  const Text(
                    'Display Name',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // name input
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    decoration: _inputDecoration(
                      hint: 'Enter your name',
                      icon: Icons.person_outline,
                    ),
                    validator: _controller.validateName,
                  ),

                  const SizedBox(height: 20),

                  // email label
                  const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // email input (read only)
                  TextFormField(
                    initialValue: _controller.email,
                    readOnly: true,
                    decoration: _inputDecoration(
                      hint: '',
                      icon: Icons.email_outlined,
                    ).copyWith(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      suffixIcon: const Tooltip(
                        message: 'Email cannot be changed',
                        child: Icon(Icons.lock_outline,
                            size: 18, color: Colors.black38),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black45),
                  ),

                  const SizedBox(height: 36),

                  // save button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _controller.isLoading ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.green,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                      child: _controller.isLoading
                          // loading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                color: AppColors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // input style
  InputDecoration _inputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.green),
      filled: true,
      fillColor: AppColors.white,
      contentPadding:
          const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.green, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.red, width: 1.5),
      ),
    );
  }
}

class _AvatarPreview extends StatelessWidget {
  const _AvatarPreview({
    required this.nameController,
    required this.onTap,
    this.photoUrl,
    this.pickedBytes,
  });

  final TextEditingController nameController;
  final VoidCallback? onTap;
  final String? photoUrl;
  final Uint8List? pickedBytes;

  @override
  Widget build(BuildContext context) {
    final ImageProvider? previewImage =
        pickedBytes != null ? MemoryImage(pickedBytes!) : null;
    final hasPhoto = photoUrl != null && photoUrl!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // photo or initials (updates while typing)
          ListenableBuilder(
            listenable: nameController,
            builder: (context, _) => CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.green,
              backgroundImage: previewImage ??
                  (hasPhoto ? NetworkImage(photoUrl!) as ImageProvider : null),
              child: (previewImage == null && !hasPhoto)
                  ? Text(
                      ProfileController.initialsFor(nameController.text),
                      style: const TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.white,
                      ),
                    )
                  : null,
            ),
          ),
          // gallery badge
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.yellow,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.white, width: 2),
              ),
              child: const Icon(Icons.photo_library_outlined,
                  size: 16, color: AppColors.textDark),
            ),
          ),
        ],
      ),
    );
  }
}
