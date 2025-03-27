import 'dart:convert';
import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RecommendSizeController extends GetxController {
  var recommendSize = ''.obs;
  var hasGotRecommendSize = false.obs;

  void setSizeRecom(String size, bool hasSizeRecom) {
    recommendSize.value = size;
    hasGotRecommendSize.value = hasSizeRecom;
  }

  void clearSizeRecom() {
    recommendSize.value = '';
    hasGotRecommendSize.value = false;
  }

  Future<void> fetchSizeRecomByOldMesurement(String productId) async {
    try {
      logger.i('Fetching size recommendation...');

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString("username") ?? "";

      final response = await http.get(
        Uri.parse("$sizeRecomUrl/$username/$productId"),
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

      final prefs = await SharedPreferences.getInstance();
      final username = prefs.getString("username") ?? "";

      final request =
          http.MultipartRequest(
              "GET",
              Uri.parse("$sizeRecomUrl/$username/$productId"),
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
