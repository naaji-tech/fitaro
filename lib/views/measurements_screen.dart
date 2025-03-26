import 'package:fitaro/logger/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitaro/widgets/base_screen_layout.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> {
  final Map<String, String> measurements = {
    "Neck": "16 cm",
    "Chest": "62 cm",
    "Shoulder Width": "72 cm",
    "Arm Length": "32 cm",
    "Bicep": "42 cm",
    "wrist": "17 cm",
    "length": "78 cm",
  };

  bool hasMeasurements = true; // Toggle this to show/hide measurements

  void _showMeasurementOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (context) => Container(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Choose Measurement Method",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                ListTile(
                  leading: Icon(Icons.photo_library, color: Colors.blue),
                  title: Text("Upload from Gallery"),
                  onTap: () => _pickImage(ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.green),
                  title: Text("Take Photo"),
                  onTap: () => _pickImage(ImageSource.camera),
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    try {
      // Configure image picker with lower quality and smaller max dimensions
      final XFile? image = await picker
          .pickImage(
            source: source,
            imageQuality: 70, // Lower quality to reduce processing load
            maxWidth: 1024, // Limit image dimensions
            maxHeight: 1024,
            preferredCameraDevice: CameraDevice.rear,
          )
          .timeout(
            Duration(seconds: 30), // Add timeout
            onTimeout: () {
              throw TimeoutException('Image picking took too long');
            },
          );

      if (image != null) {
        // Process the image and update measurements
        setState(() {
          hasMeasurements = true;
        });

        // if (Navigator.canPop(context)) {
        //   Navigator.pop(context); // Close bottom sheet only if it's open
        // }

        Get.back(); // Close bottom sheet

        // Show success message
        Get.snackbar(
          'Success',
          'Image captured successfully',
          backgroundColor: const Color.fromRGBO(76, 175, 80, 0.1),
          colorText: Colors.green,
          duration: Duration(seconds: 2),
        );
      }
    } catch (e) {
      logger.i('Error picking image: $e');

      // More specific error messages
      String errorMessage =
          'Could not access camera. Please try again or use gallery.';
      if (e.toString().contains('timeout')) {
        errorMessage = 'Operation timed out. Please try again.';
      } else if (e.toString().contains('permission')) {
        errorMessage =
            'Permission denied. Please check app permissions in settings.';
      }

      Get.snackbar(
        'Error',
        errorMessage,
        backgroundColor: const Color.fromRGBO(244, 67, 54, 0.1),
        colorText: Colors.red,
        duration: Duration(seconds: 3),
      );

      // if (Navigator.canPop(context)) {
      //   Navigator.pop(context); // Close bottom sheet if error occurs
      // }

      Get.back(); // Close bottom sheet
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentIndex: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            // Title & Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Measurements",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.shopping_basket_outlined, size: 28),
              ],
            ),
            SizedBox(height: 20),

            // Measurements or Empty State
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    hasMeasurements
                        ? Column(
                          children:
                              measurements.entries.map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        entry.key,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        entry.value,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                        )
                        : Center(
                          child: Text(
                            "No Measurements",
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ),
              ),
            ),
            SizedBox(height: 20),

            // New Measure Button
            ElevatedButton(
              onPressed: _showMeasurementOptions,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                minimumSize: Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text("New Measure", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
