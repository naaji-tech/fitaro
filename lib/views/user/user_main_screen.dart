import 'package:flutter/material.dart';
import 'package:fitaro/views/user/user_home_screen.dart';
import 'package:fitaro/views/user/user_shop_screen.dart';
import 'package:fitaro/views/user/user_measurements_screen.dart';
import 'package:fitaro/views/profile_screen.dart';

class UserMainScreen extends StatefulWidget {
  const UserMainScreen({super.key});

  @override
  State<UserMainScreen> createState() => _UserMainScreenState();
}

class _UserMainScreenState extends State<UserMainScreen> {
  int _currentIndex = 0;
  String _currentAppBarHeader = "Fitaro";
  List<String> appBarHeader = ["Fitaro", "Shop", "Measurements", "Profile"];
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    UserHomeScreenContent(),
    UserShopScreenContent(),
    UserMeasurementScreenContent(),
    ProfileScreenContent(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
      _currentAppBarHeader = appBarHeader[index];
    });
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getMyAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _screens,
      ),
      bottomNavigationBar: _getMyBottomNavBar(),
    );
  }

  Container _getMyBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(25, 0, 0, 0),
            blurRadius: 25.0,
            offset: Offset(0.0, -2.0),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(49, 0, 0, 0),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined, size: 35),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, size: 35),
            label: "Shop",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt_outlined, size: 35),
            label: "measurement",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, size: 35),
            label: "Profile",
          ),
        ],
      ),
    );
  }

  AppBar _getMyAppBar() {
    return AppBar(
      title: Padding(
        padding: EdgeInsets.only(left: 20),
        child: Text(
          _currentAppBarHeader,
          style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
        ),
      ),
      actions: [
        Icon(Icons.shopping_bag_outlined, size: 40),
        SizedBox(width: 40),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
