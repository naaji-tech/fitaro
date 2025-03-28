import 'dart:convert';

import 'package:fitaro/controllers/user_measurement_controller.dart';
import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/recommend_size_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:get/get.dart';
import 'user_controller.dart';

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
    Future.delayed(const Duration(milliseconds: 1000), () async {
      await checkLoginStatus();
    });
  }

  Future<void> checkLoginStatus() async {
    try {
      logger.i('Checking login status...');
      bool isUserAlreadyLogged = _userController.userLoggedStatusOn.value;
      logger.i('User already logged in: $isUserAlreadyLogged');
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
      ErrorSnackbar.show(
        title: "Error",
        message: "Please enter username and password",
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

        SuccesSnackbar.show(
          title: "Success",
          message: "Welcome back, $username!",
        );
      } else {
        logger.i('Login failed - Invalid credentials');
        ErrorSnackbar.show(
          title: "Error",
          message: "Invalid username or password",
        );
      }
    } catch (e) {
      logger.e('Login error: $e');
      ErrorSnackbar.show(
        title: "Error",
        message: "${jsonDecode(e.toString())["message"]}",
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

      SuccesSnackbar.show(title: "Success", message: "Registration successful");
    } catch (e) {
      logger.i('Registration error: $e');
      ErrorSnackbar.show(
        title: "Error",
        message: "${jsonDecode(e.toString())["message"]}",
      );
    }
  }

  void logout() async {
    logger.i('Logging out user: ${_userController.username.value}');
    await _userController.clearUserData();
    await _measurementController.clearMeasurements();
    await _sizeRecomController.clearSizeRecom();
    await _productController.clearProducts();
    isLoggedIn.value = false;
    isSeller.value = false;
    await Get.offAllNamed('/');
  }
}
