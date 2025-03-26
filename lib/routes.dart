import 'package:fitaro/views/seller/seller_add_sizes_screen.dart';
import 'package:fitaro/views/seller/seller_main_screen.dart';
import 'package:fitaro/views/seller/seller_product_details_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/user/main_screen.dart';
import 'views/measurements_screen.dart';
import 'views/user/product_details_screen.dart';
import 'views/measurement_input_screen.dart';
import 'views/seller/seller_add_product_screen.dart';
import 'views/seller/seller_add_product_manual_screen.dart';
import 'controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    // Allow access to login and signup without authentication
    if (route == '/' || route == '/signup') {
      return null;
    }

    // Check if user is logged in
    if (!authController.isUserLoggedIn) {
      return const RouteSettings(name: '/');
    }

    // Check seller-specific routes
    if (route!.startsWith('/seller') && !authController.isSellerUser) {
      return const RouteSettings(name: '/');
    }

    return null;
  }
}

final List<GetPage> appRoutes = [
  GetPage(name: '/', page: () => LoginScreen()),
  GetPage(name: '/signup', page: () => SignupScreen()),
  GetPage(
    name: '/home',
    page: () => MainScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/measurements',
    page: () => MeasurementsScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/product-details',
    page: () => ProductDetailsScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/measurement-input',
    page: () => MeasurementInputScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/seller-home',
    page: () => SellerMainScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/seller-product-details',
    page: () => SellerProductDetailsScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/seller-add-product',
    page: () => SellerAddProductScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/seller-add-product-manual',
    page: () => SellerAddProductManualScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/seller-add-product-sizes',
    page: () => SellerAddSizesScreen(),
    middlewares: [AuthMiddleware()],
  ),
];
