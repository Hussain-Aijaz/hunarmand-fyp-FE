import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../utlis/app_router.dart';
import 'shared_prefs_service.dart';

class ErrorHandlerService {
  static final ErrorHandlerService _instance = ErrorHandlerService._internal();

  factory ErrorHandlerService() {
    return _instance;
  }

  ErrorHandlerService._internal();

  // Handle API errors
  Future<void> handleApiError({
    required int statusCode,
    required String responseBody,
    required BuildContext context,
    required String apiEndpoint,
  }) async {
    print('🚨 API Error Handler Triggered');
    print('   - Status Code: $statusCode');
    print('   - Endpoint: $apiEndpoint');
    print('   - Response: $responseBody');

    // Handle 401 Unauthorized
    if (statusCode == 401) {
      await _handleUnauthorizedError(context, responseBody);
    }

    // Handle 403 Forbidden
    else if (statusCode == 403) {
      await _handleForbiddenError(context);
    }
  }

  // Handle 401 Unauthorized
  Future<void> _handleUnauthorizedError(BuildContext context, String responseBody) async {
    print('🔐 401 Unauthorized - Token invalid/expired');

    try {
      // Check if it's a token error
      if (responseBody.contains('token_not_valid') ||
          responseBody.contains('Token is expired') ||
          responseBody.contains('Given token not valid')) {

        await _logoutAndRedirect(context, 'Session expired. Please login again.');
      }
    } catch (e) {
      print('⚠️ Error in unauthorized handler: $e');
      await _logoutAndRedirect(context, 'Authentication failed. Please login again.');
    }
  }

  // Handle 403 Forbidden
  Future<void> _handleForbiddenError(BuildContext context) async {
    print('🚫 403 Forbidden - Access denied');
    await _logoutAndRedirect(context, 'Access denied. Please login again.');
  }

  // Common logout and redirect method
  // Future<void> _logoutAndRedirect(BuildContext context, String message) async {
  //   print('🚪 Logging out due to authentication error...');
  //
  //   try {
  //     // Get auth provider
  //     final authProvider = Provider.of<AuthProvider>(context, listen: false);
  //
  //     // Clear local data
  //     await SharedPrefsService().clearAllData();
  //
  //     // Clear auth provider state
  //     await authProvider.logoutUser();
  //
  //     print('✅ Logged out successfully');
  //
  //     // Navigate to login screen
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _navigateToLogin(context, message);
  //     });
  //
  //   } catch (e) {
  //     print('❌ Error during logout: $e');
  //     // Still try to navigate to login
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       _navigateToLogin(context, 'Session expired. Please login again.');
  //     });
  //   }
  // }

  Future<void> _logoutAndRedirect(BuildContext context, String message) async {
    print('🚪 Logging out due to authentication error...');

    try {
      // Check if context is still valid
      if (context.mounted) {
        try {
          // Try to get auth provider if context is available
          final authProvider = Provider.of<AuthProvider>(context, listen: false);
          await authProvider.logoutUser();
        } catch (e) {
          print('⚠️ Could not get auth provider: $e');
          // Fallback: Clear SharedPreferences directly
          await SharedPrefsService().clearAllData();
        }
      } else {
        // If context is not mounted, just clear SharedPreferences
        await SharedPrefsService().clearAllData();
      }

      print('✅ Logged out successfully');

      // Navigate to login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRouter.navigateToLogin(message: message);
      });

    } catch (e) {
      print('❌ Error during logout: $e');
      // Still try to navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRouter.navigateToLogin(message: 'Session expired. Please login again.');
      });
    }
  }

  void _navigateToLogin(BuildContext context, String message) {
    // Clear navigation stack and go to login
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
          (route) => false,
      arguments: {'message': message},
    );
  }

  // Check if error is authentication related
  bool isAuthenticationError(int statusCode, String responseBody) {
    return statusCode == 401 ||
        statusCode == 403 ||
        responseBody.contains('token_not_valid') ||
        responseBody.contains('Token is expired') ||
        responseBody.contains('authentication') ||
        responseBody.contains('Authentication');
  }
}