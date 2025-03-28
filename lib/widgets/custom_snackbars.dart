import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoSnackbar {
  static void show({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(180, 33, 149, 243),
      colorText: Colors.black,
      duration: Duration(milliseconds: 1300),
    );
  }
}

class WarningSnackbar {
  static void show({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(180, 245, 127, 23),
      colorText: Colors.black,
      duration: Duration(milliseconds: 1300),
    );
  }
}

class ErrorSnackbar {
  static void show({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(180, 183, 28, 28),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1400),
    );
  }
}

class SuccesSnackbar {
  static void show({required String title, required String message}) {
    Get.snackbar(
      title,
      message,
      backgroundColor: const Color.fromARGB(180, 27, 94, 31),
      colorText: Colors.white,
      duration: Duration(milliseconds: 1000),
    );
  }
}
