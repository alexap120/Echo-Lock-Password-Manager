import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AutoLockManager with WidgetsBindingObserver {
  Timer? _timer;
  int _minutes = 1;
  final VoidCallback onTimeout;
  bool _instantLockEnabled = false;
  AutoLockManager({required this.onTimeout});

  /// Loads the user's auto-lock setting from SharedPreferences.
  Future<void> loadSetting() async {
    final prefs = await SharedPreferences.getInstance();
    _minutes = prefs.getInt('auto_lock_minutes') ?? 1;
    _instantLockEnabled = prefs.getBool('instant_lock_enabled') ?? false;
  }

  /// Starts or restarts the auto-lock timer.
  void start() {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: _minutes), onTimeout);
  }

  /// Resets the timer (call on user activity).
  void resetTimer() => start();

  /// Stops the timer (call on dispose or app pause).
  void stopTimer() => _timer?.cancel();

  /// Handles app lifecycle changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      if (_instantLockEnabled) {
        onTimeout();
      }
      stopTimer();
    } else if (state == AppLifecycleState.resumed) {
      start();
    }
  }
}