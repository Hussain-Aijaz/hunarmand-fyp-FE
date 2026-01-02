import 'package:hunarmand/models/task_model.dart';

// class Job {
//   final int id;
//   final String taskId;
//   final String category;
//   final String priority;
//   final String subject;
//   final String description;
//   final String status;
//   final String assignedTo;
//   final DateTime createdAt;
//   final DateTime updatedAt;
//   final int createdBy;
//   final int modifiedBy;
//
//   Job({
//     required this.id,
//     required this.taskId,
//     required this.category,
//     required this.priority,
//     required this.subject,
//     required this.description,
//     required this.status,
//     required this.assignedTo,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.createdBy,
//     required this.modifiedBy,
//   });
//
//   factory Job.fromJson(Map<String, dynamic> json) {
//     return Job(
//       id: json['id'],
//       taskId: json['task_id'] ?? '',
//       category: json['category'] ?? '',
//       priority: json['priority'] ?? '',
//       subject: json['subject'] ?? '',
//       description: json['description'] ?? '',
//       status: json['status'] ?? '',
//       assignedTo: json['assigned_to']?.toString() ?? '',
//       createdAt: DateTime.parse(json['created_at']),
//       updatedAt: DateTime.parse(json['update_at'] ?? json['created_at']),
//       createdBy: json['created_by'],
//       modifiedBy: json['modified_by'],
//     );
//   }
//
//   // Convert Job to existing Task model
//   Task toTask() {
//     return Task(
//       taskID: taskId,
//       taskName: subject,
//       status: status,
//       description: description,
//       noOfBids: _getRandomBidCount(),
//       minimumBid: _getMinimumBid(),
//       date: createdAt,
//       category: category,
//       priority: priority,
//     );
//   }
//
//   int _getRandomBidCount() {
//     return [5, 8, 12, 15, 20, 6][id % 6];
//   }
//
//   String _getMinimumBid() {
//     final bids = [50, 80, 120, 200, 60, 45];
//     return '\$${bids[id % bids.length]}';
//   }
// }



import 'package:hunarmand/models/task_model.dart';

class Job {
  final int id;
  final int totalBids;
  final String minimumBid;
  final bool allBidsRejected;
  final String taskId;
  final String category;
  final String priority;
  final String subject;
  final String description;
  final String status;
  final String assignedTo;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int modifiedBy;

  Job({
    required this.id,
    required this.totalBids,
    required this.minimumBid,
    required this.allBidsRejected,
    required this.taskId,
    required this.category,
    required this.priority,
    required this.subject,
    required this.description,
    required this.status,
    required this.assignedTo,
    this.startDate,
    this.endDate,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'] ?? 0,
      totalBids: json['total_bids'] ?? 0,
      minimumBid: json['minimum_bid']?.toString() ?? '0.00',
      allBidsRejected: json['all_bids_rejected'] ?? false,
      taskId: json['task_id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      subject: json['subject']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      assignedTo: json['assigned_to']?.toString() ?? '',
      startDate: json['start_date'] != null
          ? DateTime.tryParse(json['start_date'])
          : null,
      endDate: json['end_date'] != null
          ? DateTime.tryParse(json['end_date'])
          : null,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['update_at'] ?? DateTime.now().toString()),
      createdBy: json['created_by'] ?? 0,
      modifiedBy: json['modified_by'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_bids': totalBids,
      'minimum_bid': minimumBid,
      'all_bids_rejected': allBidsRejected,
      'task_id': taskId,
      'category': category,
      'priority': priority,
      'subject': subject,
      'description': description,
      'status': status,
      'assigned_to': assignedTo,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'update_at': updatedAt.toIso8601String(),
      'created_by': createdBy,
      'modified_by': modifiedBy,
    };
  }

  // Convert Job to existing Task model
  Task toTask() {
    return Task(
      taskID: taskId,
      taskName: subject,
      status: status,
      description: description,
      noOfBids: totalBids,
      minimumBid: '\$${double.parse(minimumBid).toStringAsFixed(2)}',
      date: createdAt,
      category: category,
      priority: priority,
    );
  }

  // Copy with method for immutability
  Job copyWith({
    int? id,
    int? totalBids,
    String? minimumBid,
    bool? allBidsRejected,
    String? taskId,
    String? category,
    String? priority,
    String? subject,
    String? description,
    String? status,
    String? assignedTo,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? createdBy,
    int? modifiedBy,
  }) {
    return Job(
      id: id ?? this.id,
      totalBids: totalBids ?? this.totalBids,
      minimumBid: minimumBid ?? this.minimumBid,
      allBidsRejected: allBidsRejected ?? this.allBidsRejected,
      taskId: taskId ?? this.taskId,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      subject: subject ?? this.subject,
      description: description ?? this.description,
      status: status ?? this.status,
      assignedTo: assignedTo ?? this.assignedTo,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      createdBy: createdBy ?? this.createdBy,
      modifiedBy: modifiedBy ?? this.modifiedBy,
    );
  }
}