import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'package:collection/collection.dart';
import '../encryptItems.dart';
import '../keyManager.dart';
import 'dart:typed_data';

import '../models/card_item.dart';
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
          .doc(userId)
          .collection('logins');

      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      // 1. Push local changes to Firestore
      for (var item in hiveBox.values.toList()) {
        final encryptedPassword = await encryptAesGcm(key, item.password);

        final dataToUpload = {
          'title': item.title,
          'username': item.username,
          'password': encryptedPassword['ciphertext'],
          'nonce': encryptedPassword['nonce'],
          'tag': encryptedPassword['tag'],
        };

        if (item.syncStatus == 'new') {
          final docRef = await loginsCollection.add(dataToUpload);
          item.firestoreId = docRef.id;
          item.syncStatus = 'synced';
          await item.save();
        } else if (item.syncStatus == 'updated' && item.firestoreId != null) {
          await loginsCollection.doc(item.firestoreId!).update(dataToUpload);
          item.syncStatus = 'synced';
          await item.save();
        } else if (item.syncStatus == 'deleted' && item.firestoreId != null) {
          await loginsCollection.doc(item.firestoreId!).delete();
          await item.delete();
        }
      }

      // 2. Pull from Firestore and update Hive
      final querySnapshot = await loginsCollection.get();
      final firestoreIds = <String>{};
      for (var doc in querySnapshot.docs) {
        firestoreIds.add(doc.id);
        final data = doc.data();
        final encryptedPassword = <String, String>{
          'ciphertext': data['password'] as String,
          'nonce': data['nonce'] as String,
          'tag': data['tag'] as String,
        };
        final decryptedPassword = await decryptAesGcm(key, encryptedPassword);

        final existing = hiveBox.values.firstWhereOrNull(
              (item) => item.firestoreId == doc.id,
        );

        if (existing != null) {
          existing
            ..title = data['title'] ?? ''
            ..username = data['username'] ?? ''
            ..password = decryptedPassword
            ..syncStatus = 'synced';
          await existing.save();
        } else {
          final loginItem = LoginItem(
            title: data['title'] ?? '',
            username: data['username'] ?? '',
            password: decryptedPassword,
            firestoreId: doc.id,
            syncStatus: 'synced',
          );
          await hiveBox.add(loginItem);
        }
      }

      // 3. Remove from Hive any item with firestoreId not in Firestore
      final toDelete = hiveBox.values
          .where((item) =>
      item.firestoreId != null && !firestoreIds.contains(item.firestoreId))
          .toList();
      for (var item in toDelete) {
        await item.delete();
      }
    } catch (e) {
      print('Error syncing login items: $e');
    }
  }

  Future<void> syncNoteItems(Box<NoteItem> notesBox, String userId) async {
    try {
      final notesCollection = firestore
          .collection('users')
          .doc(userId)
          .collection('notes');

      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      // 1. Push local changes to Firestore
      for (var item in notesBox.values.toList()) {
        final encryptedTitle = await encryptAesGcm(key, item.title);
        final encryptedContent = await encryptAesGcm(key, item.content);

        final dataToUpload = {
          'title': encryptedTitle['ciphertext'],
          'title_nonce': encryptedTitle['nonce'],
          'title_tag': encryptedTitle['tag'],
          'content': encryptedContent['ciphertext'],
          'content_nonce': encryptedContent['nonce'],
          'content_tag': encryptedContent['tag'],
        };

        if (item.syncStatus == 'new') {
          final docRef = await notesCollection.add(dataToUpload);
          item.firestoreId = docRef.id;
          item.syncStatus = 'synced';
          await item.save();
        } else if (item.syncStatus == 'updated' && item.firestoreId != null) {
          await notesCollection.doc(item.firestoreId!).update(dataToUpload);
          item.syncStatus = 'synced';
          await item.save();
        } else if (item.syncStatus == 'deleted' && item.firestoreId != null) {
          await notesCollection.doc(item.firestoreId!).delete();
          await item.delete();
        }
      }

      // 2. Pull from Firestore and update Hive
      final querySnapshot = await notesCollection.get();
      final firestoreIds = <String>{};
      for (var doc in querySnapshot.docs) {
        firestoreIds.add(doc.id);
        final data = doc.data();

        final encryptedTitle = <String, String>{
          'ciphertext': data['title'] as String,
          'nonce': data['title_nonce'] as String,
          'tag': data['title_tag'] as String,
        };

        final encryptedContent = <String, String>{
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
            ..content = decryptedContent
            ..syncStatus = 'synced';
          await existing.save();
        } else {
          final noteItem = NoteItem(
            title: decryptedTitle,
            content: decryptedContent,
            firestoreId: doc.id,
            syncStatus: 'synced',
          );
          await notesBox.add(noteItem);
        }
      }

      // 3. Remove from Hive any item with firestoreId not in Firestore
      final toDelete = notesBox.values
          .where((item) =>
      item.firestoreId != null && !firestoreIds.contains(item.firestoreId))
          .toList();
      for (var item in toDelete) {
        await item.delete();
      }
    } catch (e) {
      print('Error syncing note items: $e');
    }
  }

  Future<void> syncCardItems(Box<CardItem> cardsBox, String userId) async {
    try {
      final cardsCollection = firestore
          .collection('users')
          .doc(userId)
          .collection('cards');

      Uint8List? key = await PBKDF2KeyManager.loadKeyFromLocal();
      if (key == null) throw Exception('Encryption key not found');

      // 1. Pull from Firestore and update Hive
      final querySnapshot = await cardsCollection.get();
      for (var doc in querySnapshot.docs) {
        final data = doc.data();

        final encryptedNumber = <String, String>{
          'ciphertext': data['number'] as String,
          'nonce': data['number_nonce'] as String,
          'tag': data['number_tag'] as String,
        };
        final encryptedCvv = <String, String>{
          'ciphertext': data['cvv'] as String,
          'nonce': data['cvv_nonce'] as String,
          'tag': data['cvv_tag'] as String,
        };
        final encryptedPin = <String, String>{
          'ciphertext': data['pin'] as String,
          'nonce': data['pin_nonce'] as String,
          'tag': data['pin_tag'] as String,
        };

        final decryptedNumber = await decryptAesGcm(key, encryptedNumber);
        final decryptedCvv = await decryptAesGcm(key, encryptedCvv);
        final decryptedPin = await decryptAesGcm(key, encryptedPin);

        final existing = cardsBox.values.firstWhereOrNull(
              (item) => item.firestoreId == doc.id,
        );

        if (existing != null) {
          existing
            ..number = decryptedNumber
            ..holderName = data['holderName'] ?? ''
            ..expiryDate = data['expiryDate'] ?? ''
            ..cvv = decryptedCvv
            ..pin = decryptedPin;
          await existing.save();
        } else {
          final cardItem = CardItem(
            number: decryptedNumber,
            holderName: data['holderName'] ?? '',
            expiryDate: data['expiryDate'] ?? '',
            cvv: decryptedCvv,
            pin: decryptedPin,
            firestoreId: doc.id,
          );
          await cardsBox.add(cardItem);
        }
      }

    } catch (e) {
      print('Error syncing card items: $e');
    }
  }
}
