class User {
  final String username;
  final String password;
  final String userType;

  User({
    required this.username,
    required this.password,
    required this.userType,
  });

  // Convert user object to JSON
  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'userType': userType};
  }

  // Create user object from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      userType: json['userType'] ?? 'Customer',
    );
  }
}
