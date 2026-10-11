import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/progress.dart';

/// خواندن و نوشتن پیشرفت یادگیری در حافظه محلی گوشی
class ProgressService {
  static const String _storageKey = 'aval_dabestan_progress_v1';

  Future<Progress> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_storageKey);
    if (raw == null || raw.isEmpty) return const Progress();
    try {
      return Progress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const Progress();
    }
  }

  Future<void> save(Progress progress) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(progress.toJson()));
  }

  /// حرف را به‌عنوان یادگرفته‌شده ثبت می‌کند و پیشرفت جدید را برمی‌گرداند
  Future<Progress> completeLetter(String letterId, {int stars = 1}) async {
    final Progress current = await load();
    final Progress updated = current.copyWith(
      completedLetters: <String>{...current.completedLetters, letterId},
      letterStars: <String, int>{...current.letterStars, letterId: stars},
    );
    await save(updated);
    return updated;
  }
}
