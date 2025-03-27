import 'package:flutter/material.dart';

class MyHeadingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final VoidCallback onPressed;

  const MyHeadingAppBar({
    super.key,
    required this.heading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black, size: 40),
        onPressed: onPressed,
      ),
      title: Text(
        heading,
        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      // actions: [
      //   Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 40),
      //   SizedBox(width: 40),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
