import 'package:flutter/material.dart';
import 'package:listako/controllers/profile_controller.dart';
import 'package:listako/views/profile/change_password_screen.dart';
import 'package:listako/views/profile/edit_profile_screen.dart';
import 'package:listako/views/theme/app_colors.dart';
import 'package:listako/views/widgets/user_avatar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _controller = ProfileController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // open edit profile
  Future<void> _navigateToEditProfile() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    _controller.refresh();
  }

  // open change password
  Future<void> _navigateToChangePassword() async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChangePasswordScreen()),
    );
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
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // profile header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: const BoxDecoration(color: AppColors.green),
                  child: Column(
                    children: [
                      // avatar
                      UserAvatar(
                        radius: 44,
                        initials: _controller.initials,
                        backgroundColor: AppColors.white,
                        foregroundColor: AppColors.green,
                        initialsFontSize: 32,
                        photoUrl: _controller.photoUrl,
                      ),
                      const SizedBox(height: 12),
                      // name
                      Text(
                        _controller.displayName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // email
                      Text(
                        _controller.email,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // account options
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // section title
                      const Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Colors.black45,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // edit profile tile
                      _ProfileTile(
                        icon: Icons.person_outline,
                        label: 'Edit Profile',
                        subtitle: 'Change your name or photo',
                        onTap: _navigateToEditProfile,
                      ),
                      const SizedBox(height: 10),
                      // change password tile
                      _ProfileTile(
                        icon: Icons.lock_outline,
                        label: 'Change Password',
                        subtitle: 'Update your password',
                        onTap: _navigateToChangePassword,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProfileTile extends StatelessWidget {
  const _ProfileTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    // tile box
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              // icon box
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.green, size: 22),
              ),
              const SizedBox(width: 14),
              // label + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 12, color: Colors.black45),
                    ),
                  ],
                ),
              ),
              // arrow
              const Icon(Icons.chevron_right, color: Colors.black26),
            ],
          ),
        ),
      ),
    );
  }
}
