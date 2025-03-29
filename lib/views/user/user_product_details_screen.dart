import 'package:fitaro/controllers/recommend_size_controller.dart';
import 'package:fitaro/controllers/user_measurement_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:fitaro/widgets/custom_buttons.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:fitaro/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class UserProductDetailsScreen extends StatefulWidget {
  const UserProductDetailsScreen({super.key});

  @override
  State<UserProductDetailsScreen> createState() =>
      _UserProductDetailsScreenState();
}

class _UserProductDetailsScreenState extends State<UserProductDetailsScreen> {
  final sizeRecomController = Get.find<RecommendSizeController>();
  final userMeasurementController = Get.find<UserMeasurementController>();
  final TextEditingController _userHeightController = TextEditingController();
  final product =
      Get.arguments ??
      {
        "productId": "",
        "productName": "",
        "productPrice": "",
        "productImageUrl": "",
        "productDescription": "",
      };

  Future<void> _getRecommendedSizeByOldMeasurement() async {
    try {
      await sizeRecomController.fetchSizeRecomByOldMesurement(
        product["productId"],
      );

      Get.back(closeOverlays: true);
      if (sizeRecomController.hasGotRecommendSize.value) {
        SuccesSnackbar.show(
          title: 'Success',
          message: 'Measurements updated successfully',
        );
      } else {
        ErrorSnackbar.show(
          title: 'Internal Error',
          message: "Contact support: mohamednaaji@yahoo.com",
        );
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      String errorMessage = 'Could not access camera. Please try again.';
      ErrorSnackbar.show(title: 'Error', message: errorMessage);
      Get.back(closeOverlays: true);
    }
  }

  Future<void> _getRecommendedSize(ImageSource source) async {
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
        await sizeRecomController.fetchSizeRecomByMesureMe(
          image,
          double.parse(_userHeightController.text),
          product["productId"],
        );

        Get.back(closeOverlays: true);
        if (sizeRecomController.hasGotRecommendSize.value) {
          SuccesSnackbar.show(
            title: 'Success',
            message: 'Measurements updated successfully',
          );
        } else {
          ErrorSnackbar.show(
            title: 'Internal Error',
            message: 'Contact support: mohamednaaji@yahoo.com',
          );
        }
      }
    } catch (e) {
      logger.d('Error picking image: $e');
      String errorMessage = 'Could not access camera. Please try again.';

      ErrorSnackbar.show(title: 'Error', message: errorMessage);
      Get.back(closeOverlays: true);
    }
  }

  void _showMeasurementOptions() {
    logger.i("user measurement: ${_userHeightController.text}");
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
                    Icons.photo_library,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text("Upload from Gallery"),
                  onTap: () => _getRecommendedSize(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text("Take Photo"),
                  onTap: () => _getRecommendedSize(ImageSource.camera),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back(closeOverlays: true);
                    _showHeightInputOptions();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    "Back",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
    );
  }

  void _showHeightInputOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled:
          true, // Allow the modal to adjust for keyboard and content
      builder:
          (context) => SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 40,
                right: 40,
                top: 30,
                bottom: MediaQuery.of(context).viewInsets.bottom + 30,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Enter Your Height",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your height in cm",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: _userHeightController,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      logger.d("user height: ${_userHeightController.text}");
                      if (_userHeightController.text.isEmpty) {
                        WarningSnackbar.show(
                          title: 'Enter Height',
                          message:
                              'Please enter a valid height greater than zero',
                        );
                        return;
                      }

                      if (double.parse(_userHeightController.text) == 0.0) {
                        WarningSnackbar.show(
                          title: 'Invalid Height',
                          message:
                              'Please enter a valid height greater than zero',
                        );
                        return;
                      }

                      Get.back(closeOverlays: true);
                      _showMeasurementOptions();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Next",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showMesureInputOption() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () =>
                      userMeasurementController.hasMeasurements.value
                          ? Column(
                            children: [
                              MyButtonBlackFull(
                                text: "From Old Measurement",
                                onPressed: _getRecommendedSizeByOldMeasurement,
                              ),
                              SizedBox(height: 20),
                            ],
                          )
                          : SizedBox(),
                ),

                MyButtonBlackFull(
                  text: "Measure Now",
                  onPressed: () {
                    Get.back(closeOverlays: true);
                    _showHeightInputOptions();
                  },
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyHeadingAppBar(
        heading: product["productName"],
        onPressed: () async {
          await sizeRecomController.clearSizeRecom();
          await userMeasurementController.loadMeasurements();
          Get.back(closeOverlays: true);
        },
        headingSize: 20,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Content
          Expanded(
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
                          "LKR ${double.parse(product["productPrice"].toString()).toStringAsFixed(2)}",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),

                        // Product Features
                        Text(
                          product["productDescription"].toString().split(
                            "*",
                          )[0],
                          style: TextStyle(fontSize: 18, height: 1.5),
                        ),
                        Text(
                          product["productDescription"].toString().split(
                            "*",
                          )[1],
                          style: TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 35),

                        // Recommended Size or Fit Check Button
                        Obx(
                          () =>
                              sizeRecomController.hasGotRecommendSize.value
                                  ? Container(
                                    padding: EdgeInsets.all(12),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Color.fromRGBO(76, 175, 80, 0.1),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: Color.fromRGBO(76, 175, 80, 0.1),
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Recommended Size",
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8),
                                        Text(
                                          sizeRecomController
                                              .recommendSize
                                              .value,
                                          style: TextStyle(
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          "Based on your measurements",
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.green.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : MyButtonBlackFull(
                                    text: "Find my size",
                                    onPressed: _showMesureInputOption,
                                  ),
                        ),
                        SizedBox(height: 15),

                        MyButtonBlackFull(
                          onPressed: () {
                            InfoSnackbar.show(
                              title: "Coming Soon",
                              message:
                                  'Added to cart feature will be available soon!',
                            );
                          },
                          text: "Add to Cart",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
