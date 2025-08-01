import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/backend_server_controller.dart';
import 'controllers/product_controller.dart';
import 'controllers/product_measurement_controller.dart';
import 'controllers/recommend_size_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/user_measurement_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.testMode = true;

  // Initialize controllers
  final backendServerController = Get.put(BackendServerController());

  Get.put(UserController());
  Get.put(UserMeasurementController());
  Get.put(ProductController());
  Get.put(ProductMeasurementController());
  Get.put(RecommendSizeController());
  Get.put(AuthController());

  await backendServerController.checkServerConnection();

  runApp(
    FitaroApp(
      isServerConnected: backendServerController.isServerConnected.value,
    ),
  );
}

class FitaroApp extends StatelessWidget {
  final bool isServerConnected;

  const FitaroApp({super.key, required this.isServerConnected});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitaro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        fontFamily: 'Roboto',
      ),
      initialRoute: isServerConnected ? '/' : '/server-down',
      getPages: appRoutes,
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 500),
      navigatorKey: Get.key,
    );
  }
}
