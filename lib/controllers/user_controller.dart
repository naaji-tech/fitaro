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
    isuserLoggedStatusOn();
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

    final response = await http.post(
      Uri.parse(signupUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'userType': userType,
      }),
    );

    if (response.statusCode != HttpStatus.created) {
      logger.e('Failed to save user data: ${response.body}');
      return false;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userType', userType);
    await prefs.setBool("userLoggedStatusOn", true);

    this.username.value = username;
    this.userType.value = userType;
    userLoggedStatusOn.value = true;

    logger.i('User data saved successfully');
    return true;
  }

  Future<void> loadUserData(String username, String password) async {
    logger.i('Loading user data...');

    final response = await http.post(
      Uri.parse("$loginUrl?username=$username&password=$password"),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != HttpStatus.accepted) {
      logger.e('Failed to save user data: ${response.body}');
      return;
    }

    final resBody = jsonDecode(response.body);
    final userType = resBody['data']['userType'];

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('userType', userType);
    await prefs.setBool("userLoggedStatusOn", true);

    this.username.value = username;
    this.userType.value = userType;
    userLoggedStatusOn.value = true;

    logger.i('User data loaded successfully: $userType');
  }

  Future<void> clearUserData() async {
    username.value = '';
    userType.value = '';
    userLoggedStatusOn.value = false;
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  Future<bool> isuserLoggedStatusOn() async {
    final prefs = await SharedPreferences.getInstance();
    final userLoggedStatusOn = prefs.getBool('userLoggedStatusOn');
    final username = prefs.getString('username');
    final userType = prefs.getString('userType');
    this.username.value = username ?? '';
    this.userType.value = userType ?? '';
    this.userLoggedStatusOn.value = userLoggedStatusOn ?? false;
    return this.userLoggedStatusOn.value;
  }
}
