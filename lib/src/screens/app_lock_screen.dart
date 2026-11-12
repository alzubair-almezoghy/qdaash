import '../../l10n/generated/app_localizations.dart';
import 'package:flutter/material.dart';

import '../settings/security_service.dart';

class AppLockScreen extends StatefulWidget {
  const AppLockScreen({
    required this.onUnlocked,
    required this.biometric,
    super.key,
  });
  final VoidCallback onUnlocked;
  final bool biometric;

  @override
  State<AppLockScreen> createState() => _AppLockScreenState();
}

class _AppLockScreenState extends State<AppLockScreen> {
  final _pin = TextEditingController();
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _pin.dispose();
    super.dispose();
  }

  Future<void> _unlock() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (await SecurityService.verifyPin(_pin.text)) {
        widget.onUnlocked();
      } else if (mounted) {
        setState(() => _error = AppLocalizations.of(context)!.incorrectPin);
        _pin.clear();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _biometric() async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      if (await SecurityService.authenticateBiometric(
        Localizations.localeOf(context),
      )) {
        widget.onUnlocked();
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = AppLocalizations.of(context)!.biometricUnavailable,
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 360),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                    child: Icon(
                      Icons.lock_rounded,
                      size: 33,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.unlockGaddash,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _pin,
                    // Opening the system IME while the splash is being
                    // removed can stall first input dispatch on some Android
                    // devices. Let the lock screen settle; tapping the field
                    // opens the numeric keyboard as usual.
                    autofocus: false,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 8,
                    onSubmitted: (_) => _unlock(),
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)!.pin,
                      errorText: _error,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _busy ? null : _unlock,
                      child: Text(AppLocalizations.of(context)!.unlock),
                    ),
                  ),
                  if (widget.biometric)
                    TextButton.icon(
                      onPressed: _busy ? null : _biometric,
                      icon: const Icon(Icons.fingerprint_rounded),
                      label: Text(AppLocalizations.of(context)!.useBiometrics),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
