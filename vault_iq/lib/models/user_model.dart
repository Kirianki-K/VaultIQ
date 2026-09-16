class UserModel {
  const UserModel({
    required this.id,
    required this.email,
    required this.role,
  });

  final String id;
  final String email;
  final String role; // 'admin' or 'broker'

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'broker',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'role': role,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      role: role ?? this.role,
    );
  }
}