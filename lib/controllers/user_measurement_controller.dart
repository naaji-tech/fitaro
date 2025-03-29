import 'dart:convert';
import 'dart:io';

import 'package:fitaro/controllers/user_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserMeasurementController extends GetxController {
  final userController = Get.find<UserController>();
  final measurements = <Map<String, String>>[].obs;
  final hasMeasurements = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadMeasurements();
  }

  Future<void> scanUserMeasurements(XFile image, double userHeight) async {
    try {
      logger.i('Scan user measurements...');
      final username = userController.username.value;
      logger.d('username: $username');
      logger.d('Image path: ${image.path}');
      logger.d('User height: $userHeight');

      final request =
          http.MultipartRequest("POST", Uri.parse(measurementUrl + username))
            ..files.add(
              await http.MultipartFile.fromPath('usrImage', image.path),
            )
            ..fields['usrHeight'] = userHeight.toString();

      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode != HttpStatus.ok) {
        return;
      }

      logger.i("Scan user measurements success.");

      final resBody = json.decode(res.body);

      if (resBody["data"].isNotEmpty) {
        Map<String, dynamic> measurementsData = resBody["data"];
        measurements.value =
            measurementsData.entries
                .map(
                  (entry) => {
                    "name": entry.key,
                    "value": entry.value.toString(),
                  },
                )
                .toList();
        hasMeasurements.value = true;
      }
      logger.d('Scaned user measurements: $measurements');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }

  Future<void> loadMeasurements() async {
    try {
      logger.i('Loading user measurements...');

      final username = userController.username.value;
      logger.d('username: $username');
      final response = await http.get(Uri.parse(measurementUrl + username));

      if (response.statusCode != HttpStatus.ok) {
        return;
      }

      logger.i("Loading user measurements success.");

      final jsonData = json.decode(response.body);

      if (jsonData["data"].isNotEmpty) {
        Map<String, dynamic> measurementsData = jsonData["data"];
        measurements.value =
            measurementsData.entries
                .map(
                  (entry) => {
                    "name": entry.key,
                    "value": entry.value.toString(),
                  },
                )
                .toList();
        hasMeasurements.value = true;
      }
      logger.d('Loaded measurements: $measurements');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }

  Future<void> clearMeasurements() async {
    measurements.clear();
    hasMeasurements.value = false;
    logger.i("Clear user measurements success.");
  }
}
