import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_app_bars.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MyHeadingAppBar(
        heading: "Measurements",
        onPressed: () {
          Get.offNamed("/seller-add-product-sizes");
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("sleeveLength"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _sleeveLengthController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("shoulderWidth"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _shoulderWidthController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("chest"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _chestController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("waist"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _waistController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("bottomCircumference"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _bottomCircumferenceController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("frontLength"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _frontLengthController,
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: _convertLabelFunc("sleeve"),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                controller: _sleeveController,
              ),
              SizedBox(height: 50),

              ElevatedButton(
                onPressed: () {
                  _measurements["productSize"] = _productSize;
                  _measurements["sleeveLength"] = _sleeveLengthController.text;
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

                  Get.snackbar(
                    'Success',
                    'Product measurements added',
                    backgroundColor: Color.fromRGBO(76, 175, 80, 0.1),
                    colorText: Colors.green,
                    duration: Duration(seconds: 1),
                    // snackPosition: SnackPosition.BOTTOM,
                  );
                  Get.offNamed('/seller-add-product-sizes');
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
            ],
          ),
        ),
      ),
    );
  }
}
