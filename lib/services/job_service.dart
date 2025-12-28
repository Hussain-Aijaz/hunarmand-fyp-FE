import 'dart:convert';
import '../models/job_model.dart';
import '../utlis/contants.dart';
import 'api_service.dart';

class JobService {
  static final JobService _instance = JobService._internal();
  factory JobService() => _instance;
  JobService._internal();

  final ApiService _jobsApiService = ApiService(baseUrl: ApiConstants.generalBaseUrl + ApiConstants.jobsEndpoint);

  Future<List<Job>> getJobsList() async {
    try {
      final response = await _jobsApiService.get(
        endpoint: '?jobs_list=list',
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);

        if (responseData.isEmpty) {
          return [];
        }

        final List<Job> jobs = responseData.map((json) => Job.fromJson(json)).toList();
        print('✅ Fetched ${jobs.length} jobs');
        return jobs;
      } else if (response.statusCode == 404) {
        throw Exception('Jobs endpoint not found');
      } else {
        throw Exception('Failed to fetch jobs: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error in getJobsList: $e');
      rethrow;
    }
  }

  Future<Job?> getJobById(int id) async {
    try {
      final response = await _jobsApiService.get(
        endpoint: '$id/',
      );

      if (response.statusCode == 200) {
        return Job.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch job: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching job by id: $e');
      rethrow;
    }
  }
}