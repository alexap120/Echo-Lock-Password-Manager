import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:password_manager/models/card_item.dart';
import 'firebase_options.dart';
import 'package:password_manager/models/notes_item.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/login_item.dart';
import 'screens/auth/login.dart';
import 'screens/auth/login_password.dart';
import 'keyManager.dart'; // assumes PBKDF2KeyManager is in this file

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  await Hive.initFlutter();
  Hive.registerAdapter(LoginItemAdapter());
  Hive.registerAdapter(NoteItemAdapter());
  Hive.registerAdapter(CardItemAdapter());

  final key = await PBKDF2KeyManager.loadKeyFromLocal();

  Box<LoginItem>? loginBox;
  Box<NoteItem>? notesBox;
  Box<CardItem>? cardsBox;

  if (key != null) {
    loginBox = await Hive.openBox<LoginItem>(
      'loginBox',
      encryptionCipher: HiveAesCipher(key),
    );

    notesBox = await Hive.openBox<NoteItem>(
      'notesBox',
      encryptionCipher: HiveAesCipher(key),
    );

    cardsBox = await Hive.openBox<CardItem>(
      'cardsBox',
      encryptionCipher: HiveAesCipher(key),
    );
  } else {
    debugPrint("No local key found. Skipping Hive box decryption.");
  }

  final prefs = await SharedPreferences.getInstance();
  final rememberMe = prefs.getBool('remember_me') ?? false;

  runApp(MyApp(
    initialScreen: key != null && rememberMe
        ? EnterPasswordScreen()
        : LoginScreen(),
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
