import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

// upload error
class CloudinaryUploadException implements Exception {
  CloudinaryUploadException(this.message);
  final String message;

  @override
  String toString() => message;
}

// cloudinary
class CloudinaryService {
  CloudinaryService._();

  // settings
  static const String cloudName = 'nf3ia7ai';
  static const String profileUploadPreset = 'listako';
  static const String profileFolder = 'listako/profile_images';

  // upload url
  static Uri get _uploadUri =>
      Uri.parse('https://api.cloudinary.com/v1_1/$cloudName/image/upload');

  // upload photo
  static Future<String> uploadProfileImage(
      Uint8List bytes, String filename) async {
    final request = http.MultipartRequest('POST', _uploadUri)
      ..fields['upload_preset'] = profileUploadPreset
      ..fields['folder'] = profileFolder
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        bytes,
        filename: filename,
      ));

    try {
      final streamed =
          await request.send().timeout(const Duration(seconds: 45));
      final body = await streamed.stream.bytesToString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      if (streamed.statusCode == 200 && json['secure_url'] != null) {
        return json['secure_url'] as String;
      }

      final error = (json['error'] as Map<String, dynamic>?)?['message'];
      throw CloudinaryUploadException(
        error?.toString() ?? 'Upload failed (${streamed.statusCode}).',
      );
    } on CloudinaryUploadException {
      rethrow;
    } catch (_) {
      throw CloudinaryUploadException(
          'Could not upload image. Please try again.');
    }
  }

  // resized photo url
  static String avatarUrl(String url, {int size = 200}) {
    const marker = '/image/upload/';
    if (!url.contains('res.cloudinary.com') || !url.contains(marker)) {
      return url;
    }
    return url.replaceFirst(
      marker,
      '${marker}c_fill,g_face,w_$size,h_$size,f_auto,q_auto/',
    );
  }
}