import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static final PermissionService _instance = PermissionService._internal();
  factory PermissionService() => _instance;
  PermissionService._internal();

  // Request all necessary permissions on app launch
  Future<void> requestPermissionsOnLaunch() async {
    print('🔐 Requesting permissions on app launch...');

    try {
      // Request location permission
      final locationStatus = await Permission.location.status;

      if (locationStatus.isDenied || locationStatus.isRestricted) {
        print('📍 Requesting location permission...');
        final locationResult = await Permission.location.request();
        print('📍 Location permission result: ${locationResult.name}');
      } else {
        print('📍 Location permission already granted: ${locationStatus.name}');
      }

      // You can add other permissions here if needed
      // Example: Storage, camera, etc.
      // final storageStatus = await Permission.storage.status;
      // if (storageStatus.isDenied) {
      //   await Permission.storage.request();
      // }

    } catch (e) {
      print('❌ Error requesting permissions: $e');
    }
  }

  // Check if location permission is granted
  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  // Check if location services are enabled
  Future<bool> areLocationServicesEnabled() async {
    try {
      // Note: geolocator package is needed for this check
      // We'll handle this in LocationService
      return true;
    } catch (e) {
      print('⚠️ Error checking location services: $e');
      return false;
    }
  }

  // Open app settings for manual permission enabling
  Future<void> openAppSettingsForPermissions() async {
    await openAppSettings();
  }

  // Check all permissions status
  Future<Map<String, PermissionStatus>> checkAllPermissions() async {
    return {
      'location': await Permission.location.status,
      // Add other permissions here
      // 'storage': await Permission.storage.status,
      // 'camera': await Permission.camera.status,
    };
  }
}