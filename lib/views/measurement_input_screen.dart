import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/base_screen_layout.dart';
import '../controllers/user_measurement_controller.dart';

class MeasurementInputScreen extends StatefulWidget {
  const MeasurementInputScreen({super.key});

  @override
  State<MeasurementInputScreen> createState() => _MeasurementInputScreenState();
}

class _MeasurementInputScreenState extends State<MeasurementInputScreen> {
  final UserMeasurementController measurementController =
      Get.find<UserMeasurementController>();

  @override
  Widget build(BuildContext context) {
    return BaseScreenLayout(
      currentIndex: 2, // Camera/Measurements tab
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Measurements",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 28),
                    onPressed:
                        () => {}, //measurementController.clearMeasurements(),
                  ),
                ],
              ),
            ),

            // Measurements Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Obx(
                  () =>
                      measurementController.measurements.isNotEmpty
                          ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(
                                    158,
                                    158,
                                    158,
                                    0.1,
                                  ),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: ListView.separated(
                              itemCount:
                                  measurementController.measurements.length,
                              separatorBuilder:
                                  (context, index) => Divider(height: 20),
                              itemBuilder: (context, index) {
                                final measurement =
                                    measurementController.measurements[index];
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      measurement["name"]!,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      measurement["value"]!,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                          : Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color.fromRGBO(
                                    158,
                                    158,
                                    158,
                                    0.1,
                                  ),
                                  blurRadius: 5,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "No Measurements",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                ),
              ),
            ),

            // Bottom Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // measurementController.addDefaultMeasurements();
                      Get.offAllNamed('/shop');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text("New Measure", style: TextStyle(fontSize: 16)),
                  ),
                  if (measurementController.measurements.isNotEmpty) ...[
                    SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => Get.offAllNamed('/shop'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Confirm Size",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
