import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:landing/config/app_config.dart';

class ApiService {
  static const String _baseUrl = AppConfig.apiUrl;

  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  /// Fetch landing page statistics from the backend
  Future<LandingStats> getLandingStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/contact/stats'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return LandingStats.fromJson(data['data']);
        }
      }
      return LandingStats.fallback();
    } catch (e) {
      return LandingStats.fallback();
    }
  }

  /// Fetch landing page content (video + images) from the backend
  Future<LandingContent> getLandingContent() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/webpage/landing'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return LandingContent.fromJson(data['data']);
        }
      }
      return LandingContent.empty();
    } catch (e) {
      return LandingContent.empty();
    }
  }

  /// Fetch public settings (contact info, social links, store URLs)
  Future<LandingSettings> getPublicSettings() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/contact/settings'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          return LandingSettings.fromJson(data['data']);
        }
      }
      return LandingSettings.fallback();
    } catch (e) {
      return LandingSettings.fallback();
    }
  }

  /// Submit a contact form message
  Future<ContactResponse> submitContact({
    required String email,
    required String message,
    String? name,
    String? subject,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/contact'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'message': message,
          if (name != null && name.isNotEmpty) 'name': name,
          if (subject != null && subject.isNotEmpty) 'subject': subject,
          if (phone != null && phone.isNotEmpty) 'phone': phone,
        }),
      ).timeout(const Duration(seconds: 15));

      final data = json.decode(response.body);

      if (response.statusCode == 201 && data['success'] == true) {
        return ContactResponse(
          success: true,
          message: data['message'] ?? 'Message sent successfully!',
        );
      } else {
        return ContactResponse(
          success: false,
          message: data['message'] ?? 'Failed to send message',
        );
      }
    } catch (e) {
      return ContactResponse(
        success: false,
        message: 'Network error. Please try again.',
      );
    }
  }
}

class LandingStats {
  final int studentsCount;
  final int coursesCount;
  final double averageRating;

  LandingStats({
    required this.studentsCount,
    required this.coursesCount,
    required this.averageRating,
  });

  factory LandingStats.fromJson(Map<String, dynamic> json) {
    return LandingStats(
      studentsCount: json['studentsCount'] ?? 0,
      coursesCount: json['coursesCount'] ?? 0,
      averageRating: (json['averageRating'] ?? 0.0).toDouble(),
    );
  }

  factory LandingStats.fallback() {
    return LandingStats(
      studentsCount: 20321,
      coursesCount: 12,
      averageRating: 4.1,
    );
  }
}

class ContactResponse {
  final bool success;
  final String message;

  ContactResponse({
    required this.success,
    required this.message,
  });
}

class WebPageContentItem {
  final String key;
  final String value;
  final String? valueAr;
  final String? signedUrl;

  WebPageContentItem({
    required this.key,
    required this.value,
    this.valueAr,
    this.signedUrl,
  });

  factory WebPageContentItem.fromJson(Map<String, dynamic> json) {
    return WebPageContentItem(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      valueAr: json['valueAr'],
      signedUrl: json['signedUrl'],
    );
  }

  /// Get the URL to use (prefer signedUrl for S3 content)
  String get url => signedUrl ?? value;
}

class LandingContent {
  final WebPageContentItem? video;
  final List<WebPageContentItem> images;
  final List<WebPageContentItem> texts;

  LandingContent({
    this.video,
    required this.images,
    required this.texts,
  });

  factory LandingContent.fromJson(Map<String, dynamic> json) {
    return LandingContent(
      video: json['video'] != null
          ? WebPageContentItem.fromJson(json['video'])
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => WebPageContentItem.fromJson(e))
              .toList() ??
          [],
      texts: (json['texts'] as List<dynamic>?)
              ?.map((e) => WebPageContentItem.fromJson(e))
              .toList() ??
          [],
    );
  }

  factory LandingContent.empty() {
    return LandingContent(
      video: null,
      images: [],
      texts: [],
    );
  }

  bool get hasVideo => video != null && video!.url.isNotEmpty;
  bool get hasImages => images.isNotEmpty;
}

class LandingSettings {
  final String contactEmail;
  final String contactPhone;
  final String facebookUrl;
  final String instagramUrl;
  final String playStoreUrl;
  final String appStoreUrl;

  LandingSettings({
    required this.contactEmail,
    required this.contactPhone,
    required this.facebookUrl,
    required this.instagramUrl,
    required this.playStoreUrl,
    required this.appStoreUrl,
  });

  factory LandingSettings.fromJson(Map<String, dynamic> json) {
    final fallback = LandingSettings.fallback();
    return LandingSettings(
      contactEmail: json['contactEmail'] ?? fallback.contactEmail,
      contactPhone: json['contactPhone'] ?? fallback.contactPhone,
      facebookUrl: json['facebookUrl'] ?? fallback.facebookUrl,
      instagramUrl: json['instagramUrl'] ?? fallback.instagramUrl,
      playStoreUrl: json['playStoreUrl'] ?? fallback.playStoreUrl,
      appStoreUrl: json['appStoreUrl'] ?? fallback.appStoreUrl,
    );
  }

  factory LandingSettings.fallback() {
    return LandingSettings(
      contactEmail: 'trabuild@gmail.com',
      contactPhone: '+9647709474167',
      facebookUrl: 'https://facebook.com/trabuild',
      instagramUrl: 'https://instagram.com/trabuild',
      playStoreUrl: 'https://play.google.com/store',
      appStoreUrl: 'https://apps.apple.com',
    );
  }
}
