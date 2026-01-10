// File: lib/core/models/user_model.dart

class UserModel {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? location;
  final String? role;
  final String? experience;
  final Map<String, dynamic>? stats; // e.g., {'average': 32.5, 'strikeRate': 145.2, 'matchesPlayed': 12, ...}

  UserModel({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.location,
    this.role,
    this.experience,
    this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      phoneNumber: json['phone_number'] as String,
      name: json['name'] as String?,
      location: json['location'] as String?,
      role: json['role'] as String?,
      experience: json['experience'] as String?,
      stats: json['stats'] != null ? Map<String, dynamic>.from(json['stats']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone_number': phoneNumber,
      'name': name,
      'location': location,
      'role': role,
      'experience': experience,
      'stats': stats,
    };
  }

  // Optional: Helper to create a copy with updated fields
  UserModel copyWith({
    String? name,
    String? location,
    String? role,
    String? experience,
    Map<String, dynamic>? stats,
  }) {
    return UserModel(
      id: id,
      phoneNumber: phoneNumber,
      name: name ?? this.name,
      location: location ?? this.location,
      role: role ?? this.role,
      experience: experience ?? this.experience,
      stats: stats ?? this.stats,
    );
  }
}