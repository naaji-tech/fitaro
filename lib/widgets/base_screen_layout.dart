import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BaseScreenLayout extends StatelessWidget {
  final Widget child;
  final int currentIndex;

  const BaseScreenLayout({
    super.key,
    required this.child,
    required this.currentIndex,
  });

  void _onItemTapped(int index) {
    if (index != currentIndex) {
      String route = '';
      switch (index) {
        case 0:
          route = '/home';
          break;
        case 1:
          route = '/shop';
          break;
        case 2:
          if (Get.currentRoute != '/measurements') {
            _showMeasurementOptions(Get.context!);
            return;
          }
          break;
        case 3:
          route = '/profile';
          break;
      }

      if (route.isNotEmpty) {
        Get.offAllNamed(route);
      }
    }
  }

  void _showMeasurementOptions(BuildContext context) {
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
                  onTap: () {
                    Navigator.pop(context);
                    Get.offAllNamed('/measurements');
                  },
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: Colors.green),
                  title: Text("Take Photo"),
                  onTap: () {
                    Navigator.pop(context);
                    Get.offAllNamed('/measurements');
                  },
                ),
              ],
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: child),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black54,
        showUnselectedLabels: true,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Shop",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.camera), label: "Camera"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
