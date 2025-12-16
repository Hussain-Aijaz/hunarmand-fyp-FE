import 'package:shared_preferences/shared_preferences.dart';
import '../utlis/contants.dart';

class SharedPrefsService {
  static SharedPrefsService? _instance;
  static SharedPreferences? _prefs;

  SharedPrefsService._internal();

  factory SharedPrefsService() {
    _instance ??= SharedPrefsService._internal();
    return _instance!;
  }

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Token methods
  Future<String?> getAccessToken() async {
    return _prefs?.getString(SharedPrefsKeys.accessToken);
  }

  Future<String?> getRefreshToken() async {
    return _prefs?.getString(SharedPrefsKeys.refreshToken);
  }

  Future<void> clearTokens() async {
    await _prefs?.remove(SharedPrefsKeys.accessToken);
    await _prefs?.remove(SharedPrefsKeys.refreshToken);
  }

  // User data methods
  Future<void> saveUserData(String email, String name) async {
    await _prefs?.setString(SharedPrefsKeys.userEmail, email);
    await _prefs?.setString(SharedPrefsKeys.userName, name);
  }

  Future<String?> getUserEmail() async {
    return _prefs?.getString(SharedPrefsKeys.userEmail);
  }

  Future<String?> getUserName() async {
    return _prefs?.getString(SharedPrefsKeys.userName);
  }

  // Location methods
  Future<void> saveLocation(double latitude, double longitude) async {
    await _prefs?.setDouble('latitude', latitude);
    await _prefs?.setDouble('longitude', longitude);
  }

  Future<double?> getLatitude() async {
    return _prefs?.getDouble('latitude');
  }

  Future<double?> getLongitude() async {
    return _prefs?.getDouble('longitude');
  }

  Future<void> setLoginStatus(bool isLoggedIn) async {
    await _prefs?.setBool('is_logged_in', isLoggedIn);
  }

  Future<bool> getLoginStatus() async {
    return _prefs?.getBool('is_logged_in') ?? false;
  }

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _prefs?.setString(SharedPrefsKeys.accessToken, accessToken);
    await _prefs?.setString(SharedPrefsKeys.refreshToken, refreshToken);
    await setLoginStatus(true);
  }

  Future<void> clearAllData() async {
    await _prefs?.clear();
  }

  Future<void> clearLocation() async {
    await _prefs?.remove('user_latitude');
    await _prefs?.remove('user_longitude');
  }

}