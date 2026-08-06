import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  static const String _vibrateKey = 'vibrate_on_scan';

  bool _vibrateOnScan = true;

  bool get vibrateOnScan => _vibrateOnScan;

  SettingsProvider() {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _vibrateOnScan = prefs.getBool(_vibrateKey) ?? true;
    notifyListeners();
  }

  Future<void> toggleVibrate() async {
    _vibrateOnScan = !_vibrateOnScan;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrateKey, _vibrateOnScan);
  }
}
