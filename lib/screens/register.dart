import 'package:flutter/material.dart';
import 'login.dart';
import '/widgets/custom_input_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _repeatPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureRepeatPassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Create account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0A0A52), // Deep blue
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please enter your details',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),

              // Email field
              CustomInputField(
                label: 'Your email',
                hintText: 'Enter your email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),

              // Password field
              CustomInputField(
                label: 'Password',
                hintText: 'Enter your password',
                controller: _passwordController,
                obscureText: _obscurePassword,
                icon: _obscurePassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                onIconTap: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Repeat Password field
              CustomInputField(
                label: 'Repeat Password',
                hintText: 'Repeat password',
                controller: _repeatPasswordController,
                obscureText: _obscureRepeatPassword,
                icon: _obscureRepeatPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                onIconTap: () {
                  setState(() {
                    _obscureRepeatPassword = !_obscureRepeatPassword;
                  });
                },
              ),
              const SizedBox(height: 32),

              // Register Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    // Register logic here
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginScreen()),
                        );
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Color(0xFF2563EB),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
