import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
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
      final loginsCollection = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('logins');
      final querySnapshot = await loginsCollection.get();

      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        final encryptedPassword = {
          'ciphertext': data['password'] as String,
          'nonce': data['nonce'] as String,
          'tag': data['tag'] as String,
        };

        final decryptedPassword = await decryptAesGcm(key, encryptedPassword);

        // Check if item with this firestoreId exists
        final existing = hiveBox.values.firstWhereOrNull(
              (item) => item.firestoreId == doc.id,
        );

        if (existing != null) {
          // Update existing item
          existing
            ..title = data['title'] ?? ''
            ..username = data['username'] ?? ''
            ..password = decryptedPassword;
          await existing.save();
        } else {
          // Add new item and set firestoreId
          final loginItem = LoginItem(
            title: data['title'] ?? '',
            username: data['username'] ?? '',
            password: decryptedPassword,
            firestoreId: doc.id,
          );
          await hiveBox.add(loginItem);
        }
      }
    } catch (e) {
      print('Error syncing login items: $e');
    }
  }
}