import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/widgets.dart';
import '../../l10n/generated/app_localizations.dart';

class SecurityService {
  static const _storage = FlutterSecureStorage();
  static const _channel = MethodChannel('gaddash/privacy');
  static final _algorithm = Pbkdf2(
    macAlgorithm: Hmac.sha256(),
    iterations: 100000,
    bits: 256,
  );

  static Future<bool> hasPin() async =>
      (await _storage.read(key: 'gaddash.pin.v1')) != null;

  static Future<void> setPin(String pin) async {
    if (!RegExp(r'^\d{4,8}$').hasMatch(pin)) {
      throw const FormatException('PIN must contain 4 to 8 digits');
    }
    final salt = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final key = await _algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    final hash = await key.extractBytes();
    await _storage.write(
      key: 'gaddash.pin.v1',
      value: '${base64Encode(salt)}:${base64Encode(hash)}',
    );
  }

  static Future<bool> verifyPin(String pin) async {
    final saved = await _storage.read(key: 'gaddash.pin.v1');
    if (saved == null) return false;
    final parts = saved.split(':');
    if (parts.length != 2) return false;
    final salt = base64Decode(parts[0]);
    final expected = base64Decode(parts[1]);
    final key = await _algorithm.deriveKey(
      secretKey: SecretKey(utf8.encode(pin)),
      nonce: salt,
    );
    final actual = await key.extractBytes();
    if (actual.length != expected.length) return false;
    var difference = 0;
    for (var i = 0; i < actual.length; i++) {
      difference |= actual[i] ^ expected[i];
    }
    return difference == 0;
  }

  static Future<void> clearPin() => _storage.delete(key: 'gaddash.pin.v1');

  static Future<bool> authenticateBiometric(Locale locale) async {
    final auth = LocalAuthentication();
    if (!await auth.canCheckBiometrics) return false;
    return auth.authenticate(
      localizedReason: lookupAppLocalizations(locale).biometricPrompt,
      options: const AuthenticationOptions(
        biometricOnly: true,
        stickyAuth: true,
      ),
    );
  }

  static Future<void> setPrivatePreview(bool enabled) async {
    await _channel.invokeMethod<void>('setSecure', enabled);
  }
}
