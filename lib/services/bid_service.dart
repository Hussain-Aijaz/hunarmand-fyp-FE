import 'dart:convert';
import '../models/bid_model.dart';
import 'api_service.dart';

class BidService {
  static final BidService _instance = BidService._internal();
  factory BidService() => _instance;
  BidService._internal();

  final ApiService _apiService = ApiService(
    baseUrl: 'http://10.0.2.2:8000/api/v1/bids/',
  );

  // Create a new bid
  Future<CreateBidResponse> createBid({
    required double amount,
    required String status,
    required int jobId,
    required int bidderId,
  }) async {
    print('💼 Creating bid...');
    print('   - Amount: $amount');
    print('   - Status: $status');
    print('   - Job ID: $jobId');
    print('   - Bidder ID: $bidderId');

    try {
      final request = CreateBidRequest(
        amount: amount,
        status: status,
        job: jobId,
        bidder: bidderId,
      );

      final response = await _apiService.post(
        endpoint: '?bids_list=create',
        body: request.toJson(),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 201) {
        print('✅ Bid created successfully (201 Created)');
        print('📦 Response: ${response.body}');

        return CreateBidResponse.fromJson(responseData);
      }
      else if (response.statusCode == 200) {
        print('✅ Bid created successfully (200 OK)');
        return CreateBidResponse.fromJson(responseData);
      }
      else if (response.statusCode == 400) {
        print('❌ Validation error: ${response.body}');
        return CreateBidResponse(errors: responseData['errors']);
      }
      else {
        print('❌ Failed to create bid: ${response.statusCode}');
        throw Exception('Failed to create bid: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error creating bid: $e');
      rethrow;
    }
  }

  // Get all bids for the current user (NEW METHOD)
  Future<List<Bid>> getAllBids() async {
    try {
      print('📋 Fetching all bids for current user...');

      final response = await _apiService.get(
        endpoint: '?jobs_list=list', // Note: endpoint name as per your requirement
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print('✅ Fetched ${responseData.length} bids');
        return responseData.map((json) => Bid.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch bids: ${response.statusCode}');
        throw Exception('Failed to fetch bids: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching bids: $e');
      rethrow;
    }
  }

  // Get bids for a specific job
  Future<List<Bid>> getBidsForJob(int jobId) async {
    try {
      print('📋 Fetching bids for job $jobId...');

      final response = await _apiService.get(
        endpoint: '?job=$jobId',
      );

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        print('✅ Fetched ${responseData.length} bids for job $jobId');
        return responseData.map((json) => Bid.fromJson(json)).toList();
      } else {
        print('❌ Failed to fetch bids: ${response.statusCode}');
        throw Exception('Failed to fetch bids: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error fetching bids: $e');
      rethrow;
    }
  }

  // Get bid by ID
  Future<Bid?> getBidById(int bidId) async {
    try {
      final response = await _apiService.get(
        endpoint: '$bidId/',
      );

      if (response.statusCode == 200) {
        return Bid.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 404) {
        return null;
      } else {
        throw Exception('Failed to fetch bid: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bid: $e');
      rethrow;
    }
  }
}