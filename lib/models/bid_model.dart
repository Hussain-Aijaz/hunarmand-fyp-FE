class Bid {
  final int id;
  final String amount; // Changed to String to match "20000.00"
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int job;
  final int bidder;
  final int? createdBy;
  final int? modifiedBy;

  Bid({
    required this.id,
    required this.amount,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.job,
    required this.bidder,
    this.createdBy,
    this.modifiedBy,
  });

  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      id: json['id'],
      amount: json['amount'].toString(), // Convert to string
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['update_at']), // Note: 'update_at' not 'updated_at'
      job: json['job'],
      bidder: json['bidder'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
    );
  }

  // For creating bid request, amount should be double
  Map<String, dynamic> toCreateJson() {
    return {
      'amount': double.parse(amount), // Send as double for creation
      'status': status,
      'job': job,
      'bidder': bidder,
    };
  }

  // For display
  double get amountValue => double.parse(amount);
  String get formattedAmount => 'RS ${amountValue.toStringAsFixed(2)}';
}

class CreateBidRequest {
  final double amount; // Keep as double for API request
  final String status;
  final int job;
  final int bidder;

  CreateBidRequest({
    required this.amount,
    required this.status,
    required this.job,
    required this.bidder,
  });

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'status': status,
      'job': job,
      'bidder': bidder,
    };
  }
}

class CreateBidResponse {
  final Bid? bid;
  final String? message;
  final Map<String, dynamic>? errors;

  CreateBidResponse({
    this.bid,
    this.message,
    this.errors,
  });

  factory CreateBidResponse.fromJson(Map<String, dynamic> json) {
    return CreateBidResponse(
      bid: Bid.fromJson(json), // Direct JSON is the bid object
      message: json['message'],
      errors: json['errors'],
    );
  }
}