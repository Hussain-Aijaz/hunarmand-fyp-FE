class Task {
  final String taskID;
  final String taskName;
  final String status;
  final String description;
  final int noOfBids;
  final String minimumBid;
  final DateTime date;
  final String category;
  final String priority;

  Task({
    required this.taskID,
    required this.taskName,
    required this.status,
    required this.description,
    required this.noOfBids,
    required this.minimumBid,
    required this.date,
    required this.category,
    required this.priority,
  });
}