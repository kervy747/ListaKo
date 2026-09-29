import 'package:flutter/material.dart';
import 'package:listako/controllers/change_password_controller.dart';
import 'package:listako/views/theme/app_colors.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = ChangePasswordController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  // snackbar
  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  // change password
  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    final error = await _controller.changePassword(
      current: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
    );
    if (!mounted) return;

    if (error != null) {
      _showMessage(error, AppColors.red);
      return;
    }

    _showMessage('Password changed successfully!', AppColors.green);
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
              'Change Password',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            // autofill off
            child: AutofillGroup(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // info box
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.green.withValues(alpha: 0.3)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, color: AppColors.green, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You will need to enter your current password to confirm the change.',
                              style: TextStyle(fontSize: 13, color: AppColors.green),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // current password label
                    const _FieldLabel(label: 'Current Password'),
                    const SizedBox(height: 8),
                    // current password input
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: !_showCurrent,
                      autofillHints: null,
                      decoration: _inputDecoration(
                        hint: 'Enter current password',
                        icon: Icons.lock_outline,
                        suffixIcon: _ToggleVisibility(
                          isVisible: _showCurrent,
                          onToggle: () => setState(() => _showCurrent = !_showCurrent),
                        ),
                      ),
                      validator: _controller.validateCurrent,
                    ),

                    const SizedBox(height: 20),

                    // new password label
                    const _FieldLabel(label: 'New Password'),
                    const SizedBox(height: 8),
                    // new password input
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_showNew,
                      autofillHints: null,
                      onChanged: (_) => setState(() {}),
                      decoration: _inputDecoration(
                        hint: 'Enter new password',
                        icon: Icons.lock_reset_outlined,
                        suffixIcon: _ToggleVisibility(
                          isVisible: _showNew,
                          onToggle: () => setState(() => _showNew = !_showNew),
                        ),
                      ),
                      validator: (val) =>
                          _controller.validateNew(val, _currentPasswordController.text),
                    ),

                    const SizedBox(height: 8),
                    // strength bar
                    _PasswordStrengthBar(
                      password: _newPasswordController.text,
                      strength: ChangePasswordController.strengthOf(_newPasswordController.text),
                    ),

                    const SizedBox(height: 20),

                    // confirm password label
                    const _FieldLabel(label: 'Confirm New Password'),
                    const SizedBox(height: 8),
                    // confirm password input
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: !_showConfirm,
                      autofillHints: null,
                      decoration: _inputDecoration(
                        hint: 'Re-enter new password',
                        icon: Icons.check_circle_outline,
                        suffixIcon: _ToggleVisibility(
                          isVisible: _showConfirm,
                          onToggle: () => setState(() => _showConfirm = !_showConfirm),
                        ),
                      ),
                      validator: (val) =>
                          _controller.validateConfirm(val, _newPasswordController.text),
                    ),

                    const SizedBox(height: 36),

                    // update button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _controller.isLoading ? null : _changePassword,
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
                                'Update Password',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // input style
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.green),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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

class _FieldLabel extends StatelessWidget {
  const _FieldLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    // label text
    return Text(
      label,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.black54,
      ),
    );
  }
}

class _ToggleVisibility extends StatelessWidget {
  const _ToggleVisibility({required this.isVisible, required this.onToggle});
  final bool isVisible;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    // eye button
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Colors.black38,
        size: 20,
      ),
      onPressed: onToggle,
    );
  }
}

class _PasswordStrengthBar extends StatelessWidget {
  const _PasswordStrengthBar({required this.password, required this.strength});
  final String password;
  final int strength;

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final label = strength <= 1 ? 'Weak' : strength <= 3 ? 'Fair' : 'Strong';
    final color = strength <= 1
        ? AppColors.red
        : strength <= 3
            ? const Color(0xFFC9A227)
            : AppColors.green;
    final filled = (strength / 5).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(top: 6),
      child: Row(
        children: [
          // bar
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: filled,
                backgroundColor: Colors.grey.shade200,
                color: color,
                minHeight: 5,
              ),
            ),
          ),
          const SizedBox(width: 10),
          // strength label
          Text(
            label,
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
