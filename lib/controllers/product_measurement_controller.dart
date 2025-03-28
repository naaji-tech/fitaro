import 'dart:convert';
import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ProductMeasurementController extends GetxController {
  final productMeasurements = <dynamic>[].obs;
  final hasProductMeasurements = false.obs;

  Future<void> deleteProductMeasurements(String productId) async {
    try {
      logger.i('Deleting product measurements...');
      final response = await http.delete(
        Uri.parse(productMeasurementUrl + productId),
      );

      if (response.statusCode == HttpStatus.ok) {
        logger.i("Product measurements deleted successfully.");
        clearMeasurements();
      } else {
        logger.e(
          "Failed to delete product measurements. Status code: ${response.statusCode}",
        );
        ErrorSnackbar.show(
          title: "Error",
          message: "Failed to delete product measurements. Please try again.",
        );
      }
    } catch (e) {
      logger.e('Exception occurred while deleting measurements: $e');
      ErrorSnackbar.show(
        title: "Internal Error",
        message: "Contact support: mohamednaaji@yahoo.com",
      );
    }
  }

  Future<void> getProductMeasurements(String productId) async {
    try {
      logger.i('Loading product measurements...');
      final response = await http.get(
        Uri.parse(productMeasurementUrl + productId),
      );

      if (response.statusCode != HttpStatus.ok) {
        return;
      }

      logger.i("get product measurements called success.");

      final jsonData = json.decode(response.body);

      if (jsonData["data"].isNotEmpty) {
        List<dynamic> measurementsData = jsonData["data"];
        productMeasurements.value = measurementsData;
        hasProductMeasurements.value = true;
      }
      logger.i('Loaded measurements: $productMeasurements');
    } catch (e) {
      logger.e('Exception occurred: $e');
      ErrorSnackbar.show(
        title: "Internal Error",
        message: "Contact support: mohamednaaji@yahoo.com",
      );
    }
  }

  Future<void> clearMeasurements() async {
    productMeasurements.clear();
    hasProductMeasurements.value = false;
  }
}
