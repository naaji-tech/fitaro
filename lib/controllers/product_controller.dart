import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = [].obs;
  var uploadedImageUrl = ''.obs;

  var productMeasurementData = [].obs;
  var productData = {}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void addProductData(dynamic data) {
    productData.assignAll(data);
  }

  void clearProductData() {
    productData.clear();
  }

  void addProductMeasurementData(dynamic value) {
    productMeasurementData.add(value);
  }

  void clearProductMeasurementData() {
    productMeasurementData.clear();
  }

  Future<void> addProductAndMeasurementsManual() async {
    try {
      logger.i('Adding product and measurements manually...');
      logger.d("Product details: ${productData.toString()}");
      logger.d(
        "Product measurements data: ${productMeasurementData.toString()}",
      );

      final res = await http.post(
        Uri.parse(productUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productData),
      );

      var resBody = json.decode(res.body);

      if (res.statusCode != HttpStatus.created) {
        logger.e('Failed to add product: ${resBody.toString()}');
        Get.snackbar(
          'Error',
          'Internal error: contact support: mohamednaaji@yahoo.com',
          backgroundColor: const Color.fromRGBO(255, 0, 0, 0.3),
          colorText: const Color.fromARGB(255, 0, 0, 0),
          duration: Duration(seconds: 3),
        );
        return;
      }

      String url2 = "$productMeasurementMenualUrl${productData['productId']}";
      logger.d("url2: $url2");

      final res2 = await http.post(
        Uri.parse(url2),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productMeasurementData),
      );

      var resBody2 = json.decode(res.body);

      if (res2.statusCode != HttpStatus.created) {
        logger.e('Failed to add measurements: ${resBody2.toString()}');
        Get.snackbar(
          'Error',
          'Internal error: contact support: mohamednaaji@yahoo.com',
          backgroundColor: const Color.fromRGBO(255, 0, 0, 0.3),
          colorText: const Color.fromARGB(255, 0, 0, 0),
          duration: Duration(seconds: 3),
        );
        return;
      }

      Get.snackbar(
        'Success',
        'Product added to Inventory',
        backgroundColor: const Color.fromRGBO(0, 255, 0, 0.3),
        colorText: const Color.fromARGB(255, 0, 0, 0),
        duration: Duration(seconds: 1),
      );
      logger.i('Adding product and measurements success.');
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

  Future<void> uploadImageToGoogleDrive(XFile imageFile) async {
    try {
      isLoading(true);
      logger.i('Uploading image to Google Drive...');

      // Replace with your Google Drive API endpoint and access token
      final String googleDriveApiUrl =
          'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';
      final String accessToken =
          'YOUR_ACCESS_TOKEN_HERE'; // Replace with your access token

      // Prepare the request
      var request = http.MultipartRequest('POST', Uri.parse(googleDriveApiUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['name'] = imageFile.name; // Set the file name
      request.fields['parents'] =
          '["YOUR_FOLDER_ID_HERE"]'; // Replace with your folder ID
      request.files.add(
        await http.MultipartFile.fromPath('file', imageFile.path),
      );

      // Send the request
      var response = await request.send();

      if (response.statusCode == HttpStatus.ok) {
        // Parse the response to get the file ID
        var responseBody = await response.stream.bytesToString();
        var jsonResponse = json.decode(responseBody);
        String fileId = jsonResponse['id'];

        // Generate a shared URL
        final shareResponse = await http.post(
          Uri.parse(
            'https://www.googleapis.com/drive/v3/files/$fileId/permissions',
          ),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: json.encode({'role': 'reader', 'type': 'anyone'}),
        );

        if (shareResponse.statusCode == HttpStatus.ok) {
          uploadedImageUrl.value = 'https://drive.google.com/uc?id=$fileId';
          logger.i('Image uploaded successfully: $uploadedImageUrl');
        } else {
          logger.e('Failed to set sharing permissions');
        }
      } else {
        logger.e('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      logger.e('Exception occurred during image upload: $e');
      Get.snackbar(
        'Error',
        'Failed to upload image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color.fromRGBO(255, 0, 0, 0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchProducts() async {
    isLoading(true);
    try {
      logger.i('Fetching products...');
      final response = await http.get(Uri.parse(productUrl));

      if (response.statusCode != HttpStatus.ok) {
        return;
      }

      var jsonData = json.decode(response.body);
      productList.assignAll(jsonData["data"]);

      logger.i('Fetching products success.');
    } catch (e) {
      logger.e('Exception occurred: $e');
    } finally {
      isLoading(false);
    }
  }

  void clearProducts() {
    productList.clear();
    logger.i("Clear product success.");
  }
}
