import 'package:flutter/material.dart';

class HomeScreenContent extends StatelessWidget {
  const HomeScreenContent({super.key});

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
                Text("Welcome to Fitaro", style: TextStyle(fontSize: 22)),
                SizedBox(height: 15),
                Text(
                  "Fitaro is a smart garment fit recommendation app designed to help "
                  "you find the perfect size when shop online. Using AI-powered "
                  "body measurement extraction and garment analysis, Fitaro ensures "
                  "accurate fit recommendations based on your unique body shape. "
                  "Simply upload your image, select a garment, and get the best size "
                  "suggestion instantly!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Key Features",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Text(
                  "✓ AI-driven measurement",
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
                Text(
                  "✓ Personalized fit recommendations",
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
                Text(
                  "✓ Seamless online shopping experience",
                  style: TextStyle(fontSize: 18, height: 1.5),
                ),
                SizedBox(height: 20),
                Text(
                  "Goodbye to size guesswork and returns\n"
                  "Get the perfect fit with Fitaro!",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
