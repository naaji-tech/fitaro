import 'package:flutter/material.dart';

class UserHomeScreenContent extends StatelessWidget {
  const UserHomeScreenContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 45),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 45),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "This is a smart garment size recommendation app designed to help you find the perfect size when shop online. Using AI-powered body measurement extraction and garment analysis, Fitaro ensures "
                    "accurate size recommendations based on your unique body shape. Simply select a garment, upload your image, and get the best size suggestion instantly!",
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Key Features",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "✓ AI-driven Measurement",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  "✓ Personalized Size Recommendations",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                Text(
                  "✓ Seamless Online Shopping Experience",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                SizedBox(height: 20),
                Text(
                  "Goodbye to size guesswork and returns\n"
                  "Get the perfect fit with Fitaro!",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
