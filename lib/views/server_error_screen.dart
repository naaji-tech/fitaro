import 'package:flutter/material.dart';

class ServerErrorScreen extends StatelessWidget {
  const ServerErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 80),
            SizedBox(height: 20),
            Text(
              '500',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Internal Server Error', style: TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
