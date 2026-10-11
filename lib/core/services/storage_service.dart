import 'package:hive_flutter/hive_flutter.dart';

/// سرویس ذخیره‌سازی محلی — کاملاً آفلاین با Hive
/// دو جعبه (Box): پیشرفت دانش‌آموز + تنظیمات
class StorageService {
  StorageService._();
  static final StorageService instance = StorageService._();

  static const String _progressBoxName = 'progress';
  static const String _settingsBoxName = 'settings';

  Box? _progressBox;
  Box? _settingsBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _progressBox = await Hive.openBox(_progressBoxName);
    _settingsBox = await Hive.openBox(_settingsBoxName);
  }

  Box get progressBox => _progressBox!;
  Box get settingsBox => _settingsBox!;

  // ---------- پیشرفت حروف ----------
  Map<int, dynamic> get lettersProgress {
    final raw = progressBox.get('letters');
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(int.parse(k.toString()), v));
    }
    return {};
  }

  void saveLettersProgress(Map<int, dynamic> map) {
    final strMap = map.map((k, v) => MapEntry(k.toString(), v));
    progressBox.put('letters', strMap);
  }

  // ---------- پیشرفت اعداد ----------
  Map<int, dynamic> get numbersProgress {
    final raw = progressBox.get('numbers');
    if (raw is Map) {
      return raw.map((k, v) => MapEntry(int.parse(k.toString()), v));
    }
    return {};
  }

  void saveNumbersProgress(Map<int, dynamic> map) {
    final strMap = map.map((k, v) => MapEntry(k.toString(), v));
    progressBox.put('numbers', strMap);
  }

  // ---------- تنظیمات ----------
  T getSetting<T>(String key, T fallback) {
    final value = settingsBox.get(key);
    if (value is T) return value;
    return fallback;
  }

  void setSetting(String key, Object value) {
    settingsBox.put(key, value);
  }

  // ---------- پاک‌سازی کامل پیشرفت ----------
  Future<void> clearProgress() async {
    await progressBox.clear();
  }
}
