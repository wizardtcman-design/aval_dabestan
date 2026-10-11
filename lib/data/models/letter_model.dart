import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

/// مدل هر حرف الفبا به ترتیب کتاب فارسی کلاس اول دبستان
class LetterModel {
  /// ترتیب درس (۰ تا ۳۲)
  final int index;

  /// خود حرف
  final String char;

  /// نام درس برای نمایش، مثل «حرف ب»
  final String name;

  /// کلمه نمونه مطابق کتاب درسی (آشیانه، بره، ...)
  final String word;

  /// ایموجی جایگزین تصویر (وقتی فایل تصویر موجود نیست)
  final String emoji;

  /// مسیر فایل تصویر داخل assets (اختیاری)
  final String? imageAsset;

  /// مسیر فایل صوتی داخل assets (اختیاری - در صورت وجود پخش می‌شود)
  final String soundAsset;

  /// رنگ شاخص این حرف از پالت
  final Color accent;

  /// رنگ ملایم متناظر
  final Color accentSoft;

  const LetterModel({
    required this.index,
    required this.char,
    required this.name,
    required this.word,
    required this.emoji,
    this.imageAsset,
    required this.soundAsset,
    required this.accent,
    required this.accentSoft,
  });

  String get lessonTitle => 'حرف ${char}';
}

/// مدل هر عدد ۰ تا ۱۰۰
class NumberModel {
  final int value;
  final String faDigits;
  final String name;
  final String emoji;

  const NumberModel({
    required this.value,
    required this.faDigits,
    required this.name,
    this.emoji = '🍎',
  });
}

/// پیشرفت هر حرف: تمرین نوشتن + ۴ بازی
class LetterProgress {
  /// تمرین نوشتن انجام شده؟
  bool writingDone;

  /// ستاره‌های ۴ بازی: [پیدا کن، جورچین، حافظه، بکش و رها کن]
  /// مقدار ۰ تا ۳
  List<int> gameStars;

  LetterProgress({
    this.writingDone = false,
    List<int>? gameStars,
  }) : gameStars = gameStars ?? [0, 0, 0, 0];

  int get stars =>
      (writingDone ? 1 : 0) + gameStars.fold(0, (a, b) => a + b);

  /// بیشینه ستاره: نوشتن (۱) + چهار بازی (هر کدام ۳)
  static const int maxStars = 13;

  /// همه ۴ بازی حداقل یک ستاره گرفته‌اند؟
  bool get allGamesPlayed => gameStars.every((s) => s > 0);

  /// درس کامل شده؟ (تمرین نوشتن + هر ۴ بازی)
  bool get completed => writingDone && allGamesPlayed;

  Map<String, dynamic> toMap() => {
        'writingDone': writingDone,
        'gameStars': gameStars,
      };

  factory LetterProgress.fromMap(dynamic map) {
    final m = Map<String, dynamic>.from(map as Map);
    final starsRaw = List<dynamic>.from(m['gameStars'] ?? []);
    return LetterProgress(
      writingDone: (m['writingDone'] ?? false) == true,
      gameStars: starsRaw.map((e) => (e as num).toInt()).toList(),
    ).._fixStars();
  }

  void _fixStars() {
    if (gameStars.length != 4) {
      gameStars = [0, 0, 0, 0];
    }
  }
}

/// پروGRESS هر عدد
class NumberProgress {
  /// شنیده و دیده شده (ستاره شنیدن)
  bool learned;

  /// بازی تطبیق/جفت انجام شده
  bool matched;

  NumberProgress({this.learned = false, this.matched = false});

  int get stars => (learned ? 1 : 0) + (matched ? 1 : 0);
  static const int maxStars = 2;
  bool get completed => learned && matched;

  Map<String, dynamic> toMap() => {'learned': learned, 'matched': matched};

  factory NumberProgress.fromMap(dynamic map) {
    final m = Map<String, dynamic>.from(map as Map);
    return NumberProgress(
      learned: (m['learned'] ?? false) == true,
      matched: (m['matched'] ?? false) == true,
    );
  }
}
