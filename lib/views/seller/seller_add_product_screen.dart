import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SellerAddProductScreen extends StatefulWidget {
  const SellerAddProductScreen({super.key});

  @override
  State<SellerAddProductScreen> createState() => _SellerAddProductScreenState();
}

class _SellerAddProductScreenState extends State<SellerAddProductScreen> {
  final _productIdController = TextEditingController();
  final _productNameController = TextEditingController();
  final _productCategoryController = TextEditingController();
  final _productPriceController = TextEditingController();
  final _productDescriptionController = TextEditingController();
  final _productController = Get.find<ProductController>();
  final Map<String, String> _productDetails = {};

  String _convertLabelFunc(String label) {
    return label
        .replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[0]}')
        .trim()
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? '${word[0].toUpperCase()}${word.substring(1)}'
                  : '',
        )
        .join(' ');
  }

  Future<void> _uploadCloudImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        // Upload to cloud
        _productController.uploadImageToGoogleDrive(image);
        Get.snackbar(
          'Success',
          'Measurements updated successfully',
          backgroundColor: const Color.fromRGBO(0, 255, 0, 0.3),
          colorText: const Color.fromARGB(255, 3, 3, 3),
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      String errorMessage = 'Could not access camera. Please try again.';

      if (e.toString().contains('timeout')) {
        errorMessage = 'Operation timed out. Please try again.';
      } else if (e.toString().contains('permission')) {
        errorMessage =
            'Permission denied. Please check app permissions in settings.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: const Color.fromRGBO(255, 0, 0, 0.3),
        colorText: const Color.fromARGB(255, 0, 0, 0),
        duration: Duration(seconds: 3),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeadingAppBar(
        heading: "Add Product",
        onPressed: () {
          Get.offAllNamed("/seller-home");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("productId"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _productIdController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("productName"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _productNameController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("productCategory"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                controller: _productCategoryController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("productPrice"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _productPriceController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  label: Text(_convertLabelFunc("productDescription")),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
                controller: _productDescriptionController,
              ),
              SizedBox(height: 16),
              Container(
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.black),
                ),
                child: ListTile(
                  leading: Icon(
                    Icons.upload_file_outlined,
                    color: Colors.black,
                  ),
                  title: Text(
                    "Upload Image",
                    style: TextStyle(color: Colors.black),
                  ),
                  onTap: () => _uploadCloudImage(ImageSource.gallery),
                ),
              ),
              SizedBox(height: 40),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _productDetails['productId'] =
                            _productIdController.text;
                        _productDetails['productName'] =
                            _productNameController.text;
                        _productDetails['productCategory'] =
                            _productCategoryController.text;
                        _productDetails['productPrice'] =
                            _productPriceController.text;
                        _productDetails['productDescription'] =
                            _productDescriptionController.text;
                        _productDetails['productImageUrl'] =
                            _productController.uploadedImageUrl.value;
                        _productController;
                        Get.toNamed(
                          '/seller-add-product-sizes',
                          arguments: _productDetails,
                        );
                      },
                      icon: Icon(Icons.edit_document, size: 25),
                      label: Text("Manual", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed('/seller-add-product-scan'),
                      icon: Icon(Icons.camera_alt, size: 25),
                      label: Text("Scan", style: TextStyle(fontSize: 18)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
