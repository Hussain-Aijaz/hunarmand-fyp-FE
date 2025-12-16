import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utlis/app_router.dart';
import '../utlis/contants.dart';
import 'error_handler_service.dart';
import 'shared_prefs_service.dart';

class ApiService {
  final String baseUrl;
  final SharedPrefsService _sharedPrefs = SharedPrefsService();

  ApiService({required this.baseUrl});

  // Auth endpoints that skip 401
  bool _isAuthEndpoint(String endpoint) {
    final authEndpoints = ['login/', 'registration/', 'token/refresh/'];
    return authEndpoints.any((auth) => endpoint.contains(auth));
  }

  Future<http.Response> post({
    required String endpoint,
    required Map<String, dynamic> body,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final isAuth = _isAuthEndpoint(endpoint);
      final headers = await _getHeaders(includeAuth: !isAuth);

      print('🌐 POST: $url');
      print('🔐 Auth: ${!isAuth}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      ).timeout(ApiConstants.receiveTimeout);

      // Handle 401 only for non-auth endpoints
      if (response.statusCode == 401 && !isAuth) {
        await _handle401(endpoint, response.body);
      }

      return response;
    } catch (e) {
      print('❌ POST Error: $e');
      rethrow;
    }
  }

  Future<http.Response> get({
    required String endpoint,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final isAuth = _isAuthEndpoint(endpoint);
      final headers = await _getHeaders(includeAuth: !isAuth);

      print('🌐 GET: $url');
      print('🔐 Auth: ${!isAuth}');

      final response = await http.get(
        url,
        headers: headers,
      ).timeout(ApiConstants.receiveTimeout);

      // Handle 401 only for non-auth endpoints
      if (response.statusCode == 401 && !isAuth) {
        await _handle401(endpoint, response.body);
      }

      return response;
    } catch (e) {
      print('❌ GET Error: $e');
      rethrow;
    }
  }

  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (includeAuth) {
      final token = await _sharedPrefs.getAccessToken();
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  Future<void> _handle401(String endpoint, String responseBody) async {
    print('🔐 401 on $endpoint - Redirecting to login');

    final errorHandler = ErrorHandlerService();
    final context = AppRouter.context;

    if (context != null && context.mounted) {
      await errorHandler.handleApiError(
        statusCode: 401,
        responseBody: responseBody,
        context: context,
        apiEndpoint: endpoint,
      );
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        AppRouter.navigateToLogin(message: 'Session expired');
      });
    }

    throw Exception('Unauthorized');
  }
}