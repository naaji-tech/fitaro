import 'package:fitaro/views/profile_screen.dart';
import 'package:fitaro/views/seller/product_inventory_screen.dart';
import 'package:flutter/material.dart';

class SellerMainScreen extends StatefulWidget {
  const SellerMainScreen({super.key});

  @override
  State<SellerMainScreen> createState() => _SellerMainScreenState();
}

class _SellerMainScreenState extends State<SellerMainScreen> {
  int _currentIndex = 0;
  String _currentAppBarHeader = "Inventory";
  List<String> appBarHeader = ["Inventory", "Profile"];
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    ProductInventoryContent(),
    ProfileScreenContent(),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

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
        iconSize: 35,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_rounded),
            label: "Inventory",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _getMyAppBar(),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
        children: _screens,
      ),
      bottomNavigationBar: _getMyBottomNavBar(),
    );
  }
}
