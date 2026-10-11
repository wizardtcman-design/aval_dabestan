import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

/// تم سراسری اپلیکیشن — فارسی، RTL، فونت وزیرمتن، رنگ‌های سازمانی
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      fontFamily: 'Vazirmatn',
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.purple,
        primary: AppColors.purple,
        secondary: AppColors.coral,
        surface: AppColors.background,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: const TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w900,
            color: AppColors.text),
        displayMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w900,
            color: AppColors.text),
        headlineLarge: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w900,
            color: AppColors.text),
        headlineMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
            color: AppColors.text),
        titleLarge: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
            color: AppColors.text),
        titleMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
            color: AppColors.text),
        bodyLarge: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w500,
            color: AppColors.text),
        bodyMedium: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w400,
            color: AppColors.text),
        labelLarge: TextStyle(
            fontFamily: 'Vazirmatn',
            fontWeight: FontWeight.w700,
            color: AppColors.text),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        titleTextStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          fontWeight: FontWeight.w900,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.text,
        contentTextStyle: TextStyle(
          fontFamily: 'Vazirmatn',
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14)),
        ),
      ),
      dialogTheme: DialogTheme(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        titleTextStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontWeight: FontWeight.w900,
          fontSize: 18,
          color: AppColors.text,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Vazirmatn',
          fontWeight: FontWeight.w500,
          fontSize: 15,
          color: AppColors.text,
        ),
      ),
    );
    return base;
  }
}
