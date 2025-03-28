import 'package:fitaro/logger/log.dart';
import 'package:fitaro/widgets/custom_text_fields.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fitaro/controllers/auth_controller.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List<String> userTypes = ["Customer", "Seller"];
  String selectedUserType = "None";
  final AuthController authController = Get.find<AuthController>();
  bool _obscurePassword = true;

  void _handleSignup() {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in all fields",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    logger.i("selectedUserType: $selectedUserType");

    if (selectedUserType == "None") {
      Get.snackbar(
        "Error",
        "User Type needs to select",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    authController.register(
      usernameController.text,
      passwordController.text,
      selectedUserType.toLowerCase(),
    );
  }

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
              SizedBox(height: 16),

              // User Type Dropdown
              MyIconDropdownButtonFormField(
                hintText: "User Type",
                items:
                    userTypes.map((type) {
                      return DropdownMenuItem(value: type, child: Text(type));
                    }).toList(),
                prefixIcon: Icon(Icons.person_outline),
                onChanged: (value) {
                  setState(() {
                    selectedUserType = value!;
                  });
                },
              ),
              SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed: _handleSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Sign Up", style: TextStyle(fontSize: 18)),
              ),
              SizedBox(height: 16),

              // Login Link
              TextButton(
                onPressed: () => Get.toNamed("/"),
                child: Text(
                  "Already have an account?",
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
