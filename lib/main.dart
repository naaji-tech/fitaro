import 'package:fitaro/controllers/backend_server_controller.dart';
import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/product_measurement_controller.dart';
import 'package:fitaro/controllers/recommend_size_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/user_measurement_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.testMode = true;

  final backendServerController = Get.put(BackendServerController());
  Get.put(UserMeasurementController());
  Get.put(ProductController());
  Get.put(ProductMeasurementController());
  Get.put(RecommendSizeController());
  Get.put(UserController());
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
      transitionDuration: const Duration(milliseconds: 800),
      navigatorKey: Get.key,
    );
  }
}
