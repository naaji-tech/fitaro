import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/controllers/product_measurement_controller.dart';
import 'package:fitaro/widgets/custom_buttons.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:fitaro/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerProductDetailsScreen extends StatefulWidget {
  const SellerProductDetailsScreen({super.key});

  @override
  State<SellerProductDetailsScreen> createState() =>
      _SellerProductDetailsScreenState();
}

class _SellerProductDetailsScreenState
    extends State<SellerProductDetailsScreen> {
  final _productMeasurementController =
      Get.find<ProductMeasurementController>();
  final _productController = Get.find<ProductController>();
  final product =
      Get.arguments ??
      {
        "productId": "",
        "productName": "",
        "productPrice": "",
        "productImageUrl": "",
        "productDescription": "",
      };

  @override
  void initState() {
    super.initState();
    _productMeasurementController.getProductMeasurements(product["productId"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black, size: 40),
            onPressed: () async {
              await _productMeasurementController.clearMeasurements();
              Get.back(closeOverlays: true);
            },
          ),
        ),
        actions: [
          Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 40),
          SizedBox(width: 40),
        ],
      ),
      body: Scrollbar(
        thumbVisibility: true,
        thickness: 8,
        radius: Radius.circular(10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              // Product Image
              Container(
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                color: Colors.grey[100],
                child: Center(
                  child: NetworkImageWidget(
                    imageUrl: product["productImageUrl"],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Product Details
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product["productName"],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "LKR ${double.parse(product["productPrice"].toString()).toStringAsFixed(2)}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),

                    // Product Features
                    Text(
                      product["productDescription"].toString().split("*")[0],
                      style: TextStyle(fontSize: 18, height: 1.5),
                    ),
                    Text(
                      product["productDescription"].toString().split("*")[1],
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),

              // Dynamic Text Widgets from List
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Size Chart",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Obx(
                        () =>
                            _productMeasurementController
                                    .hasProductMeasurements
                                    .value
                                ? _showProductSize()
                                : Text(
                                  "Size chart not available",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButtonBlackFull(
                        text: "Delete",
                        onPressed: () {
                          _confirmDeleteOptions(product["productName"]);
                        },
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: MyButtonBlackFull(
                        text: "Update",
                        onPressed: () {
                          InfoSnackbar.show(
                            title: "Coming Soon",
                            message: "Update Feature coming soon",
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Column _showProductSize() {
    return Column(
      children: [
        ..._productMeasurementController.productMeasurements.map(
          (feature) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Column(
              children: [
                Text(
                  feature["productSize"],
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
                ...feature.entries
                    .where((entry) => entry.key != "productSize")
                    .map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${entry.key}"
                                  .replaceAllMapped(
                                    RegExp(r'([A-Z])'),
                                    (m) => ' ${m[0]}',
                                  )
                                  .trim()
                                  .split(' ')
                                  .map(
                                    (word) =>
                                        word.isNotEmpty
                                            ? '${word[0].toUpperCase()}${word.substring(1)}'
                                            : '',
                                  )
                                  .join(' '),
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              "${double.parse(entry.value.toString()).round()} cm",
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
                SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDeleteOptions(String size) {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Are you sure?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: MyButtonBlackFull(
                        text: "Cancel",
                        onPressed: () => Get.back(),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: MyButtonGreyFull(
                        text: "Yes",
                        onPressed: () async {
                          await _productMeasurementController
                              .deleteProductMeasurements(product["productId"]);
                          await _productController.deleteProduct(
                            product["productId"],
                          );
                          await _productController.fetchProducts();
                          await Get.offAllNamed("/seller-home");
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }
}
