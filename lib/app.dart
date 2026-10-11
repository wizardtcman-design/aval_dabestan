import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

/// ویجت اصلی اپلیکیشن — چیدمان کامل راست‌به‌چپ برای زبان فارسی
class AvalDabestanApp extends StatelessWidget {
  const AvalDabestanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'اول دبستان',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: const HomeScreen(),
    );
  }
}
