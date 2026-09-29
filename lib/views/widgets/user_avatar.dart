import 'package:flutter/material.dart';
import 'package:listako/services/cloudinary_service.dart';

class UserAvatar extends StatelessWidget {
  const UserAvatar({
    super.key,
    required this.radius,
    required this.initials,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.initialsFontSize,
    this.photoUrl,
  });

  final double radius;
  final String initials;
  final Color backgroundColor;
  final Color foregroundColor;
  final double initialsFontSize;
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    // photo
    ImageProvider? image;
    if (photoUrl != null && photoUrl!.isNotEmpty) {
      image = NetworkImage(
        CloudinaryService.avatarUrl(photoUrl!, size: (radius * 4).round()),
      );
    }

    // avatar circle
    return CircleAvatar(
      radius: radius,
      backgroundColor: backgroundColor,
      backgroundImage: image,
      onBackgroundImageError: image == null ? null : (_, __) {},
      child: image != null
          ? null
          // initials
          : Text(
              initials,
              style: TextStyle(
                fontSize: initialsFontSize,
                fontWeight: FontWeight.w800,
                color: foregroundColor,
              ),
            ),
    );
  }
}