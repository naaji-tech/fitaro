import 'package:fitaro/views/seller/seller_add_sizes_screen.dart';
import 'package:fitaro/views/seller/seller_main_screen.dart';
import 'package:fitaro/views/seller/seller_product_details_screen.dart';
import 'package:fitaro/views/server_error_screen.dart';
import 'package:fitaro/views/about_screen.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'views/login_screen.dart';
import 'views/signup_screen.dart';
import 'views/user/user_main_screen.dart';
import 'views/user/user_product_details_screen.dart';
import 'views/seller/seller_add_product_screen.dart';
import 'views/seller/seller_add_product_manual_screen.dart';
import 'controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (route == '/' || route == '/signup') return null;

    if (!authController.isUserLoggedIn) return const RouteSettings(name: '/');

    if (route!.startsWith('/seller') && !authController.isSellerUser) {
      return const RouteSettings(name: '/');
    }

    return null;
  }
}

final List<GetPage> appRoutes = [
  GetPage(name: '/', page: () => LoginScreen()),
  GetPage(name: '/signup', page: () => SignupScreen()),
  GetPage(name: "/server-down", page: () => ServerErrorScreen()),
  GetPage(
    name: '/home',
    page: () => UserMainScreen(),
    middlewares: [AuthMiddleware()],
  ),
  GetPage(
    name: '/product-details',
    page: () => UserProductDetailsScreen(),
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
  GetPage(
    name: '/about',
    page: () => AboutScreen(),
    middlewares: [AuthMiddleware()],
  ),
];
