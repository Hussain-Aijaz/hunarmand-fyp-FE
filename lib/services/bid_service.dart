//
// import 'dart:convert';
// import 'package:hunarmand/utlis/contants.dart';
//
// import '../models/bid_model.dart';
// import 'api_service.dart';
//
// class BidService {
//   static final BidService _instance = BidService._internal();
//   factory BidService() => _instance;
//   BidService._internal();
//
//   final ApiService _apiService = ApiService(
//     //baseUrl: 'http://10.0.2.2:8000/api/v1/bids/',
//     baseUrl: ApiConstants.generalBaseUrl + 'bids/',
//     //http://192.168.1.15:8000
//   );
//
//   // Create a new bid
//   Future<CreateBidResponse> createBid({
//     required double amount,
//     required String status,
//     required int jobId,
//     required int bidderId,
//   }) async {
//     print('💼 Creating bid...');
//     print('   - Amount: $amount');
//     print('   - Status: $status');
//     print('   - Job ID: $jobId');
//     print('   - Bidder ID: $bidderId');
//
//     try {
//       final request = CreateBidRequest(
//         amount: amount,
//         status: status,
//         job: jobId,
//         bidder: bidderId,
//       );
//
//       final response = await _apiService.post(
//         endpoint: '?bids_list=create',
//         body: request.toJson(),
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 201) {
//         print('✅ Bid created successfully (201 Created)');
//         print('📦 Response: ${response.body}');
//
//         return CreateBidResponse.fromJson(responseData);
//       }
//       else if (response.statusCode == 200) {
//         print('✅ Bid created successfully (200 OK)');
//         return CreateBidResponse.fromJson(responseData);
//       }
//       else if (response.statusCode == 400) {
//         print('❌ Validation error: ${response.body}');
//         return CreateBidResponse(errors: responseData['errors']);
//       }
//       else {
//         print('❌ Failed to create bid: ${response.statusCode}');
//         throw Exception('Failed to create bid: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('💥 Error creating bid: $e');
//       rethrow;
//     }
//   }
//
//   // Update an existing bid
//   Future<CreateBidResponse> updateBid({
//     required int bidId,
//     required double amount,
//     required String status,
//     int? jobId,
//     int? bidderId,
//   }) async {
//     print('💼 Updating bid $bidId...');
//     print('   - Amount: $amount');
//     print('   - Status: $status');
//     if (jobId != null) print('   - Job ID: $jobId');
//     if (bidderId != null) print('   - Bidder ID: $bidderId');
//
//     try {
//       // Prepare the request body - CORRECTED: Don't use jsonEncode here
//       final Map<String, dynamic> requestBody = {
//         'amount': amount.toString(),
//         'status': status,
//       };
//
//       // Only include job and bidder if provided
//       if (jobId != null) {
//         requestBody['job'] = jobId.toString();
//       }
//       if (bidderId != null) {
//         requestBody['bidder'] = bidderId.toString();
//       }
//
//       print('📤 Request body: $requestBody');
//
//       // CORRECTED: Pass the Map directly, not jsonEncode
//       final response = await _apiService.put(
//         endpoint: '$bidId/?bids_detail=update&job=$jobId',
//         body: requestBody, // Direct Map, not jsonEncode
//       );
//
//       final responseData = jsonDecode(response.body);
//
//       if (response.statusCode == 200 || response.statusCode == 204) {
//         print('✅ Bid updated successfully (200 OK)');
//         print('📦 Response: ${response.body}');
//         return CreateBidResponse.fromJson(responseData);
//       }
//       else if (response.statusCode == 400) {
//         print('❌ Validation error: ${response.body}');
//         return CreateBidResponse(errors: responseData['errors']);
//       }
//       else {
//         print('❌ Failed to update bid: ${response.statusCode}');
//         print('📦 Response: ${response.body}');
//         throw Exception('Failed to update bid: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('💥 Error updating bid: $e');
//       rethrow;
//     }
//   }
//
//   // Alternative update method with full bid data
//   Future<CreateBidResponse> updateBidWithBidObject({
//     required Bid bid,
//     required double amount,
//     required String status,
//   }) async {
//     return updateBid(
//       bidId: bid.id,
//       amount: amount,
//       status: status,
//       jobId: _parseId(bid.job),
//       bidderId: _parseId(bid.bidder),
//     );
//   }
//
//   // Helper method to parse ID from dynamic value
//   int? _parseId(dynamic id) {
//     if (id == null) return null;
//     if (id is int) return id;
//     if (id is String) return int.tryParse(id);
//     return null;
//   }
//
//   // Get all bids for the current user (NEW METHOD)
//   Future<List<Bid>> getAllBids(int jobId) async {
//     try {
//       print('📋 Fetching all bids for current user...');
//
//       final response = await _apiService.get(
//         endpoint: '?jobs_list=list&job=$jobId', // Note: endpoint name as per your requirement
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(response.body);
//         print('✅ Fetched ${responseData.length} bids');
//         return responseData.map((json) => Bid.fromJson(json)).toList();
//       } else {
//         print('❌ Failed to fetch bids: ${response.statusCode}');
//         throw Exception('Failed to fetch bids: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('💥 Error fetching bids: $e');
//       rethrow;
//     }
//   }
//
//   // Get bids for a specific job
//   Future<List<Bid>> getBidsForJob(int jobId) async {
//     try {
//       print('📋 Fetching bids for job $jobId...');
//
//       final response = await _apiService.get(
//         endpoint: '?job=$jobId',
//       );
//
//       if (response.statusCode == 200) {
//         final List<dynamic> responseData = jsonDecode(response.body);
//         print('✅ Fetched ${responseData.length} bids for job $jobId');
//         return responseData.map((json) => Bid.fromJson(json)).toList();
//       } else {
//         print('❌ Failed to fetch bids: ${response.statusCode}');
//         throw Exception('Failed to fetch bids: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('💥 Error fetching bids: $e');
//       rethrow;
//     }
//   }
//
//   // Get bid by ID
//   Future<Bid?> getBidById(int bidId) async {
//     try {
//       final response = await _apiService.get(
//         endpoint: '$bidId/',
//       );
//
//       if (response.statusCode == 200) {
//         return Bid.fromJson(jsonDecode(response.body));
//       } else if (response.statusCode == 404) {
//         return null;
//       } else {
//         throw Exception('Failed to fetch bid: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching bid: $e');
//       rethrow;
//     }
//   }
//
//   // Update your BidService class with these methods:
//
// // Accept a bid
//   Future<CreateBidResponse> acceptBid({
//     required int bidId,
//     required double amount,
//     required int jobId,
//     required int bidderId,
//   }) async {
//     print('✅ Accepting bid $bidId...');
//     print('   - Amount: $amount');
//     print('   - Job ID: $jobId');
//     print('   - Bidder ID: $bidderId');
//
//     return updateBid(
//       bidId: bidId,
//       amount: amount,
//       status: 'Approved',
//       jobId: jobId,
//       bidderId: bidderId,
//     );
//   }
//
// // Decline a bid
//   Future<CreateBidResponse> declineBid({
//     required int bidId,
//     required double amount,
//     required int jobId,
//     required int bidderId,
//   }) async {
//     print('❌ Declining bid $bidId...');
//     print('   - Amount: $amount');
//     print('   - Job ID: $jobId');
//     print('   - Bidder ID: $bidderId');
//
//     return updateBid(
//       bidId: bidId,
//       amount: amount,
//       status: 'Rejected', // Changed to "Rejected"
//       jobId: jobId,
//       bidderId: bidderId,
//     );
//   }
//
// // Convenience methods that accept Bid object
//   Future<CreateBidResponse> acceptBidWithBidObject({
//     required Bid bid,
//   }) async {
//     return acceptBid(
//       bidId: bid.id,
//       amount: double.parse(bid.amount.toString()),
//       jobId: int.tryParse(bid.job.toString()) ?? 0,
//       bidderId: int.tryParse(bid.bidder.toString()) ?? 0,
//     );
//   }
//
//   Future<CreateBidResponse> declineBidWithBidObject({
//     required Bid bid,
//   }) async {
//     return declineBid(
//       bidId: bid.id,
//       amount: double.parse(bid.amount.toString()),
//       jobId: int.tryParse(bid.job.toString()) ?? 0,
//       bidderId: int.tryParse(bid.bidder.toString()) ?? 0,
//     );
//   }
//
//
// }



import 'dart:convert';
import 'package:http/http.dart';
import 'package:hunarmand/utlis/contants.dart';

import '../models/bid_model.dart';
import 'api_service.dart';

class BidService {
  static final BidService _instance = BidService._internal();
  factory BidService() => _instance;
  BidService._internal();

  final ApiService _apiService = ApiService(
    //baseUrl: 'http://10.0.2.2:8000/api/v1/bids/',
    baseUrl: ApiConstants.generalBaseUrl + 'bids/',
    //http://192.168.1.15:8000
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

  // Update an existing bid
  Future<CreateBidResponse> updateBid({
    required int bidId,
    required double amount,
    required String status,
    int? jobId,
    int? bidderId,
  }) async {
    print('💼 Updating bid $bidId...');
    print('   - Amount: $amount');
    print('   - Status: $status');
    if (jobId != null) print('   - Job ID: $jobId');
    if (bidderId != null) print('   - Bidder ID: $bidderId');

    try {
      // Prepare the request body - CORRECTED: Don't use jsonEncode here
      final Map<String, dynamic> requestBody = {
        'amount': amount.toString(),
        'status': status,
      };

      // Only include job and bidder if provided
      if (jobId != null) {
        requestBody['job'] = jobId.toString();
      }
      if (bidderId != null) {
        requestBody['bidder'] = bidderId.toString();
      }

      print('📤 Request body: $requestBody');

      // CORRECTED: Pass the Map directly, not jsonEncode
      final response = await _apiService.put(
        endpoint: '$bidId/?bids_detail=update&job=$jobId',
        body: requestBody, // Direct Map, not jsonEncode
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Bid updated successfully (200 OK)');
        print('📦 Response: ${response.body}');
        return CreateBidResponse.fromJson(responseData);
      }
      else if (response.statusCode == 400) {
        print('❌ Validation error: ${response.body}');
        return CreateBidResponse(errors: responseData['errors']);
      }
      else {
        print('❌ Failed to update bid: ${response.statusCode}');
        print('📦 Response: ${response.body}');
        throw Exception('Failed to update bid: ${response.statusCode}');
      }
    } catch (e) {
      print('💥 Error updating bid: $e');
      rethrow;
    }
  }

  // Alternative update method with full bid data
  Future<CreateBidResponse> updateBidWithBidObject({
    required Bid bid,
    required double amount,
    required String status,
  }) async {
    return updateBid(
      bidId: bid.id,
      amount: amount,
      status: status,
      jobId: _parseId(bid.job),
      bidderId: _parseId(bid.bidder),
    );
  }

  // Helper method to parse ID from dynamic value
  int? _parseId(dynamic id) {
    if (id == null) return null;
    if (id is int) return id;
    if (id is String) return int.tryParse(id);
    return null;
  }

  // Get all bids for the current user (NEW METHOD)
  Future<List<Bid>> getAllBids(int jobId) async {
    try {
      print('📋 Fetching all bids for current user...');

      final response = await _apiService.get(
        endpoint: '?jobs_list=list&job=$jobId', // Note: endpoint name as per your requirement
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

// NEW: Delete a bid
  Future<CreateBidResponse> deleteBid(int bidId, int jobId) async {
    print('🗑️ Deleting bid $bidId for job $jobId...');

    try {
      final response = await _apiService.delete(
        endpoint: '$bidId/?bids_detail=destroy&job=$jobId',
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        print('✅ Bid deleted successfully (${response.statusCode})');
        print('📦 Response: ${response.body.isEmpty ? "Empty body (204 No Content)" : response.body}');
        return CreateBidResponse(message: 'Bid deleted successfully');
      }
      else if (response.statusCode == 404) {
        print('❌ Bid not found: ${response.body}');
        return CreateBidResponse(errors: {'error': 'Bid not found'});
      }
      else {
        print('❌ Failed to delete bid: ${response.statusCode}');
        print('📦 Response: ${response.body}');

        // Only try to parse JSON if there's content
        try {
          if (response.body.isNotEmpty) {
            final responseData = jsonDecode(response.body);
            final errors = responseData is Map<String, dynamic>
                ? responseData
                : {'error': 'Failed to delete bid: ${response.statusCode}'};
            return CreateBidResponse(errors: errors);
          } else {
            return CreateBidResponse(errors: {'error': 'Failed to delete bid: ${response.statusCode}'});
          }
        } catch (e) {
          return CreateBidResponse(errors: {'error': 'Failed to delete bid: ${response.statusCode}'});
        }
      }
    } catch (e) {
      print('💥 Error deleting bid: $e');
      return CreateBidResponse(errors: {'error': e.toString()});
    }
  }
  // Convenience method to delete bid with Bid object
  Future<CreateBidResponse> deleteBidWithBidObject(Bid bid) async {
    final jobId = _parseId(bid.job);
    if (jobId == null) {
      throw Exception('Cannot delete bid: Invalid job ID');
    }

    return deleteBid(bid.id, jobId);
  }

  // Accept a bid
  Future<CreateBidResponse> acceptBid({
    required int bidId,
    required double amount,
    required int jobId,
    required int bidderId,
  }) async {
    print('✅ Accepting bid $bidId...');
    print('   - Amount: $amount');
    print('   - Job ID: $jobId');
    print('   - Bidder ID: $bidderId');

    return updateBid(
      bidId: bidId,
      amount: amount,
      status: 'Approved',
      jobId: jobId,
      bidderId: bidderId,
    );
  }

  // Decline a bid
  Future<CreateBidResponse> declineBid({
    required int bidId,
    required double amount,
    required int jobId,
    required int bidderId,
  }) async {
    print('❌ Declining bid $bidId...');
    print('   - Amount: $amount');
    print('   - Job ID: $jobId');
    print('   - Bidder ID: $bidderId');

    return updateBid(
      bidId: bidId,
      amount: amount,
      status: 'Rejected', // Changed to "Rejected"
      jobId: jobId,
      bidderId: bidderId,
    );
  }

  // Convenience methods that accept Bid object
  Future<CreateBidResponse> acceptBidWithBidObject({
    required Bid bid,
  }) async {
    return acceptBid(
      bidId: bid.id,
      amount: double.parse(bid.amount.toString()),
      jobId: int.tryParse(bid.job.toString()) ?? 0,
      bidderId: int.tryParse(bid.bidder.toString()) ?? 0,
    );
  }

  Future<CreateBidResponse> declineBidWithBidObject({
    required Bid bid,
  }) async {
    return declineBid(
      bidId: bid.id,
      amount: double.parse(bid.amount.toString()),
      jobId: int.tryParse(bid.job.toString()) ?? 0,
      bidderId: int.tryParse(bid.bidder.toString()) ?? 0,
    );
  }
}