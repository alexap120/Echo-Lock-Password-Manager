import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:password_manager/screens/auth/login_password.dart';
import 'keyEncryption.dart';  // Your encryption key helper
import 'screens/auth/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/login_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();
  Hive.registerAdapter(LoginItemAdapter());

  // Get or create encryption key from secure storage
  final encryptionKey = await EncryptionKeyManager.getEncryptionKey();

  // Open encrypted Hive box
  await Hive.openBox<LoginItem>(
    'loginBox',
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;

  runApp(MyApp(
    initialScreen: rememberMe ? const EnterPasswordScreen() : const LoginScreen(),
  ));
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;

  const MyApp({required this.initialScreen, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: initialScreen,
    );
  }
}
