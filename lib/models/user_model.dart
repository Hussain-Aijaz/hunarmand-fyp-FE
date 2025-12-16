class User {
  final String id;
  final String name;
  final String email;
  final String role; // 'seeker' or 'provider'
  final String? profileImage;
  final DateTime? createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImage,
    this.createdAt,
  });

  // Convert to map for storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
    };
  }

  // Create from map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'seeker',
      profileImage: map['profileImage'],
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
    );
  }

  // Check if user is seeker
  bool get isSeeker => role == 'seeker';

  // Check if user is provider
  bool get isProvider => role == 'provider';
}