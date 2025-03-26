import 'dart:convert';

import 'package:fitaro/controllers/user_measurement_controller.dart';
import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/size_recom_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:get/get.dart';
import 'user_controller.dart';
import 'package:flutter/material.dart';

class AuthController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final UserMeasurementController measurementController =
      Get.find<UserMeasurementController>();
  final SizeRecomController sizeRecomController =
      Get.find<SizeRecomController>();
  final ProductController productController = Get.find<ProductController>();
  final RxBool isLoggedIn = false.obs;
  final RxBool isSeller = false.obs;

  bool get isUserLoggedIn => isLoggedIn.value;
  bool get isSellerUser => isSeller.value;

  @override
  void onInit() {
    super.onInit();
    Future.delayed(const Duration(milliseconds: 100), () => checkLoginStatus());
  }

  Future<void> checkLoginStatus() async {
    try {
      bool isUserAlreadyLogged = await userController.isuserLoggedStatusOn();
      if (isUserAlreadyLogged) {
        isLoggedIn.value = true;
        isSeller.value = userController.userType.value == "seller";

        // Only navigate if we're on the login screen
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

  bool canAccessRoute(String route) {
    if (!isLoggedIn.value) {
      return route == '/' || route == '/signup';
    }

    // Seller-specific routes
    if (route.startsWith('/seller')) {
      return isSeller.value;
    }

    return true;
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
      await userController.loadUserData(username, password);
      final storedUsername = userController.username.value;
      final userLoggedStatusOn = userController.userLoggedStatusOn.value;
      final userType = userController.userType.value;

      logger.i(
        'Stored credentials - Username: $storedUsername, User Type: $userType',
      );

      if (username == storedUsername && userLoggedStatusOn) {
        logger.i('Login user successful.');
        isLoggedIn.value = true;
        isSeller.value = userType == "seller";

        await productController.fetchProducts();
        if (isSeller.value) {
          await Get.offAllNamed('/seller-home');
        } else {
          await measurementController.loadMeasurements();
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
      bool userLoggedStatusOn = await userController.saveUserData(
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
    logger.i('Logging out user: ${userController.username.value}');
    userController.clearUserData();
    measurementController.clearMeasurements();
    sizeRecomController.clearSizeRecom();
    productController.clearProducts();
    isLoggedIn.value = false;
    isSeller.value = false;
    Get.offAllNamed('/');
  }
}
