import 'dart:math';

import 'package:flutter/material.dart';
import '../../widgets/custom_input_field.dart';
import '../../models/login_item.dart';
import 'package:hive/hive.dart';

class AddLoginPopup extends StatefulWidget {
  const AddLoginPopup({super.key});

  @override
  State<AddLoginPopup> createState() => _AddLoginPopupState();
}

class _AddLoginPopupState extends State<AddLoginPopup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController websiteController = TextEditingController();
  bool _obscurePassword = true;

  void _generatePassword() {
    const String uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String lowercase = 'abcdefghijklmnopqrstuvwxyz';
    const String digits = '0123456789';
    const String special = '!@#%^&*\$#()-_=+[{]}\\|;:,<.>/?~';

    final chars = uppercase + lowercase + digits + special;
    final rand = Random();

    final password = List.generate(18, (_) => chars[rand.nextInt(chars.length)]).join();

    setState(() {
      passwordController.text = password;
      _obscurePassword = true;  // optionally obscure when generated
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    websiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF328E6E),
        elevation: 0,
        title: const Text("Add Login", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Positioned background container
            Positioned(
              top: -150,
              left: -100,
              right: -100,
              child: Container(
                height: 250, // Adjust height as needed
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(300, 100),
                  ),
                  color: Color(0xFF328E6E),
                ),
              ),
            ),
            // Main content
            Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        const SizedBox(height: 32),
                        CustomInputField(
                          label: 'Name',
                          controller: nameController,
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          label: 'Username',
                          controller: usernameController,
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          label: 'Password',
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          optionalIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                          onOptionalIconTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        CustomInputField(
                          label: 'Website',
                          controller: websiteController,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  children: [
                    // Transparent button with only border
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, // Transparent background
                          side: BorderSide(color: const Color(0xFF328E6E), width: 2), // Border with same color as Save button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                          onPressed: _generatePassword,
                        child: const Text(
                          "Generate Password",
                          style: TextStyle(fontSize: 16, color: Color(0xFF328E6E)), // Text color same as border
                        ),
                      ),
                    ),
                    // Save button
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF328E6E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        onPressed: () async {
                          if (nameController.text.isEmpty ||
                              usernameController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill in all required fields.'),
                                backgroundColor: Colors.red,
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          final loginBox = Hive.box<LoginItem>('loginBox');
                          final newItem = LoginItem(
                            title: nameController.text,
                            username: usernameController.text,
                            password: passwordController.text,
                          );

                          await loginBox.add(newItem);

                          Navigator.of(context).pop(); // no need to return the new item
                        },
                        child: const Text(
                          "Save",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
