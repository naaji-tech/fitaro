import 'package:fitaro/widgets/custom_snackbars.dart';
import 'package:flutter/material.dart';

class MyButtonBlackFull extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const MyButtonBlackFull({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

class MyButtonBlack extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButtonBlack({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }
}

class MyButtonGreyFull extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButtonGreyFull({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.black,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class MyButtonGrey extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyButtonGrey({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 20),
        child: Text(text, style: TextStyle(color: Colors.black, fontSize: 18)),
      ),
    );
  }
}

class MyProductSizeButtonBlack extends StatelessWidget {
  final String text;

  const MyProductSizeButtonBlack({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        WarningSnackbar.show(
          title: "Warning",
          message: "Product size $text is already added",
        );
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size(50, 60),
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 18)),
    );
  }
}

class MyProductSizeButtonGrey extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const MyProductSizeButtonGrey({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: Colors.grey.shade200,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size(50, 60),
      ),
      child: Text(text, style: TextStyle(color: Colors.black, fontSize: 20)),
    );
  }
}
