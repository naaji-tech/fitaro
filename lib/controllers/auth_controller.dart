import 'dart:convert';

import 'package:fitaro/controllers/backend_server_controller.dart';
import 'package:fitaro/controllers/user_measurement_controller.dart';
import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/recommend_size_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final _userController = Get.find<UserController>();
  final _measurementController = Get.find<UserMeasurementController>();
  final _sizeRecomController = Get.find<RecommendSizeController>();
  final _productController = Get.find<ProductController>();
  final isLoggedIn = false.obs;
  final isSeller = false.obs;

  bool get isUserLoggedIn => isLoggedIn.value;
  bool get isSellerUser => isSeller.value;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 500), () async {
      await checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    try {
      bool isUserAlreadyLogged = _userController.userLoggedStatusOn.value;
      if (isUserAlreadyLogged) {
        isLoggedIn.value = true;
        isSeller.value = _userController.userType.value == "seller";

        if (Get.currentRoute == '/') {
          if (isSeller.value) {
            await Get.offAllNamed('/seller-home');
          } else {
            await Get.offAllNamed('/home');
          }
        }
      } else {
        isLoggedIn.value = false;
        isSeller.value = false;

        // Only navigate to login if we're not already there and not signing up
        if (Get.currentRoute != '/' && Get.currentRoute != '/signup') {
          await Get.offAllNamed('/');
        }
      }
    } catch (e) {
      logger.i('Error checking login status: $e');
      isLoggedIn.value = false;
      isSeller.value = false;
    }
  }

  Future<void> login(String username, String password) async {
    logger.i('Login attempt...');
    logger.i('Entered credentials - Username: $username, Password: $password');

    if (username.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await _userController.loadUserData(username, password);
      final storedUsername = _userController.username.value;
      final userType = _userController.userType.value;
      final userLoggedStatusOn = _userController.userLoggedStatusOn.value;

      logger.i(
        'Stored credentials - Username: $storedUsername, User Type: $userType',
      );

      if (username == storedUsername && userLoggedStatusOn) {
        logger.i('Login user successful.');
        isLoggedIn.value = true;
        isSeller.value = userType == "seller";

        await _productController.fetchProducts();
        if (isSeller.value) {
          await _productController.fetchProducts();
          await Get.offAllNamed('/seller-home');
        } else {
          await _measurementController.loadMeasurements();
          await Get.offAllNamed('/home');
        }

        Get.snackbar(
          'Success',
          'Welcome back, $username!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromRGBO(76, 175, 80, 0.1),
          colorText: Colors.green,
        );
      } else {
        logger.i('Login failed - Invalid credentials');
        Get.snackbar(
          'Error',
          'Invalid username or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Color.fromRGBO(255, 0, 0, 0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      logger.e('Login error: $e');
      Get.snackbar(
        'Error',
        ': ${jsonDecode(e.toString())["message"]}',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> register(
    String username,
    String password,
    String userType,
  ) async {
    logger.i('Registering new user...');
    logger.d('New user - Username: $username, UserType: $userType');

    try {
      bool userLoggedStatusOn = await _userController.saveUserData(
        username,
        userType,
        password,
      );
      logger.i('Registration successful.');

      isLoggedIn.value = userLoggedStatusOn;
      isSeller.value = userType == "seller";

      if (isSeller.value) {
        await Get.offAllNamed('/seller-home');
      } else {
        await Get.offAllNamed('/home');
      }

      Get.snackbar(
        'Success',
        'Registration successful',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromRGBO(76, 175, 80, 0.1),
        colorText: Colors.green,
      );
    } catch (e) {
      logger.i('Registration error: $e');
      Get.snackbar(
        'Error',
        'An error occurred during registration',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void logout() {
    logger.i('Logging out user: ${_userController.username.value}');
    _userController.clearUserData();
    _measurementController.clearMeasurements();
    _sizeRecomController.clearSizeRecom();
    _productController.clearProducts();
    isLoggedIn.value = false;
    isSeller.value = false;
    Get.offAllNamed('/');
  }
}
