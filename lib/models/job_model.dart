import 'package:hunarmand/models/task_model.dart';

class Job {
  final int id;
  final String taskId;
  final String category;
  final String priority;
  final String subject;
  final String description;
  final String status;
  final String assignedTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int createdBy;
  final int modifiedBy;

  Job({
    required this.id,
    required this.taskId,
    required this.category,
    required this.priority,
    required this.subject,
    required this.description,
    required this.status,
    required this.assignedTo,
    required this.createdAt,
    required this.updatedAt,
    required this.createdBy,
    required this.modifiedBy,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    return Job(
      id: json['id'],
      taskId: json['task_id'] ?? '',
      category: json['category'] ?? '',
      priority: json['priority'] ?? '',
      subject: json['subject'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      assignedTo: json['assigned_to']?.toString() ?? '',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['update_at'] ?? json['created_at']),
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
    );
  }

  // Convert Job to existing Task model
  Task toTask() {
    return Task(
      taskID: taskId,
      taskName: subject,
      status: status,
      description: description,
      noOfBids: _getRandomBidCount(),
      minimumBid: _getMinimumBid(),
      date: createdAt,
      category: category,
      priority: priority,
    );
  }

  int _getRandomBidCount() {
    return [5, 8, 12, 15, 20, 6][id % 6];
  }

  String _getMinimumBid() {
    final bids = [50, 80, 120, 200, 60, 45];
    return '\$${bids[id % bids.length]}';
  }
}