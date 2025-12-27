import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get _apiKey => dotenv.env['CLOUDINARY_API_KEY'] ?? '';
  static String get _apiSecret => dotenv.env['CLOUDINARY_API_SECRET'] ?? '';

  static String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  /// Pick image from gallery
  static Future<XFile?> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image from gallery: $e');
      return null;
    }
  }

  /// Pick image from camera
  static Future<XFile?> pickImageFromCamera() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      debugPrint('Error picking image from camera: $e');
      return null;
    }
  }

  /// Upload image to Cloudinary with unsigned upload (using preset)
  static Future<CloudinaryResponse?> uploadImage(
    XFile imageFile, {
    String? folder,
    String? publicId,
  }) async {
    try {
      const uploadPreset = 'signalx_preset'; // Your unsigned preset

      // Prepare multipart request
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      // Add file
      if (kIsWeb) {
        final bytes = await imageFile.readAsBytes();
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: imageFile.name),
        );
      } else {
        request.files.add(
          await http.MultipartFile.fromPath('file', imageFile.path),
        );
      }

      // Add upload preset (no signature needed!)
      request.fields['upload_preset'] = uploadPreset;

      if (folder != null) {
        request.fields['folder'] = folder;
      }

      if (publicId != null) {
        request.fields['public_id'] = publicId;
      }

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return CloudinaryResponse.fromJson(jsonResponse);
      } else {
        debugPrint('Cloudinary upload failed: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading to Cloudinary: $e');
      return null;
    }
  }

  /// Generate SHA1 signature
  static String _generateSha1Signature(String data) {
    final bytes = utf8.encode(data);
    final digest = sha1.convert(bytes);
    return digest.toString();
  }

  /// Get optimized image URL with transformations
  static String getOptimizedUrl(
    String publicId, {
    int? width,
    int? height,
    String? crop,
    String? gravity,
    int? quality,
    String? format,
  }) {
    final transformations = <String>[];

    if (width != null) transformations.add('w_$width');
    if (height != null) transformations.add('h_$height');
    if (crop != null) transformations.add('c_$crop');
    if (gravity != null) transformations.add('g_$gravity');
    if (quality != null) transformations.add('q_$quality');
    if (format != null) transformations.add('f_$format');

    final transformStr = transformations.isNotEmpty
        ? '${transformations.join(',')}/'
        : '';

    return 'https://res.cloudinary.com/$_cloudName/image/upload/$transformStr$publicId';
  }

  /// Get profile image URL with standard transformations
  static String getProfileImageUrl(String publicId) {
    return getOptimizedUrl(
      publicId,
      width: 200,
      height: 200,
      crop: 'fill',
      gravity: 'face',
      quality: 80,
      format: 'webp',
    );
  }
}

class CloudinaryResponse {
  final String publicId;
  final String secureUrl;
  final String url;
  final int width;
  final int height;
  final String format;
  final int bytes;

  CloudinaryResponse({
    required this.publicId,
    required this.secureUrl,
    required this.url,
    required this.width,
    required this.height,
    required this.format,
    required this.bytes,
  });

  factory CloudinaryResponse.fromJson(Map<String, dynamic> json) {
    return CloudinaryResponse(
      publicId: json['public_id'] ?? '',
      secureUrl: json['secure_url'] ?? '',
      url: json['url'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      format: json['format'] ?? '',
      bytes: json['bytes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'public_id': publicId,
      'secure_url': secureUrl,
      'url': url,
      'width': width,
      'height': height,
      'format': format,
      'bytes': bytes,
    };
  }
}
