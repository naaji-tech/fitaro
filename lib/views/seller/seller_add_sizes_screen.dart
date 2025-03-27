import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:fitaro/widgets/custom_buttons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAddSizesScreen extends StatefulWidget {
  const SellerAddSizesScreen({super.key});

  @override
  State<SellerAddSizesScreen> createState() => _SellerAddSizesScreenState();
}

class _SellerAddSizesScreenState extends State<SellerAddSizesScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final _productDetails = Get.arguments ?? {};

  @override
  Widget build(BuildContext context) {
    if (_productDetails.isNotEmpty) {
      logger.i("Product details is not empty");
      _productController.addProductData(_productDetails);
    }

    logger.i("Product details: ${_productController.productData.toString()}");

    logger.i(
      "Product measurement data: ${_productController.productMeasurementData.toString()}",
    );
    return Scaffold(
      appBar: MyHeadingAppBar(
        heading: "Sizes",
        onPressed: () {
          Get.offNamed("/seller-add-product");
          _productController.clearProductMeasurementData();
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == "XS",
                  )
                  ? MyButtonBlack(
                    text: 'XS',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed(
                        "/seller-add-product-manual",
                        arguments: "XS",
                      );
                    },
                  )
                  : MyButtonGrey(
                    text: 'XS',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed(
                        "/seller-add-product-manual",
                        arguments: "XS",
                      );
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == "S",
                  )
                  ? MyButtonBlack(
                    text: 'S',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "S");
                    },
                  )
                  : MyButtonGrey(
                    text: 'S',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "S");
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == "M",
                  )
                  ? MyButtonBlack(
                    text: 'M',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "M");
                    },
                  )
                  : MyButtonGrey(
                    text: 'M',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "M");
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == "L",
                  )
                  ? MyButtonBlack(
                    text: 'L',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "L");
                    },
                  )
                  : MyButtonGrey(
                    text: 'L',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed("/seller-add-product-manual", arguments: "L");
                    },
                  ),

              SizedBox(height: 16),

              _productController.productMeasurementData.any(
                    (item) => item["productSize"] == "XL",
                  )
                  ? MyButtonBlack(
                    text: 'XL',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed(
                        "/seller-add-product-manual",
                        arguments: "XL",
                      );
                    },
                  )
                  : MyButtonGrey(
                    text: 'XL',
                    onPressed: () {
                      logger.i("Product details: $_productDetails");
                      Get.toNamed(
                        "/seller-add-product-manual",
                        arguments: "XL",
                      );
                    },
                  ),
              SizedBox(height: 60),

              MyButtonBlackFull(
                text: "Submit",
                onPressed: () {
                  logger.i("Submit pressed.");
                  _productController.addProductAndMeasurementsManual();
                  _productController.clearProductData();
                  _productController.clearProductMeasurementData();
                  _productController.fetchProducts();
                  Get.offAllNamed("/seller-home");
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
