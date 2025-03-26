import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fitaro/models/user_model.dart';

class UserService {
  static const String _userKey = 'current_user';
  static const String _usersKey = 'registered_users';

  // Save current user
  static Future<void> saveCurrentUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
  }

  // Get current user
  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Save new user registration
  static Future<bool> registerUser(User newUser) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];

    // Check if username already exists
    for (String userStr in usersJson) {
      final user = User.fromJson(jsonDecode(userStr));
      if (user.username == newUser.username) {
        return false; // Username already exists
      }
    }

    // Add new user
    usersJson.add(jsonEncode(newUser.toJson()));
    await prefs.setStringList(_usersKey, usersJson);
    return true;
  }

  // Verify login credentials
  static Future<User?> verifyLogin(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final usersJson = prefs.getStringList(_usersKey) ?? [];

    for (String userStr in usersJson) {
      final user = User.fromJson(jsonDecode(userStr));
      if (user.username == username && user.password == password) {
        return user;
      }
    }
    return null;
  }

  // Logout current user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
