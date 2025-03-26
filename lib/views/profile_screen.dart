import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/user_controller.dart';

class ProfileScreenContent extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final UserController userController = Get.find<UserController>();

  ProfileScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
      child: Column(
        children: [
          // User Info Card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userController.username.value,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 5),
                Text(
                  userController.userType.value,
                  style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Options List
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                _buildOptionTile(
                  icon: Icons.shopping_cart_checkout,
                  title: "My Orders",
                  onTap: () {
                    Get.snackbar(
                      'Coming Soon',
                      'Orders feature will be available soon!',
                      backgroundColor: Color.fromRGBO(0, 0, 255, 0.3),
                      colorText: Colors.black,
                      duration: Duration(seconds: 1),
                    );
                  },
                ),
                Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
                _buildOptionTile(
                  icon: Icons.favorite_border,
                  title: "Wishlist",
                  onTap: () {
                    Get.snackbar(
                      'Coming Soon',
                      'Wishlist feature will be available soon!',
                      backgroundColor: Color.fromRGBO(0, 0, 255, 0.3),
                      colorText: Colors.black,
                      duration: Duration(seconds: 1),
                    );
                  },
                ),
                Divider(height: 3, thickness: 1, color: Colors.grey.shade300),
                _buildOptionTile(
                  icon: Icons.local_shipping_outlined,
                  title: "Shipping Address",
                  onTap: () {
                    Get.snackbar(
                      'Coming Soon',
                      'Shipping address feature will be available soon!',
                      backgroundColor: Color.fromRGBO(0, 0, 255, 0.3),
                      colorText: Colors.black,
                      duration: Duration(seconds: 1),
                    );
                  },
                ),
              ],
            ),
          ),
          Spacer(),

          // Logout Button
          ElevatedButton(
            onPressed: () {
              authController.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              "Logout",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.black, size: 30),
        title: Text(title, style: TextStyle(fontSize: 16)),
        trailing: Icon(Icons.chevron_right, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
