import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BackendServerController extends GetxController {
  var isServerConnected = false.obs;
  var isServerConnectionFailed = false.obs;

  @override
  void onInit() {
    super.onInit();
    checkServerConnection();
  }

  Future<void> checkServerConnection() async {
    try {
      logger.i('Checking server connection...');
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        isServerConnected.value = true;
      } else {
        logger.e('Failed to connect to server: ${response.body}');
        isServerConnectionFailed.value = true;
      }
      logger.d("Server connection status: ${response.body}");
    } catch (e) {
      isServerConnected.value = false;
    }
  }
}