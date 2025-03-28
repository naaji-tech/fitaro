import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:fitaro/widgets/custom_text_fields.dart';
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
  var _isImageUploadSuccess = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeadingAppBar(
        heading: "Add Product",
        onPressed: () {
          _productIdController.dispose();
          _productNameController.dispose();
          _productCategoryController.dispose();
          _productPriceController.dispose();
          _productDescriptionController.dispose();
          Get.offAllNamed("/seller-home");
        },
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8,
        radius: Radius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 30),
                MyTextField(
                  labelText: _convertLabelFunc("productId"),
                  controller: _productIdController,
                ),
                SizedBox(height: 20),
                MyTextField(
                  labelText: _convertLabelFunc("productName"),
                  controller: _productNameController,
                ),
                SizedBox(height: 20),
                MyDropdownButtonFormField(
                  labelText: _convertLabelFunc("productCategory"),
                  items: [
                    DropdownMenuItem(
                      value: "Half Sleeve T-Shirt",
                      child: Text("Half Sleeve T-Shirt"),
                    ),
                    DropdownMenuItem(
                      value: "Full Sleeve T-Shirt",
                      child: Text("Full Sleeve T-Shirt"),
                    ),
                    DropdownMenuItem(value: "Shirt", child: Text("Shirt")),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _productCategoryController.text = value ?? '';
                    });
                  },
                ),
                SizedBox(height: 20),
                MyTextField(
                  labelText: _convertLabelFunc("productPrice"),
                  controller: _productPriceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                MyTextArea(
                  labelText: _convertLabelFunc("productDescription"),
                  controller: _productDescriptionController,
                  maxLines: 3,
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(bottom: 0),
                  decoration: BoxDecoration(
                    border:
                        _isImageUploadSuccess
                            ? Border.all(width: 2, color: Colors.green)
                            : Border.all(width: 2, color: Colors.grey.shade300),
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
                    onTap: () => _uploadCloudImage(),
                  ),
                ),
                SizedBox(height: 50),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _productController.productUploadMethod.value =
                              'manual';
                          callProductSizeScreen();
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
                        onPressed: () {
                          _productController.productUploadMethod.value = 'scan';
                          callProductSizeScreen();
                        },
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
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  void callProductSizeScreen() {
    if (_productIdController.text.isEmpty ||
        _productNameController.text.isEmpty ||
        _productCategoryController.text.isEmpty ||
        _productPriceController.text.isEmpty ||
        _productDescriptionController.text.isEmpty ||
        _productController.uploadedImageUrl.value.isEmpty) {
      ErrorSnackbar.show(
        title: 'Required',
        message: 'Please fill all fields and upload an image',
      );
      return;
    }

    _productDetails['productId'] = _productIdController.text;
    _productDetails['productName'] = _productNameController.text;
    _productDetails['productCategory'] = _productCategoryController.text;
    _productDetails['productPrice'] = _productPriceController.text;
    _productDetails['productDescription'] = _productDescriptionController.text;
    _productDetails['productImageUrl'] =
        _productController.uploadedImageUrl.value;
    Get.toNamed('/seller-add-product-sizes', arguments: _productDetails);
  }

  Future<void> _uploadCloudImage() async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (image != null) {
        // Upload to cloud
        await _productController.uploadImageToGoogleDrive(image);
        if (_productController.uploadedImageUrl.value == "") {
          ErrorSnackbar.show(
            title: 'Error',
            message: 'Could not upload image. Please try again.',
          );
        } else {
          SuccesSnackbar.show(
            title: 'Success',
            message: 'Image uploaded successfully',
          );
          setState(() {
            _isImageUploadSuccess = true;
          });
        }
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

      ErrorSnackbar.show(title: 'Error', message: errorMessage);
      Get.back();
    }
  }
}
