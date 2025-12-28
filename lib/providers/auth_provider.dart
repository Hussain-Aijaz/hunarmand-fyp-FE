
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import '../models/auth_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  RegisterResponse? _registerResponse;
  LoginResponse? _loginResponse;
  bool _isLoggedIn = false;
  UserData? _currentUser;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  RegisterResponse? get registerResponse => _registerResponse;
  LoginResponse? get loginResponse => _loginResponse;
  bool get isLoggedIn => _isLoggedIn;
  UserData? get currentUser => _currentUser;

  // ADD THESE GETTERS:
  bool get isProvider => _currentUser?.role == 'provider' || _currentUser?.role == 'Service Provider';
  bool get isSeeker => _currentUser?.role == 'seeker' || _currentUser?.role == 'Service Seeker';

  String get userRoleDisplayName {
    if (_currentUser == null) return 'User';
    final role = _currentUser!.role.toLowerCase();
    if (role.contains('provider')) return 'Service Provider';
    if (role.contains('seeker')) return 'Service Seeker';
    return 'User';
  }

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    try {
      _isLoggedIn = await _authService.isLoggedIn();
      print('🔍 Initial login status: $_isLoggedIn');

      if (_isLoggedIn) {
        // Try to load user profile if logged in
        await _loadUserProfile();
      }
    } catch (e) {
      print('⚠️ Error checking login status: $e');
      _isLoggedIn = false;
    }

    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    print('🔄 Loading state changed: $loading');
    notifyListeners();
  }

  void _setError(String? error) {
    _errorMessage = error;
    if (error != null) {
      print('❌ Error set in AuthProvider: $error');
    }
    notifyListeners();
  }

  Future<void> registerUser({
    required String email,
    required String name,
    required String password,
    required String confirmPassword,
    required String phone,
    required String role,
  }) async {
    print('🎯 AuthProvider.registerUser() called');
    print('📝 Form Data:');
    print('   - Email: $email');
    print('   - Name: $name');
    print('   - Phone: $phone');
    print('   - Role: $role');

    _setLoading(true);
    _setError(null);
    _registerResponse = null; // Clear previous response

    try {
      final request = RegisterRequest(
        email: email,
        name: name,
        password: password,
        password2: confirmPassword,
        phone: phone,
        role: role,
      );

      print('📤 Calling AuthService.register()...');
      final response = await _authService.register(request);
      _registerResponse = response;

      // Check for errors in response
      if (response.errors != null && response.errors!.isNotEmpty) {
        print('⚠️ Server validation errors received');
        _handleRegistrationErrors(response.errors!);
      } else {
        print('✅ Registration successful!');
        _setError(null);

        // Auto-login after successful registration if token is present
        if (response.token != null) {
          print('🔑 Auto-login after registration');
          _isLoggedIn = true;
          await _loadUserProfile();
        }
      }
    } catch (e, stackTrace) {
      _handleRegistrationError(e, stackTrace);
    } finally {
      print('🏁 AuthProvider.registerUser() completed');
      _setLoading(false);
    }
  }

  void _handleRegistrationErrors(Map<String, dynamic> errors) {
    final errorMessages = <String>[];

    // Extract all error messages
    errors.forEach((key, value) {
      print('   - $key errors: $value');
      if (value is List) {
        errorMessages.addAll(value.cast<String>());
      } else if (value is String) {
        errorMessages.add(value);
      }
    });

    if (errorMessages.isNotEmpty) {
      final combinedError = errorMessages.join('\n');
      print('📦 Combined error message: $combinedError');
      _setError(combinedError);
    } else {
      _setError('Registration failed. Please try again.');
    }
  }

  void _handleRegistrationError(dynamic e, StackTrace stackTrace) {
    print('💥 Exception in AuthProvider.registerUser():');
    print('❌ Error Type: ${e.runtimeType}');
    print('📋 Error Message: $e');
    print('🔍 Full Stack Trace:');
    print(stackTrace);

    // Provide user-friendly error messages
    if (e is SocketException || e.toString().contains('Connection refused')) {
      _setError('Cannot connect to server. Please check your internet connection.');
    } else if (e is TimeoutException) {
      _setError('Connection timeout. Please try again.');
    } else if (e.toString().contains('Unauthorized') ||
        e.toString().contains('token') ||
        e.toString().contains('401')) {
      _setError('Session expired. Please login again.');
    } else {
      _setError('Registration failed: ${e.toString().split('\n').first}');
    }
  }

  // Login method with profile fetching
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    print('🔑 AuthProvider.loginUser() called');
    print('📝 Login Data:');
    print('   - Email: $email');

    _setLoading(true);
    _setError(null);
    _loginResponse = null; // Clear previous response

    try {
      final request = LoginRequest(email: email, password: password);
      print('📤 Calling AuthService.login()...');

      final response = await _authService.login(request);
      _loginResponse = response;

      await _handleLoginResponse(response);
    } catch (e, stackTrace) {
      _handleLoginError(e, stackTrace);
    } finally {
      print('🏁 AuthProvider.loginUser() completed');
      _setLoading(false);
      notifyListeners();
    }
  }

  Future<void> _handleLoginResponse(LoginResponse response) async {
    // Check for errors
    if (response.errors != null && response.errors!.isNotEmpty) {
      _handleLoginValidationErrors(response.errors!);
      return;
    }

    // Check if token is present
    if (response.token == null) {
      _setError('Login failed. No authentication token received.');
      print('⚠️ Login response has no errors but no token either');
      return;
    }

    print('✅ Login successful! Token received');

    // Update login status
    _isLoggedIn = true;

    // Load user profile
    await _loadUserProfile();

    _setError(null);
    print('🎯 Login complete with profile data');
  }

  void _handleLoginValidationErrors(Map<String, dynamic> errors) {
    print('❌ Login failed - Server validation errors');

    final errorMessages = <String>[];

    // Extract error messages from different possible keys
    const errorKeys = ['email', 'password', 'non_field_errors', 'error', 'detail'];

    for (final key in errorKeys) {
      if (errors.containsKey(key)) {
        final error = errors[key];
        if (error is List) {
          errorMessages.addAll(error.cast<String>());
        } else if (error is String) {
          errorMessages.add(error);
        }
        print('   - $key errors: $error');
      }
    }

    if (errorMessages.isNotEmpty) {
      final combinedError = errorMessages.join('\n');
      _setError(combinedError);
      print('📦 Combined error message: $combinedError');
    } else {
      _setError('Invalid email or password');
    }
  }

  // Future<void> _loadUserProfile() async {
  //   print('👤 Loading user profile...');
  //
  //   try {
  //     _currentUser = await _authService.getUserProfile();
  //     print('✅ User profile loaded successfully!');
  //
  //     if (_currentUser != null) {
  //       print('📊 User Data:');
  //       print('   - Name: ${_currentUser!.name}');
  //       print('   - Email: ${_currentUser!.email}');
  //       print('   - ID: ${_currentUser!.id}');
  //       print('   - Phone: ${_currentUser!.phone ?? "N/A"}');
  //       print('   - Role: ${_currentUser!.role ?? "N/A"}');
  //     } else {
  //       print('⚠️ User profile loaded but is null');
  //     }
  //   } catch (e) {
  //     print('⚠️ Profile fetch failed: $e');
  //
  //     // Don't logout on profile fetch failure, just keep user logged in without profile
  //     // They can still use basic features
  //     if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
  //       print('🔐 401 during profile fetch - logging out');
  //       await logoutUser();
  //     }
  //   }
  // }

  Future<void> _loadUserProfile() async {
    print('👤 Loading user profile...');

    try {
      _currentUser = await _authService.getUserProfile();
      print('✅ User profile loaded successfully!');

      if (_currentUser != null) {
        print('📊 User Data:');
        print('   - Name: ${_currentUser!.name}');
        print('   - Email: ${_currentUser!.email}');
        print('   - ID: ${_currentUser!.id}');
        print('   - Phone: ${_currentUser!.phone ?? "N/A"}');
        print('   - Role: ${_currentUser!.role}');
        print('   - Location: Lat ${_currentUser!.latitude ?? "N/A"}, Long ${_currentUser!.longitude ?? "N/A"}');
        print('   - Jobs: Started(${_currentUser!.startedJobs}) Waiting(${_currentUser!.waitingJobs}) Ended(${_currentUser!.endedJobs})');
        print('   - Bids: Total(${_currentUser!.totalBids}) Approved(${_currentUser!.approvedBids}) Rejected(${_currentUser!.rejectedBids})');
        print('   - Total Jobs: ${_currentUser!.totalJobs}');
        print('   - Bid Success Rate: ${_currentUser!.bidSuccessRate.toStringAsFixed(2)}%');
      } else {
        print('⚠️ User profile loaded but is null');
      }
    } catch (e) {
      print('⚠️ Profile fetch failed: $e');

      // Don't logout on profile fetch failure, just keep user logged in without profile
      // They can still use basic features
      if (e.toString().contains('401') || e.toString().contains('Unauthorized')) {
        print('🔐 401 during profile fetch - logging out');
        await logoutUser();
      }
    }
  }


  void _handleLoginError(dynamic e, StackTrace stackTrace) {
    print('💥 Exception in AuthProvider.loginUser():');
    print('❌ Error Type: ${e.runtimeType}');
    print('📋 Error Message: $e');
    print('🔍 Full Stack Trace:');
    print(stackTrace);

    // Provide user-friendly error messages
    if (e is SocketException || e.toString().contains('Connection refused')) {
      _setError('Cannot connect to server. Please check your internet connection.');
    } else if (e is TimeoutException) {
      _setError('Connection timeout. Please try again.');
    } else if (e.toString().contains('Invalid credentials') ||
        e.toString().contains('Unauthorized') ||
        e.toString().contains('401')) {
      _setError('Invalid email or password.');
    } else {
      _setError('Login failed: ${e.toString().split('\n').first}');
    }
  }

  // NEW: Method to check if profile is loaded
  bool get isProfileLoaded => _currentUser != null;

  // NEW: Get user info for display
  String get userName => _currentUser?.name ?? 'User';
  String get userEmail => _currentUser?.email ?? '';
  String get userPhone => _currentUser?.phone ?? '';

  // Update logout to clear current user
  Future<void> logoutUser() async {
    print('🚪 AuthProvider.logoutUser() called');

    _setLoading(true);

    try {
      await _authService.logout();

      // Clear all local state
      _isLoggedIn = false;
      _loginResponse = null;
      _registerResponse = null;
      _currentUser = null;
      _errorMessage = null;

      print('✅ User logged out successfully');
    } catch (e) {
      print('❌ Logout error: $e');
      _setError('Logout failed: $e');

      // Still clear local state even if logout API fails
      _isLoggedIn = false;
      _currentUser = null;
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Load user profile on demand
  Future<void> loadUserProfile() async {
    if (_isLoggedIn) {
      await _loadUserProfile();
      notifyListeners();
    }
  }

  void clearError() {
    print('🧹 Clearing error message');
    _setError(null);
  }
}