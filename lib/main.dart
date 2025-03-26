import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/product_measurement_controller.dart';
import 'package:fitaro/controllers/size_recom_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'routes.dart';
import 'controllers/auth_controller.dart';
import 'controllers/user_controller.dart';
import 'controllers/user_measurement_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.testMode = true;

  Get.put(ProductMeasurementController());
  Get.put(UserMeasurementController());
  Get.put(ProductController());
  Get.put(SizeRecomController());
  Get.put(UserController());
  Get.put(AuthController());

  runApp(const FitaroApp());
}

class FitaroApp extends StatelessWidget {
  const FitaroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitaro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.grey),
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      getPages: appRoutes,
      defaultTransition: Transition.native,
      transitionDuration: const Duration(milliseconds: 800),
      navigatorKey: Get.key,
    );
  }
}
