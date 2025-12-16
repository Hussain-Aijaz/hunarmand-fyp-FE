

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  User? _currentUser;

  User? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;
  bool get isSeeker => _currentUser?.isSeeker ?? false;
  bool get isProvider => _currentUser?.isProvider ?? false;

  // Set user after login
  Future<void> setUser(User user) async {
    _currentUser = user;
    await _saveUserToPrefs(user);
  }

  // Clear user on logout
  Future<void> clearUser() async {
    _currentUser = null;
    await _clearUserFromPrefs();
  }

  // Load user from preferences
  Future<void> loadUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('current_user');

    if (userData != null) {
      try {
        final Map<String, dynamic> userMap = Map<String, dynamic>.from(json.decode(userData));
        _currentUser = User.fromMap(userMap);
      } catch (e) {
        print('Error loading user from prefs: $e');
        await _clearUserFromPrefs();
      }
    }
  }

  // Save user to preferences
  Future<void> _saveUserToPrefs(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toMap());
    await prefs.setString('current_user', userData);
  }

  // Clear user from preferences
  Future<void> _clearUserFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('current_user');
  }
}