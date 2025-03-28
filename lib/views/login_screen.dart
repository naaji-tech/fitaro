import 'package:fitaro/controllers/auth_controller.dart';
import 'package:fitaro/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 60.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 60,
                    color: Colors.black,
                  ),
                  SizedBox(width: 10),

                  // App Name
                  Text(
                    "Fitaro",
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 60),

              // Username Field
              MyIconTextField(
                hintText: "Username",
                controller: usernameController,
                icon: Icon(Icons.person),
              ),
              SizedBox(height: 16),

              // Password Field
              MyIconPasswordTextField(
                hintText: "Password",
                controller: passwordController,
                icon: Icon(Icons.lock),
                suffixIconOnPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
                obscureText: _obscurePassword,
              ),

              SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: () async {
                  await authController.login(
                    usernameController.text,
                    passwordController.text,
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Login", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 16),

              // Sign Up Link
              TextButton(
                onPressed: () {
                  Get.toNamed('/signup');
                },
                child: Text(
                  "Create new account?",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
