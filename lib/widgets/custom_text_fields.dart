import 'package:flutter/material.dart';

class MyIconTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const MyIconTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
    );
  }
}

class MyIconPasswordTextField extends StatelessWidget {
  final String hintText;
  final Icon icon;
  final VoidCallback suffixIconOnPressed;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const MyIconPasswordTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.icon,
    required this.suffixIconOnPressed,
    required this.obscureText,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon,
        suffixIcon: IconButton(
          icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
          onPressed: suffixIconOnPressed,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;

  const MyTextField({
    super.key,
    required this.labelText,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
    );
  }
}

class MyTextArea extends StatelessWidget {
  final String labelText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final int maxLines;

  const MyTextArea({
    super.key,
    required this.labelText,
    required this.controller,
    required this.maxLines,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 15.0,
        ),
      ),
    );
  }
}

class MyDropdownButtonFormField extends StatelessWidget {
  final String labelText;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final ValueChanged<String?> onChanged;

  const MyDropdownButtonFormField({
    super.key,
    required this.labelText,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: labelText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}

class MyIconDropdownButtonFormField extends StatelessWidget {
  final String hintText;
  final List<DropdownMenuItem<String>> items;
  final String? value;
  final Icon prefixIcon;
  final ValueChanged<String?> onChanged;

  const MyIconDropdownButtonFormField({
    super.key,
    required this.hintText,
    required this.items,
    required this.prefixIcon,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: prefixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 2, color: Colors.black),
        ),
      ),
      value: value,
      items: items,
      onChanged: onChanged,
    );
  }
}
