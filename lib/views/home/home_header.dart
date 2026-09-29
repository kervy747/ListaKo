import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../../models/currency.dart';
import '../widgets/user_avatar.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.username,
    required this.currency,
    required this.onCurrencyTap,
    required this.onLogoutTap,
    required this.onProfileTap, // ← NEW
    this.photoUrl,
  });

  final String username;
  final AppCurrency currency;
  final VoidCallback onCurrencyTap;
  final VoidCallback onLogoutTap;
  final VoidCallback onProfileTap; // ← NEW
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    final initial = username.isNotEmpty ? username[0].toUpperCase() : '?';
    final displayName =
        username.isEmpty ? username : '${username[0].toUpperCase()}${username.substring(1)}';

    return Row(
      children: [
        // ── Tappable avatar + name area ──────────────────────────────────────
        Expanded(
          child: InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(12),
            child: Row(
              children: [
                Stack(
                  children: [
                    UserAvatar(
                      radius: 22,
                      initials: initial,
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.green,
                      initialsFontSize: 18,
                      photoUrl: photoUrl,
                    ),
                    // Small edit badge on the avatar
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 14,
                        height: 14,
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 9,
                          color: AppColors.green,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, $displayName',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.white,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Tap to view profile',
                        style: TextStyle(fontSize: 11, color: Colors.white60),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ── Currency picker ──────────────────────────────────────────────────
        InkWell(
          onTap: onCurrencyTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 10,
                  backgroundColor: AppColors.yellow,
                  child: Text(
                    currency.symbol,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  currency.code,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 6),

        // ── Logout ───────────────────────────────────────────────────────────
        IconButton(
          icon: const Icon(Icons.logout, color: AppColors.white, size: 20),
          tooltip: 'Log out',
          onPressed: onLogoutTap,
        ),
      ],
    );
  }
}