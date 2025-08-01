import 'package:flutter/material.dart';

class MyHeadingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String heading;
  final double headingSize;
  final VoidCallback onPressed;

  const MyHeadingAppBar({
    super.key,
    required this.heading,
    required this.onPressed,
    this.headingSize = 28,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Transform.translate(
        offset: Offset(20, 0),
        child: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 40),
          onPressed: onPressed,
        ),
      ),
      title: Text(
        heading,
        style: TextStyle(fontSize: headingSize, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
