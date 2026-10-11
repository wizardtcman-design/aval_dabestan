import 'package:flutter/material.dart';

/// پالت رنگ سازمانی اپلیکیشن آموزش کلاس اول
class AppColors {
  AppColors._();

  // ---------- رنگ‌های اصلی ----------
  /// بنفش ملایم — رنگ اصلی برند
  static const Color purple = Color(0xFF9B7EBD);

  /// مرجانی
  static const Color coral = Color(0xFFFF6B6B);

  /// نعنایی
  static const Color mint = Color(0xFF4ECDC4);

  /// پس‌زمینه
  static const Color background = Color(0xFFFDF6F0);

  /// متن اصلی
  static const Color text = Color(0xFF2C3E50);

  // ---------- سایه‌های کمکی ----------
  /// بنفش تیره (تیترها و هدرها)
  static const Color purpleDark = Color(0xFF5D4A7E);

  /// زرد ستاره‌ها
  static const Color star = Color(0xFFFFC94D);

  /// سبز موفقیت
  static const Color success = Color(0xFF3FBF8F);

  /// قرمز خطا
  static const Color error = Color(0xFFE85D5D);

  /// متن کم‌رنگ
  static const Color textSoft = Color(0xFF8A94A6);

  // ---------- رنگ‌های ملایم پس‌زمینه کارت‌ها ----------
  static const Color purpleSoft = Color(0xFFEDE6F7);
  static const Color coralSoft = Color(0xFFFFE8E4);
  static const Color mintSoft = Color(0xFFDFF6F2);
  static const Color starSoft = Color(0xFFFFF3D9);
  static const Color successSoft = Color(0xFFE2F6EC);

  /// سایه پیش‌فرض
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.07),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  /// پالت چرخشی برای کارت حروف
  static const List<Color> letterPalette = [
    purple,
    coral,
    mint,
    Color(0xFFF2A65A),
    Color(0xFF7FB77E),
    Color(0xFFD66BA0),
  ];

  /// پالت پس‌زمینه ملایم متناظر با letterPalette
  static const List<Color> letterSoftPalette = [
    purpleSoft,
    coralSoft,
    mintSoft,
    Color(0xFFFDEBDD),
    Color(0xFFE4F2E4),
    Color(0xFFFAE4EF),
  ];
}
