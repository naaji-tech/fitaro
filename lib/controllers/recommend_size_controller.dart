import 'dart:convert';
import 'dart:io';

import 'package:fitaro/controllers/user_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class RecommendSizeController extends GetxController {
  final userController = Get.find<UserController>();
  var recommendSize = ''.obs;
  var hasGotRecommendSize = false.obs;

  void setSizeRecom(String size, bool hasSizeRecom) {
    recommendSize.value = size;
    hasGotRecommendSize.value = hasSizeRecom;
  }

  Future<void> clearSizeRecom() async {
    recommendSize.value = '';
    hasGotRecommendSize.value = false;
  }

  Future<void> fetchSizeRecomByOldMesurement(String productId) async {
    try {
      logger.i('Fetching size recommendation...');
      logger.d('Product ID: $productId');

      final username = userController.username.value;
      logger.d('username: $username');

      final response = await http.get(
        Uri.parse("$sizeRecomUrlViaOld/$username/$productId"),
      );

      if (response.statusCode != HttpStatus.ok) return;

      final resBody = json.decode(response.body);

      recommendSize.value = resBody["data"]["recommendSize"];
      hasGotRecommendSize.value = true;

      logger.i('Size recommendation fetched successfully');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }

  Future<void> fetchSizeRecomByMesureMe(
    XFile image,
    double userHeight,
    String productId,
  ) async {
    try {
      logger.i('Fetching size recommendation...');
      logger.d('Product ID: $productId');
      logger.d('Image path: ${image.path}');
      logger.d('User height: $userHeight');

      final username = userController.username.value;
      logger.d('username: $username');

      final request =
          http.MultipartRequest(
              "GET",
              Uri.parse("$sizeRecomUrlViaScan/$username/$productId"),
            )
            ..files.add(
              await http.MultipartFile.fromPath('usrImage', image.path),
            )
            ..fields['usrHeight'] = userHeight.toString();

      final response = await request.send();
      final res = await http.Response.fromStream(response);

      if (response.statusCode != HttpStatus.ok) return;

      final resBody = json.decode(res.body);

      recommendSize.value = resBody["data"]["recommendSize"];
      hasGotRecommendSize.value = true;

      logger.d("recommendSize: ${recommendSize.value}");
      logger.i('Size recommendation fetched successfully');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }
}
