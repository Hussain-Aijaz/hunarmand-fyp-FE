import 'dart:convert';
import 'package:hunarmand/services/permission_service.dart';

import '../models/auth_model.dart';
import '../utlis/contants.dart';
import 'api_service.dart';
import 'shared_prefs_service.dart';
import 'location_service.dart'; // Add this import

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final ApiService _userApiService = ApiService(
    baseUrl: ApiConstants.userBaseUrl,
  );

  final SharedPrefsService _sharedPrefs = SharedPrefsService();
  final LocationService _locationService = LocationService();
  final PermissionService _permissionService = PermissionService();

  UserData? _currentUser;

  UserData? get currentUser => _currentUser;

  // ✅ LOGIN with location
  Future<LoginResponse> login(LoginRequest request) async {
    print('🔑 Starting login...');

    try {
      // Get location before login
      Map<String, double>? location;
      // Check if location permission is granted
      final hasLocationPermission = await _permissionService.isLocationPermissionGranted();

      if (hasLocationPermission) {
        print('📍 Location permission granted, fetching location...');

        try {
          // Try to get current location
          location = await _locationService.getCurrentLocation();

          // If can't get current location, try last known
          if (location == null) {
            print('⚠️ Could not get current location, trying last known...');
            location = await _locationService.getLastKnownLocation();
          }

          // If still no location, try approximate location
          if (location == null) {
            print('⚠️ Could not get last known location, trying approximate...');
            location = await _locationService.getApproximateLocation();
          }
        } catch (e) {
          print('⚠️ Location fetch failed: $e');
          // Continue login without location
        }
      } else {
        print('📍 Location permission not granted, skipping location fetch');
      }
      // Create login request with location
      final loginBody = request.toJson();

      // Add location to request if available
      if (location != null) {
        loginBody['latitude'] = location['latitude']?.toString() ?? '';
        loginBody['longitude'] = location['longitude']?.toString() ?? '';
        print('📍 Sending location with login:');
        print('   - Latitude: ${location['latitude']}');
        print('   - Longitude: ${location['longitude']}');
      } else {
        print('📍 No location available for login');
      }

      print('📤 Sending login request...');
      final response = await _userApiService.post(
        endpoint: 'login/',
        body: loginBody,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(responseData);

        if (loginResponse.token != null) {
          await _sharedPrefs.saveTokens(
            loginResponse.token!.access,
            loginResponse.token!.refresh,
          );

          // After login, fetch user profile
          await getUserProfile();

          // Save location if available
          if (location != null) {
            await _saveLocation(location);
          }
        }

        return loginResponse;
      } else if (response.statusCode == 400 || response.statusCode == 401) {
        return LoginResponse(errors: responseData['errors'] ?? {'error': ['Invalid credentials']});
      } else {
        throw Exception('Login failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Login error: $e');
      rethrow;
    }
  }

  // ✅ REGISTRATION (also update if needed)
  Future<RegisterResponse> register(RegisterRequest request) async {
    print('🚀 Starting registration...');

    try {
      // Get location for registration if needed
      Map<String, double>? location;
      try {
        location = await _locationService.getCurrentLocation();
      } catch (e) {
        print('⚠️ Location fetch for registration failed: $e');
      }

      final registerBody = request.toJson();

      // Add location to registration if available
      if (location != null) {
        registerBody['latitude'] = location['latitude']?.toString() ?? '';
        registerBody['longitude'] = location['longitude']?.toString() ?? '';
      }

      final response = await _userApiService.post(
        endpoint: ApiConstants.registerEndpoint,
        body: registerBody,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final registerResponse = RegisterResponse.fromJson(responseData);

        if (registerResponse.token != null) {
          await _sharedPrefs.saveTokens(
            registerResponse.token!.access,
            registerResponse.token!.refresh,
          );

          await getUserProfile();

          // Save location if available
          if (location != null) {
            await _saveLocation(location);
          }
        }

        return registerResponse;
      } else if (response.statusCode == 400) {
        return RegisterResponse(errors: responseData['errors']);
      } else {
        throw Exception('Registration failed with status: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Registration error: $e');
      rethrow;
    }
  }

  // Save location to SharedPreferences
  Future<void> _saveLocation(Map<String, double> location) async {
    try {
      await _sharedPrefs.saveLocation(
        location['latitude']!,
        location['longitude']!,
      );
      print('📍 Location saved to SharedPreferences');
    } catch (e) {
      print('⚠️ Error saving location: $e');
    }
  }

  // Get saved location
  Future<Map<String, double>?> getSavedLocation() async {
    try {
      final lat = await _sharedPrefs.getLatitude();
      final lng = await _sharedPrefs.getLongitude();

      if (lat != null && lng != null) {
        return {
          'latitude': lat,
          'longitude': lng,
        };
      }
      return null;
    } catch (e) {
      print('⚠️ Error getting saved location: $e');
      return null;
    }
  }

  // Rest of your methods stay the same...



  // Future<UserData> getUserProfile() async {
  //   print('👤 Fetching user profile...');
  //
  //   try {
  //     final response = await _userApiService.get(
  //       endpoint: 'profile/',
  //     );
  //
  //     if (response.statusCode == 200) {
  //       final responseData = jsonDecode(response.body);
  //       final userData = UserData.fromJson(responseData);
  //       _currentUser = userData;
  //
  //       await _sharedPrefs.saveUserData(
  //         userData.email,
  //         userData.name,
  //       );
  //
  //       print('✅ User profile loaded: ${userData.name}');
  //       return userData;
  //     } else {
  //       throw Exception('Failed to fetch profile: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('💥 Profile fetch error: $e');
  //     rethrow;
  //   }
  // }

  Future<UserData> getUserProfile() async {
    print('👤 Fetching user profile...');

    try {
      final response = await _userApiService.get(
        endpoint: 'profile/',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final userData = UserData.fromJson(responseData);
        _currentUser = userData;

        await _sharedPrefs.saveUserData(
          userData.email,
          userData.name,
          // You might want to add more fields to save
        );

        print('✅ User profile loaded: ${userData.name}');
        print('📊 Additional data:');
        print('   - Role: ${userData.role}');
        print('   - Total Jobs: ${userData.totalJobs}');
        print('   - Bid Success Rate: ${userData.bidSuccessRate.toStringAsFixed(2)}%');

        return userData;
      } else {
        throw Exception('Failed to fetch profile: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Profile fetch error: $e');
      rethrow;
    }
  }


  Future<bool> isLoggedIn() async {
    final token = await _sharedPrefs.getAccessToken();
    return token != null && token.isNotEmpty;
  }

  Future<void> loadUserProfile() async {
    try {
      if (await isLoggedIn()) {
        print('👤 Loading user profile from saved token...');
        _currentUser = await getUserProfile();
        print('✅ User profile loaded from API');
      }
    } catch (e) {
      print('⚠️ Could not load user profile: $e');
      _currentUser = null;
    }
  }

  Future<void> logout() async {
    print('🚪 Logging out...');
    await _sharedPrefs.clearAllData();
    _currentUser = null;
    print('✅ User logged out and local data cleared');
  }
}