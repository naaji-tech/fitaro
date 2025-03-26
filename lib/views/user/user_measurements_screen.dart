import 'package:fitaro/logger/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/user_measurement_controller.dart';
import 'dart:async';

class UserMeasurementScreenContent extends StatefulWidget {
  const UserMeasurementScreenContent({super.key});

  @override
  State<UserMeasurementScreenContent> createState() =>
      _UserMeasurementScreenContentState();
}

class _UserMeasurementScreenContentState
    extends State<UserMeasurementScreenContent> {
  final UserMeasurementController measurementController =
      Get.find<UserMeasurementController>();
  final TextEditingController _userHeightController = TextEditingController();

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
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                  title: Text("Take Photo"),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Get.back();
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
      builder:
          (context) => Container(
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter Your Height",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  margin: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "Enter your height in cm",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    controller: _userHeightController,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    logger.d("user height: ${_userHeightController.text}");
                    if (_userHeightController.text.isEmpty) {
                      Get.snackbar(
                        'Enter Height',
                        'Please enter a valid height greater than zero',
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        colorText: Colors.red,
                        duration: Duration(seconds: 2),
                      );
                      return;
                    }

                    if (double.parse(_userHeightController.text) == 0.0) {
                      Get.snackbar(
                        'Invalid Height',
                        'Please enter a valid height greater than zero',
                        backgroundColor: const Color.fromARGB(
                          255,
                          255,
                          255,
                          255,
                        ),
                        colorText: Colors.red,
                        duration: Duration(seconds: 2),
                      );
                      return;
                    }

                    Get.back();
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
    );
  }

  Future<void> _pickImage(ImageSource source) async {
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
        // add new user measurements
        measurementController.detectMeasurements(
          image,
          double.parse(_userHeightController.text),
        );

        Get.back();
        Get.snackbar(
          'Success',
          'Measurements updated successfully',
          backgroundColor: const Color.fromARGB(175, 134, 210, 137),
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
        backgroundColor: const Color.fromARGB(185, 173, 106, 102),
        colorText: const Color.fromARGB(255, 0, 0, 0),
        duration: Duration(seconds: 3),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          // Measurements or Empty State
          Expanded(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Obx(
                () =>
                    measurementController.measurements.isNotEmpty
                        ? SingleChildScrollView(
                          child: Column(
                            children:
                                measurementController.measurements.map((
                                  measurement,
                                ) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          measurement["name"]!
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
                                          "${double.parse(measurement["value"].toString()).round()} cm",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                          ),
                        )
                        : Center(
                          child: Text(
                            "No Measurements",
                            style: TextStyle(fontSize: 22, color: Colors.grey),
                          ),
                        ),
              ),
            ),
          ),
          SizedBox(height: 20),

          // New Measure Button
          ElevatedButton(
            onPressed: _showHeightInputOptions,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "New Measure",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
