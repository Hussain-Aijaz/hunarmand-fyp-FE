import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Check if location permission is granted
  Future<bool> _checkLocationPermission() async {
    final status = await Permission.location.status;

    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      print('📍 Location permission denied. Please enable in settings.');
      return false;
    } else if (status.isPermanentlyDenied) {
      print('📍 Location permission permanently denied.');
      return false;
    } else if (status.isRestricted) {
      print('📍 Location permission restricted.');
      return false;
    }

    return false;
  }

  // Get current location (without requesting permission)
  Future<Map<String, double>?> getCurrentLocation() async {
    try {
      print('📍 Getting current location...');

      // Check if permission is granted
      final hasPermission = await _checkLocationPermission();

      if (!hasPermission) {
        print('❌ Location permission not granted');
        return null;
      }

      // Check if location service is enabled
      final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        print('❌ Location services are disabled');

        // Optionally, you can show a dialog to enable location
        // await Geolocator.openLocationSettings();

        return null;
      }

      // Get current position
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
        timeLimit: const Duration(seconds: 10),
      );

      print('📍 Location obtained:');
      print('   - Latitude: ${position.latitude}');
      print('   - Longitude: ${position.longitude}');

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };

    } catch (e, stackTrace) {
      print('❌ Error getting location: $e');
      print('📋 Stack Trace:');
      print(stackTrace);

      return null;
    }
  }

  // Get last known location
  Future<Map<String, double>?> getLastKnownLocation() async {
    try {
      final hasPermission = await _checkLocationPermission();

      if (!hasPermission) {
        return null;
      }

      final Position? position = await Geolocator.getLastKnownPosition();

      if (position != null) {
        print('📍 Using last known location:');
        print('   - Latitude: ${position.latitude}');
        print('   - Longitude: ${position.longitude}');

        return {
          'latitude': position.latitude,
          'longitude': position.longitude,
        };
      }

      return null;
    } catch (e) {
      print('❌ Error getting last known location: $e');
      return null;
    }
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Open location settings
  Future<void> openLocationSettings() async {
    await Geolocator.openLocationSettings();
  }

  // Get approximate location (less accurate but faster)
  Future<Map<String, double>?> getApproximateLocation() async {
    try {
      final hasPermission = await _checkLocationPermission();

      if (!hasPermission) {
        return null;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
        timeLimit: const Duration(seconds: 5),
      );

      return {
        'latitude': position.latitude,
        'longitude': position.longitude,
      };
    } catch (e) {
      print('❌ Error getting approximate location: $e');
      return null;
    }
  }
}