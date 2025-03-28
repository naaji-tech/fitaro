import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:fitaro/widgets/custom_buttons.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SellerAddSizesScreen extends StatefulWidget {
  const SellerAddSizesScreen({super.key});

  @override
  State<SellerAddSizesScreen> createState() => _SellerAddSizesScreenState();
}

class _SellerAddSizesScreenState extends State<SellerAddSizesScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final _productDetails = Get.arguments ?? {};
  final _productSizes = ["XS", "S", "M", "L", "XL"];
  bool _hasAtleastOneSize = false;

  @override
  Widget build(BuildContext context) {
    final measurementMethod = _productController.productUploadMethod.value;

    if (_productDetails.isNotEmpty) {
      logger.i("Product details is not empty");
      _productController.addProductData(_productDetails);
    }

    logger.d("Product details: ${_productController.productData}");
    logger.d(
      "Product measurement data: ${_productController.productMeasurementData}",
    );
    logger.d("Product images: ${_productController.productImages}");
    logger.d("Product measurement method: $measurementMethod");

    return Scaffold(
      appBar: MyHeadingAppBar(
        heading: "Add Sizes",
        onPressed: () async {
          await _productController.clearProductMeasurementData();
          await _productController.clearProductImages();
          await Get.offNamed("/seller-add-product");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == _productSizes[0],
                  )
                  ? MyProductSizeButtonBlack(text: _productSizes[0])
                  : MyProductSizeButtonGrey(
                    text: _productSizes[0],
                    onPressed: () {
                      measurementMethod == "manual"
                          ? Get.toNamed(
                            "/seller-add-product-manual",
                            arguments: _productSizes[0],
                          )
                          : _showMeasurementOptions(_productSizes[0]);
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == _productSizes[1],
                  )
                  ? MyProductSizeButtonBlack(text: _productSizes[1])
                  : MyProductSizeButtonGrey(
                    text: _productSizes[1],
                    onPressed: () {
                      if (!_hasAtleastOneSize) _hasAtleastOneSize = true;
                      measurementMethod == "manual"
                          ? Get.toNamed(
                            "/seller-add-product-manual",
                            arguments: _productSizes[1],
                          )
                          : _showMeasurementOptions(_productSizes[1]);
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == _productSizes[2],
                  )
                  ? MyProductSizeButtonBlack(text: _productSizes[2])
                  : MyProductSizeButtonGrey(
                    text: _productSizes[2],
                    onPressed: () {
                      if (!_hasAtleastOneSize) _hasAtleastOneSize = true;
                      measurementMethod == "manual"
                          ? Get.toNamed(
                            "/seller-add-product-manual",
                            arguments: _productSizes[2],
                          )
                          : _showMeasurementOptions(_productSizes[2]);
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == _productSizes[3],
                  )
                  ? MyProductSizeButtonBlack(text: _productSizes[3])
                  : MyProductSizeButtonGrey(
                    text: _productSizes[3],
                    onPressed: () {
                      if (!_hasAtleastOneSize) _hasAtleastOneSize = true;
                      measurementMethod == "manual"
                          ? Get.toNamed(
                            "/seller-add-product-manual",
                            arguments: _productSizes[3],
                          )
                          : _showMeasurementOptions(_productSizes[3]);
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == _productSizes[4],
                  )
                  ? MyProductSizeButtonBlack(text: _productSizes[4])
                  : MyProductSizeButtonGrey(
                    text: _productSizes[4],
                    onPressed: () {
                      if (!_hasAtleastOneSize) _hasAtleastOneSize = true;
                      measurementMethod == "manual"
                          ? Get.toNamed(
                            "/seller-add-product-manual",
                            arguments: _productSizes[4],
                          )
                          : _showMeasurementOptions(_productSizes[4]);
                    },
                  ),

              SizedBox(height: 60),

              MyButtonBlackFull(
                text: "Submit",
                onPressed: () async {
                  if (_hasAtleastOneSize) {
                    logger.i("Submit pressed.");
                    if (measurementMethod == "manual") {
                      logger.i("Adding product and measurements manually.");
                      await _productController
                          .addProductAndMeasurementsManual();
                    } else {
                      logger.i(
                        "Adding product and measurements automatically.",
                      );
                      await _productController.addProductAndMeasurementsScan();
                    }
                    await _productController.clearProductData();
                    await _productController.clearProductImages();
                    await _productController.clearProductMeasurementData();
                    await _productController.fetchProducts();
                    await Get.offAllNamed("/seller-home");
                  } else {
                    ErrorSnackbar.show(
                      title: "Required",
                      message: "Please add at least one size.",
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMeasurementOptions(String size) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Measurement Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(
                    Icons.photo_library_outlined,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text("Upload from Gallery"),
                  onTap: () => _pickImage(size, ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt_outlined,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text("Take Photo"),
                  onTap: () => _pickImage(size, ImageSource.camera),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(String size, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1024,
        maxHeight: 1024,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        logger.d("size: $size, filename: $image");
        await _productController.addProductImage(size, image);

        setState(() {
          _productController.addProductMeasurementData({
            "productSize": size,
          });
        });

        logger.d(_productController.productImages.toString());

        Get.back();
        SuccesSnackbar.show(
          title: 'Success',
          message: 'Image uploaded successfully',
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

      Get.back();
      ErrorSnackbar.show(title: 'Error', message: errorMessage);
    }
  }
}
