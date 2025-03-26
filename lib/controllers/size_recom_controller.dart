import 'dart:convert';
import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SizeRecomController extends GetxController {
  var sizeRecom = ''.obs;
  var hasGotSizeRecom = false.obs;

  void setSizeRecom(String size, bool hasSizeRecom) {
    sizeRecom.value = size;
    hasGotSizeRecom.value = hasSizeRecom;
  }

  void clearSizeRecom() {
    sizeRecom.value = '';
    hasGotSizeRecom.value = false;
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

      sizeRecom.value = resBody["data"]["recommendSize"];
      hasGotSizeRecom.value = true;

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

      sizeRecom.value = resBody["data"]["recommendSize"];
      hasGotSizeRecom.value = true;

      logger.d("recommendSize: ${sizeRecom.value}");
      logger.i('Size recommendation fetched successfully');
    } catch (e) {
      logger.e('Exception occurred: $e');
    }
  }
}
