import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final IconData icon;
  final TextInputType keyboardType;
  final VoidCallback? onIconTap;

  const CustomInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    required this.icon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onIconTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hintText,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            suffixIcon: GestureDetector(
              onTap: onIconTap,
              child: Icon(icon),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.grey),
            ),
          ),
        ),
      ],
    );
  }
}
