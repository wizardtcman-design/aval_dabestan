import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/letter.dart';
import '../models/number_item.dart';

/// خواندن محتوای آموزشی از فایل‌های JSON داخل خود اپلیکیشن (کاملاً آفلاین)
class ContentRepository {
  ContentRepository._();

  static const String _lettersPath = 'assets/data/letters.json';
  static const String _numbersPath = 'assets/data/numbers.json';

  static Future<List<Letter>> loadLetters() async {
    final String raw = await rootBundle.loadString(_lettersPath);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((item) => Letter.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  static Future<List<NumberItem>> loadNumbers() async {
    final String raw = await rootBundle.loadString(_numbersPath);
    final List<dynamic> data = jsonDecode(raw) as List<dynamic>;
    return data
        .map((item) => NumberItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
