import 'package:flutter/foundation.dart';

import '../core/services/storage_service.dart';

/// تنظیمات اپ: صدا، سرعت تلفظ، حالت آفلاین
class SettingsProvider extends ChangeNotifier {
  final StorageService _storage = StorageService.instance;

  /// صدا روشن است؟
  bool soundOn = true;

  /// سرعت تلفظ گوینده (۰٫۲ آرام تا ۱ معمولی) — پیش‌فرض آرام برای بچه‌ها
  double speechRate = 0.45;

  /// حالت آفلاین همیشه فعال است (این فلگ فقط برای نمایش در تنظیمات است)
  static const bool offlineAlways = true;

  void load() {
    soundOn = _storage.getSetting('soundOn', true);
    speechRate = _storage.getSetting('speechRate', 0.45);
    notifyListeners();
  }

  void setSoundOn(bool value) {
    soundOn = value;
    _storage.setSetting('soundOn', value);
    notifyListeners();
  }

  void setSpeechRate(double value) {
    speechRate = value.clamp(0.2, 1.0).toDouble();
    _storage.setSetting('speechRate', speechRate);
    notifyListeners();
  }
}
