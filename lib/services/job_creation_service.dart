// job_creation_service.dart
import 'dart:convert';
import 'api_service.dart';

class JobCreationService {
  static final JobCreationService _instance = JobCreationService._internal();
  factory JobCreationService() => _instance;
  JobCreationService._internal();

  final ApiService _apiService = ApiService(
    baseUrl: 'http://10.0.2.2:8000/api/v1/', // Adjust base URL as needed
  );

  Future<Map<String, dynamic>> createJob({
    required String taskId,
    required String category,
    required String subject,
    required String description,
    required String priority,
  }) async {
    try {
      print('💼 Creating job...');
      print('   - Task ID: $taskId');
      print('   - Category: $category');
      print('   - Subject: $subject');
      print('   - Priority: $priority');

      final requestBody = {
        'task_id': taskId,
        'category': category,
        'subject': subject,
        'description': description,
        'status': 'None',
        'assigned_to': '',
        'priority': priority,
      };

      print('📤 Request body: $requestBody');

      final response = await _apiService.post(
        endpoint: 'jobs/?jobs_list=create',
        body: requestBody,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Job created successfully!');
        print('📦 Response: ${response.body}');
        return responseData;
      } else if (response.statusCode == 400) {
        print('❌ Validation error: ${response.body}');
        throw Exception('Validation error: ${response.body}');
      } else {
        print('❌ Failed to create job: ${response.statusCode}');
        throw Exception('Failed to create job: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error creating job: $e');
      rethrow;
    }
  }
}