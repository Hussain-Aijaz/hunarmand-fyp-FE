
import 'dart:convert';
import 'package:hunarmand/utlis/contants.dart';
import 'api_service.dart';

class JobUpdateService {
  static final JobUpdateService _instance = JobUpdateService._internal();
  factory JobUpdateService() => _instance;
  JobUpdateService._internal();

  final ApiService _apiService = ApiService(
    baseUrl: ApiConstants.generalBaseUrl,
  );

  // Update job status (Start/End)
  Future<Map<String, dynamic>> updateJobStatus({
    required int jobId,
    required String status,
    required Map<String, dynamic> body,
  }) async {
    try {
      print('🔄 Updating job status...');
      print('   - Job ID: $jobId');
      print('   - Status: $status');
      print('   - Full body: ${jsonEncode(body)}');

      // Ensure status is correctly set in the body
      final requestBody = Map<String, dynamic>.from(body);
      requestBody['status'] = status;

      // Set started_at or ended_at based on status
      final now = DateTime.now().toIso8601String();
      if (status == 'Started') {
        requestBody['started_at'] = now;
      } else if (status == 'Ended') {
        requestBody['ended_at'] = now;
      }

      print('📤 PUT Request body: $requestBody');
      print('🔗 Endpoint: jobs/$jobId/?jobs_list=update');

      final response = await _apiService.put(
        endpoint: 'jobs/$jobId/?jobs_list=update',
        body: requestBody,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Job status updated successfully to: $status');
        print('📦 Response: ${response.body}');

        return {
          'success': true,
          'message': 'Job $status successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else if (response.statusCode == 400) {
        print('❌ Validation error: ${response.body}');
        return {
          'success': false,
          'message': 'Validation error',
          'errors': responseData,
          'statusCode': response.statusCode,
        };
      } else if (response.statusCode == 404) {
        print('❌ Job not found: ${response.body}');
        return {
          'success': false,
          'message': 'Job not found',
          'statusCode': response.statusCode,
        };
      } else {
        print('❌ Failed to update job: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to update job status',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('💥 Error updating job status: $e');
      return {
        'success': false,
        'message': 'Network error: ${e.toString()}',
      };
    }
  }

  // Update complete job details
  Future<Map<String, dynamic>> updateJob({
    required int jobId,
    required Map<String, dynamic> body,
  }) async {
    try {
      print('🔄 Updating job details...');
      print('   - Job ID: $jobId');
      print('   - Body: ${jsonEncode(body)}');

      final response = await _apiService.put(
        endpoint: 'jobs/$jobId/?jobs_list=update',
        body: body,
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('✅ Job updated successfully!');
        print('📦 Response: ${response.body}');

        return {
          'success': true,
          'message': 'Job updated successfully',
          'data': responseData,
          'statusCode': response.statusCode,
        };
      } else {
        print('❌ Failed to update job: ${response.statusCode}');
        return {
          'success': false,
          'message': 'Failed to update job',
          'errors': responseData,
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('💥 Error updating job: $e');
      return {
        'success': false,
        'message': 'Error: $e',
      };
    }
  }
}