// meta_service.dart
import 'dart:convert';
import 'package:hunarmand/utlis/contants.dart';

import 'api_service.dart';

class MetaService {
  static final MetaService _instance = MetaService._internal();
  factory MetaService() => _instance;
  MetaService._internal();

  final ApiService _apiService = ApiService(
    baseUrl: ApiConstants.generalBaseUrl, // Adjust base URL as needed
  );

  Future<Map<String, dynamic>> getEnums() async {
    try {
      print('📋 Fetching enums from API...');

      final response = await _apiService.get(
        endpoint: 'meta/enums/',
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('✅ Enums fetched successfully');
        return responseData;
      } else {
        print('❌ Failed to fetch enums: ${response.statusCode}');
        throw Exception('Failed to fetch enums: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching enums: $e');
      rethrow;
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final enums = await getEnums();
      final categories = enums['category'] as List<dynamic>?;

      if (categories != null) {
        // Filter out "None" if present
        return categories.cast<String>().where((cat) => cat != 'None').toList();
      }

      return [];
    } catch (e) {
      print('Error getting categories: $e');
      return [];
    }
  }

  Future<List<String>> getPriorities() async {
    try {
      final enums = await getEnums();
      final priorities = enums['priority'] as List<dynamic>?;

      if (priorities != null) {
        // Filter out "None" if present
        return priorities.cast<String>().where((priority) => priority != 'None').toList();
      }

      return [];
    } catch (e) {
      print('Error getting priorities: $e');
      return [];
    }
  }
}