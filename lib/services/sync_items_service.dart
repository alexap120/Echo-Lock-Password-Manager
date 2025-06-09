import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

import '../encryptItems.dart';
import '../keyManager.dart';
import 'dart:typed_data';

import '../models/login_item.dart';

class SyncService {
  final FirebaseFirestore firestore;
  final Box<LoginItem> hiveBox;

  SyncService({required this.firestore, required this.hiveBox});

  Future<void> syncLoginItems(String userId) async {
    try {
      final loginsCollection = firestore.collection('users').doc(FirebaseAuth.instance.currentUser?.uid).collection('logins');
      final querySnapshot = await loginsCollection.get();

      // Load the derived key once
      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        // Build the encrypted map for decryption
        final encryptedPassword = {
          'ciphertext': data['password'] as String,
          'nonce': data['nonce'] as String,
          'tag': data['tag'] as String,
        };

        // Decrypt the password
        final decryptedPassword = await decryptAesGcm(key, encryptedPassword);

        final loginItem = LoginItem(
          title: data['title'] ?? '',
          username: data['username'] ?? '',
          password: decryptedPassword,
        );

        // Save or update Hive box keyed by doc.id
        await hiveBox.put(doc.id, loginItem);
      }
    } catch (e) {
      print('Error syncing login items: $e');
    }
  }
}