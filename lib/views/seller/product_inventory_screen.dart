import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductInventoryContent extends StatefulWidget {
  const ProductInventoryContent({super.key});

  @override
  State<ProductInventoryContent> createState() =>
      _ProductInventoryContentState();
}

class _ProductInventoryContentState extends State<ProductInventoryContent> {
  final ProductController _productController = Get.find<ProductController>();
  int _itemCount = 0;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      _setItemCount();
    });
  }

  void _setItemCount() {
    logger.i("Set item count and products");
    setState(() {
      if (_productController.isLoading.value) {
        _itemCount = 0;
      } else {
        _products = _productController.productList;
        _itemCount = _products.length;
      }
    });
    logger.i("Set item count and products successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await _productController.fetchProducts();
          _setItemCount();
        },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          itemCount: _itemCount,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                child: ListTile(
                  onTap: () {
                    Get.toNamed(
                      '/seller-product-details',
                      arguments: _products[index],
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage:
                        _products[index]['productImageUrl'] != null
                            ? NetworkImage(_products[index]['productImageUrl'])
                            : null,
                    child:
                        _products[index]['productImageUrl'] == null
                            ? Icon(Icons.image)
                            : null,
                  ),
                  title:
                      _products[index]['productName'] != null
                          ? Text(
                            _products[index]['productName'],
                            style: TextStyle(fontSize: 16),
                          )
                          : null,
                  trailing: Icon(Icons.chevron_right, size: 30),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 20, bottom: 10),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed('/seller-add-product');
          },
          elevation: 0,
          shape: ShapeBorder.lerp(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            0,
          ),
          backgroundColor: Colors.black,
          child: Icon(Icons.add, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
