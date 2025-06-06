import 'package:flutter/material.dart';
import 'package:password_manager/screens/auth/login_password.dart';
import 'screens/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart'; // For Android/iOS document directory
import 'models/login_item.dart'; // Adjust path as per your project structure

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();
  // Initialize Hive
  await Hive.initFlutter();
  // Register your adapters
  Hive.registerAdapter(LoginItemAdapter());
  // Open boxes
  await Hive.openBox<LoginItem>('loginBox');
  // SharedPreferences for your remember me logic
  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;

  runApp(MyApp(initialScreen: rememberMe ? const EnterPasswordScreen() : const LoginScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({required this.initialScreen, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: initialScreen,
    );
  }
}
