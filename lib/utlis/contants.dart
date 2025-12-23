import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ApiConstants {
  // User API base URL (for auth, profile, user management)
 // static const String userBaseUrl = 'http://10.0.2.2:8000/api/user/';
  static const String userBaseUrl = 'http://10.0.2.2:8000/api/user/';

  // Jobs API base URL
  static const String jobsBaseUrl = 'http://10.0.2.2:8000/api/v1/jobs/';

  // Tasks API base URL (if you have one)
  // static const String tasksBaseUrl = 'http://10.0.2.2:8000/api/tasks/';

  // Auth endpoints
  static const String registerEndpoint = 'registration/';
  static const String loginEndpoint = 'login/';
  static const String refreshTokenEndpoint = 'token/refresh/';
  static const String profileEndpoint = 'profile/';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

class SharedPrefsKeys {
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String currentUser = 'current_user'; // For UserService
}

class UserRole {
  static const String seeker = 'seeker';
  static const String provider = 'provider';

  static List<String> get all => [seeker, provider];

  static String getDisplayName(String role) {
    switch (role) {
      case seeker:
        return 'Service Seeker';
      case provider:
        return 'Service Provider';
      default:
        return 'User';
    }
  }

  static Color getColor(String role, BuildContext context) {
    switch (role) {
      case seeker:
        return AppColors.primaryBlue;
      case provider:
        return AppColors.primaryGreen;
      default:
        return Theme.of(context).primaryColor;
    }
  }
}