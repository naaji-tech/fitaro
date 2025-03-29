import 'package:fitaro/controllers/product_controller.dart';
import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserShopScreenContent extends StatefulWidget {
  const UserShopScreenContent({super.key});

  @override
  State<UserShopScreenContent> createState() => _UserShopScreenContentState();
}

class _UserShopScreenContentState extends State<UserShopScreenContent> {
  final ProductController _productController = Get.find<ProductController>();
  int _itemCount = 0;
  List<dynamic> _products = [];

  @override
  void initState() {
    super.initState();
    _setItemCount();
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Products Grid
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await _productController.fetchProducts();
                _setItemCount();
              },
              child: GridView.builder(
                padding: EdgeInsets.symmetric(vertical: 40),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _itemCount,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap:
                        () => Get.toNamed(
                          '/product-details',
                          arguments: _products[index],
                        ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(158, 158, 158, 0.2),
                            spreadRadius: 0,
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Product Image
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: NetworkImageWidget(
                                  imageUrl: _products[index]['productImageUrl'],
                                ),
                              ),
                            ),
                          ),
                          // Product Info
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${_products[index]['productName']}\n",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
