import 'dart:convert';
import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductMeasurementController extends GetxController {
  final productMeasurements = <dynamic>[].obs;
  final hasProductMeasurements = false.obs;

  Future<void> sentProductMeasurementsByScan(XFile image, double userHeight) async {
    try {
      logger.i('Detecting measurements...');
      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString("username") ?? "";

      final request =
          http.MultipartRequest("POST", Uri.parse(productMeasurementUrl + username))
            ..files.add(
              await http.MultipartFile.fromPath('usrImage', image.path),
            )
            ..fields['usrHeight'] = userHeight.toString();

      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode != HttpStatus.ok) {
        return;
      }

      final resBody = json.decode(res.body);

      if (resBody["data"].isNotEmpty) {
        Map<String, dynamic> measurementsData = resBody["data"];
        productMeasurements.value =
            measurementsData.entries
                .map(
                  (entry) => {
                    "name": entry.key,
                    "value": entry.value.toString(),
                  },
                )
                .toList();
        hasProductMeasurements.value = true;
      }
      logger.i('Detected measurements: $productMeasurements');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }

  Future<void> getProductMeasurements(String productId) async {
    try {
      logger.i('Loading product measurements...');
      final response = await http.get(Uri.parse(productMeasurementUrl + productId));

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
      Get.snackbar(
            'Error',
            'Internal error: contact support: mohamednaaji@yahoo.com',
            backgroundColor: const Color.fromRGBO(255, 0, 0, 0.3),
            colorText: const Color.fromARGB(255, 0, 0, 0),
            duration: Duration(seconds: 3),
          );
    }
  }

  void clearMeasurements() async {
    productMeasurements.clear();
    hasProductMeasurements.value = false;
  }
}
