class User {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String role; // 'user' atau 'admin'

  User({
    this.id,
    required this.username,
    required this.email,
    required this.password,
    this.role = 'user',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      role: map['role'] ?? 'user',
    );
  }
}
