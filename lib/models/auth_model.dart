// Update RegisterRequest to use role
class RegisterRequest {
  final String email;
  final String name;
  final String password;
  final String password2;
  final String phone;
  final String role;

  RegisterRequest({
    required this.email,
    required this.name,
    required this.password,
    required this.password2,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'password': password,
      'password2': password2,
      'phone': phone,
      'role': role,
    };
  }
}

// Update UserData to include role
class UserData {
  final String id;
  final String email;
  final String name;
  final String? phone;
  final String role; // Make sure this exists
  final String? avatar;

  UserData({
    required this.id,
    required this.email,
    required this.name,
    this.phone,
    required this.role, // Required field
    this.avatar,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'].toString(),
      email: json['email'],
      name: json['name'],
      phone: json['phone'],
      role: json['role'] ?? 'seeker', // Default to 'seeker' if not provided
      avatar: json['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'role': role,
      'avatar': avatar,
    };
  }

  // Helper methods (optional)
  bool get isProvider => role.toLowerCase().contains('provider');
  bool get isSeeker => role.toLowerCase().contains('seeker');
}

class RegisterResponse {
  final Token? token;
  final String? msg;
  final Map<String, dynamic>? errors;

  RegisterResponse({
    this.token,
    this.msg,
    this.errors,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      token: json['token'] != null ? Token.fromJson(json['token']) : null,
      msg: json['msg'],
      errors: json['errors'],
    );
  }
}

class Token {
  final String refresh;
  final String access;

  Token({
    required this.refresh,
    required this.access,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      refresh: json['refresh'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
    };
  }
}

// UPDATED: LoginRequest with location fields
class LoginRequest {
  final String email;
  final String password;
  final double? latitude;
  final double? longitude;

  LoginRequest({
    required this.email,
    required this.password,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    // Only add location if available
    if (latitude != null && longitude != null) {
      data['latitude'] = latitude!.toString();
      data['longitude'] = longitude!.toString();
    } else if (latitude != null) {
      data['latitude'] = latitude!.toString();
    } else if (longitude != null) {
      data['longitude'] = longitude!.toString();
    }

    return data;
  }
}

class LoginResponse {
  final Token? token;
  final String? msg;
  final Map<String, dynamic>? errors;
  final UserData? user;

  LoginResponse({
    this.token,
    this.msg,
    this.errors,
    this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] != null ? Token.fromJson(json['token']) : null,
      msg: json['msg'],
      errors: json['errors'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

// Optional: Create a separate model for registration with location if needed
class RegisterRequestWithLocation {
  final String email;
  final String name;
  final String password;
  final String password2;
  final String phone;
  final String role;
  final double? latitude;
  final double? longitude;

  RegisterRequestWithLocation({
    required this.email,
    required this.name,
    required this.password,
    required this.password2,
    required this.phone,
    required this.role,
    this.latitude,
    this.longitude,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'email': email,
      'name': name,
      'password': password,
      'password2': password2,
      'phone': phone,
      'role': role,
    };

    // Add location if available
    if (latitude != null) {
      data['latitude'] = latitude!.toString();
    }
    if (longitude != null) {
      data['longitude'] = longitude!.toString();
    }

    return data;
  }
}