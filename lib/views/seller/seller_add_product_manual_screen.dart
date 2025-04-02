import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:fitaro/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SellerAddProductManualScreen extends StatefulWidget {
  const SellerAddProductManualScreen({super.key});

  @override
  State<SellerAddProductManualScreen> createState() =>
      _SellerAddProductManualScreenState();
}

class _SellerAddProductManualScreenState
    extends State<SellerAddProductManualScreen> {
  final ProductController _productController = Get.find<ProductController>();
  final _sleeveLengthController = TextEditingController();
  final _shoulderWidthController = TextEditingController();
  final _chestController = TextEditingController();
  final _waistController = TextEditingController();
  final _bottomCircumferenceController = TextEditingController();
  final _frontLengthController = TextEditingController();
  final _sleeveController = TextEditingController();
  final _measurements = {};
  final _productSize = Get.arguments ?? "";

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

  @override
  void dispose() {
    _sleeveLengthController.dispose();
    _shoulderWidthController.dispose();
    _chestController.dispose();
    _waistController.dispose();
    _bottomCircumferenceController.dispose();
    _frontLengthController.dispose();
    _sleeveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyHeadingAppBar(
        heading: "Measurements",
        onPressed: () {
          _measurements.clear();
          Get.offNamed("/seller-add-product-sizes");
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
              children: [
                SizedBox(height: 30),
                MyTextField(
                  labelText: _convertLabelFunc("sleeveLength"),
                  controller: _sleeveLengthController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("shoulderWidth"),
                  controller: _shoulderWidthController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("chest"),
                  controller: _chestController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("waist"),
                  controller: _waistController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("bottomCircumference"),
                  controller: _bottomCircumferenceController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("frontLength"),
                  controller: _frontLengthController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                MyTextField(
                  labelText: _convertLabelFunc("sleeve"),
                  controller: _sleeveController,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 50),

                ElevatedButton(
                  onPressed: () {
                    if (_sleeveLengthController.text.isEmpty ||
                        _shoulderWidthController.text.isEmpty ||
                        _chestController.text.isEmpty ||
                        _waistController.text.isEmpty ||
                        _bottomCircumferenceController.text.isEmpty ||
                        _frontLengthController.text.isEmpty ||
                        _sleeveController.text.isEmpty) {
                      ErrorSnackbar.show(
                        title: "Required",
                        message: "Please fill all fields",
                      );
                      return;
                    }

                    _measurements["productSize"] = _productSize;
                    _measurements["sleeveLength"] =
                        _sleeveLengthController.text;
                    _measurements["shoulderWidth"] =
                        _shoulderWidthController.text;
                    _measurements["chest"] = _chestController.text;
                    _measurements["waist"] = _waistController.text;
                    _measurements["bottomCircumference"] =
                        _bottomCircumferenceController.text;
                    _measurements["frontLength"] = _frontLengthController.text;
                    _measurements["sleeve"] = _sleeveController.text;

                    logger.d("measurements: $_measurements");

                    _productController.addProductMeasurementData(_measurements);

                    Get.offNamed('/seller-add-product-sizes');
                    SuccesSnackbar.show(
                      title: "Success",
                      message: "Product measurements added",
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text("Done", style: TextStyle(fontSize: 18)),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
