import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import '../encryptItems.dart';
import '../keyManager.dart';
import 'dart:typed_data';

import '../models/login_item.dart';
import '../models/notes_item.dart';

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

  Future<void> syncNoteItems(Box<NoteItem> notesBox, String userId) async {
    try {
      final notesCollection = firestore
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('notes');
      final querySnapshot = await notesCollection.get();

      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        final encryptedTitle = {
          'ciphertext': data['title'] as String,
          'nonce': data['title_nonce'] as String,
          'tag': data['title_tag'] as String,
        };
        final encryptedContent = {
          'ciphertext': data['content'] as String,
          'nonce': data['content_nonce'] as String,
          'tag': data['content_tag'] as String,
        };

        final decryptedTitle = await decryptAesGcm(key, encryptedTitle);
        final decryptedContent = await decryptAesGcm(key, encryptedContent);

        final existing = notesBox.values.firstWhereOrNull(
              (item) => item.firestoreId == doc.id,
        );

        if (existing != null) {
          existing
            ..title = decryptedTitle
            ..content = decryptedContent;
          await existing.save();
        } else {
          final noteItem = NoteItem(
            title: decryptedTitle,
            content: decryptedContent,
            firestoreId: doc.id,
          );
          await notesBox.add(noteItem);
        }
      }
    } catch (e) {
      print('Error syncing note items: $e');
    }
  }

}