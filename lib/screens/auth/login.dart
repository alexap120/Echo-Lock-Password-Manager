import 'package:flutter/material.dart';
import 'package:password_manager/screens/auth/resetPassword/enter_email.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widgets/custom_input_field.dart';
import '../main_screens/home.dart';
import 'auth_service.dart';
import 'register.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscurePassword = true;
  bool rememberMe = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 150),
              const Text(
                'ConceptX',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF328E6E),
                ),
              ),
              const SizedBox(height: 40),
              const Icon(
                Icons.view_in_ar,
                color: Colors.deepPurple,
                size: 40,
              ),
              const SizedBox(height: 125),

              CustomInputField(
                label: 'Email',
                controller: emailController,
                optionalIcon: Icons.alternate_email,
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 16),

              CustomInputField(
                label: 'Password',
                controller: passwordController,
                obscureText: obscurePassword,
                optionalIcon: obscurePassword ? Icons.visibility : Icons.visibility_off,
                onOptionalIconTap: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
// Remember me checkbox
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          rememberMe = !rememberMe;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: rememberMe ? Color(0xFF328E6E) : Colors.transparent,
                          border: Border.all(color: Color(0xFF328E6E)),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        width: 20,
                        height: 20,
                        child: rememberMe
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'Remember me',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),



              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RegisterScreen()),
                        );
                       /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => EnterPasswordScreen()),
                        );*/
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          final email = emailController.text.trim();
                          final password = passwordController.text;

                          String? result = await AuthService().signInWithEmail(
                            email: email,
                            password: password,
                          );

                          if (result == null) {
                            if (rememberMe) {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('remember_me', true);
                              await prefs.setString('remembered_email', email); // optional
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result)),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF328E6E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text('Login'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 100),
              Align(
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const ResetPasswordScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE1EEBC),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('Reset Password'),
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}
