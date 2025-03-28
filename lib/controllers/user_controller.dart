import 'dart:convert';
import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserController extends GetxController {
  final username = ''.obs;
  final userType = ''.obs;
  final userLoggedStatusOn = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserLoggedStatus();
  }

  void setUserData({required String username, required String userType}) {
    this.username.value = username;
    this.userType.value = userType;
  }

  Future<bool> saveUserData(
    String username,
    String userType,
    String password,
  ) async {
    logger.i('Saving user data - Username: $username, UserType: $userType');

    final response = await _postRequest(
      url: signupUrl,
      body: {'username': username, 'password': password, 'userType': userType},
    );

    if (response == null || response.statusCode != HttpStatus.created) {
      logger.e('Failed to save user data: ${response?.body}');
      return false;
    }

    await _saveToPreferences(
      username: username,
      userType: userType,
      loggedIn: true,
    );
    logger.i('User data saved successfully');
    return true;
  }

  Future<void> loadUserData(String username, String password) async {
    logger.i('Loading user data...');

    final response = await _postRequest(
      url: "$loginUrl?username=$username&password=$password",
    );

    if (response == null || response.statusCode != HttpStatus.accepted) {
      logger.e('Failed to load user data: ${response?.body}');
      return;
    }

    final resBody = jsonDecode(response.body);
    final userType = resBody['data']['userType'];

    await _saveToPreferences(
      username: username,
      userType: userType,
      loggedIn: true,
    );
    logger.i('User data loaded successfully: $userType');
  }

  Future<void> clearUserData() async {
    username.value = '';
    userType.value = '';
    userLoggedStatusOn.value = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    logger.i('User data cleared');
  }

  Future<void> _loadUserLoggedStatus() async {
    logger.i("Checking user logged status...");
    final prefs = await SharedPreferences.getInstance();

    username.value = prefs.getString('username') ?? '';
    userType.value = prefs.getString('userType') ?? '';
    userLoggedStatusOn.value = prefs.getBool('userLoggedStatusOn') ?? false;

    logger.i("User logged status: ${userLoggedStatusOn.value}");
  }

  Future<http.Response?> _postRequest({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    try {
      return await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: body != null ? jsonEncode(body) : null,
      );
    } catch (e) {
      logger.e('HTTP request failed: $e');
      return null;
    }
  }

  Future<void> _saveToPreferences({
    required String username,
    required String userType,
    required bool loggedIn,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userType', userType);
    await prefs.setBool('userLoggedStatusOn', loggedIn);

    this.username.value = username;
    this.userType.value = userType;
    userLoggedStatusOn.value = loggedIn;
  }
}
