import 'dart:io';

import 'package:fitaro/logger/log.dart';
import 'package:fitaro/util/api_config.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:path/path.dart';

import 'package:image_picker/image_picker.dart';

class ProductController extends GetxController {
  var isLoading = true.obs;
  var productList = [].obs;

  var productUploadMethod = ''.obs;
  var productData = {}.obs;
  var uploadedImageUrl = ''.obs;
  var productMeasurementData = [].obs;
  var productImages = [].obs;
  var sizes = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> addProductImage(String size, XFile image) async {
    productImages.add(image);
    sizes.value += "$size,";
  }

  Future<void> clearProductImages() async {
    productImages.clear();
    sizes.value = '';
  }

  Future<void> addProductData(dynamic data) async {
    productData.assignAll(data);
  }

  Future<void> clearProductData() async {
    productData.clear();
  }

  Future<void> addProductMeasurementData(dynamic value) async {
    productMeasurementData.add(value);
  }

  Future<void> clearProductMeasurementData() async {
    productMeasurementData.clear();
  }

  Future<void> deleteProduct(String productId) async {
    try {
      logger.i('Deleting product with ID: $productId...');
      final url = '$productUrl/$productId';
      logger.d("url: $url");

      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == HttpStatus.ok) {
        logger.i('Product deleted successfully.');
        SuccesSnackbar.show(
          title: "Success",
          message: "Product deleted successfully",
        );
        fetchProducts();
      } else {
        logger.e('Failed to delete product: ${response.body}');
        ErrorSnackbar.show(title: "Error", message: "Failed to delete product");
      }
    } catch (e) {
      logger.e('Exception occurred while deleting product: $e');
      ErrorSnackbar.show(
        title: "Internal Error",
        message: "Contact support: mohamednaaji@yahoo.com",
      );
    }
  }

  Future<void> addProductAndMeasurementsScan() async {
    try {
      logger.i('Adding product and measurements via scan...');
      logger.d("Product details: $productData");
      logger.d("Product images data: $productImages");
      logger.d("Product sizes: $sizes");

      final res = await http.post(
        Uri.parse(productUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(productData),
      );

      var resBody = json.decode(res.body);

      if (res.statusCode != HttpStatus.created) {
        logger.e('Failed to add product: $resBody');
        ErrorSnackbar.show(
          title: "Internal Error",
          message: "Contact support: mohamednaaji@yahoo.com",
        );
        return;
      }

      logger.i("product added success");
      SuccesSnackbar.show(
        title: "Success",
        message: "Product measurements added successfully",
      );

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$productMeasurementScanUrl${productData['productId']}'),
      );

      for (XFile image in productImages) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'images', // <- Same key for all files
            image.path,
            filename: basename(image.path),
          ),
        );
      }

      request.fields['sizes'] = sizes.value;

      var res2 = await request.send();
      var res2Body = await res2.stream.bytesToString();

      if (res2.statusCode != HttpStatus.created) {
        logger.e('Failed in product images scanning: $res2Body');
        ErrorSnackbar.show(
          title: "Error",
          message: "Failed to add product measurements",
        );
        return;
      }

      logger.i('Product and measurements added successfully: $res2Body');
      SuccesSnackbar.show(
        title: "Success",
        message: "Product measurements added successfully",
      );
    } catch (e) {
      logger.e('Exception occurred: $e');
      ErrorSnackbar.show(
        title: "Internal Error",
        message: "Contact support: mohamednaaji@yahoo.com",
      );
    }
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
        ErrorSnackbar.show(
          title: "Internal Error",
          message: "Contact support: mohamednaaji@yahoo.com",
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
        ErrorSnackbar.show(
          title: "Internal Error",
          message: "Contact support: mohamednaaji@yahoo.com",
        );
        return;
      }

      SuccesSnackbar.show(
        title: "Success",
        message: "Product added to Inventory",
      );
      logger.i('Adding product and measurements success.');
    } catch (e) {
      logger.e('Exception occurred: $e');
      ErrorSnackbar.show(
        title: "Internal Error",
        message: "Contact support: mohamednaaji@yahoo.com",
      );
    }
  }

  Future<void> uploadImageToGoogleDrive(XFile imageFile) async {
    try {
      isLoading(true);
      logger.i('Uploading image to Google Drive...');

      // put this url for the testing purpose
      if (imageFile != null) {
        uploadedImageUrl.value =
            'https://drive.google.com/uc?export=view&id=14z9IasMbPwHFNYAzxUeC6X9bMgQdMnBu';
        return;
      }

      final String googleDriveApiUrl =
          'https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart';
      final String accessToken =
          'PUT_ACCESS_TOKEN_HERE';

      var request = http.MultipartRequest('POST', Uri.parse(googleDriveApiUrl));
      request.headers['Authorization'] = 'Bearer $accessToken';
      request.fields['name'] = imageFile.name;
      request.fields['parents'] =
          '["PUT_FOLDER_ID_HERE"]';
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
      ErrorSnackbar.show(title: "Error", message: "Failed to upload image");
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

  Future<void> clearProducts() async {
    productList.clear();
    logger.i("Clear product success.");
  }
}
