import 'dart:convert';
import 'dart:math';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EncryptionKeyManager {
  static const _storage = FlutterSecureStorage();
  static const _keyName = 'hiveEncryptionKey';

  /// Returns the 32-byte encryption key, generating it if necessary
  static Future<List<int>> getEncryptionKey() async {
    // Check if key exists in secure storage
    String? encodedKey = await _storage.read(key: _keyName);

    if (encodedKey == null) {
      // Generate a new 32-byte key
      final key = List<int>.generate(32, (i) => Random.secure().nextInt(256));

      // Encode key as base64 string to store
      encodedKey = base64UrlEncode(key);

      // Save it securely
      await _storage.write(key: _keyName, value: encodedKey);

      return key;
    } else {
      // Decode the stored base64 key back to bytes
      return base64Url.decode(encodedKey);
    }
  }
}
