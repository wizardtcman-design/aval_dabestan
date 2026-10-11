import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// هدر بنفش گرد که بالای صفحات داخلی قرار می‌گیرد
/// مطابق طرح: دکمه بازگشت + عنوان + زیرعنوان + نشان پیشرفت
class AppHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? badge;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle = '',
    this.badge,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 18),
      decoration: const BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Row(
              children: [
                _CircleIconBtn(
                  icon: Icons.arrow_back_rounded,
                  onTap: onBack ?? () => Navigator.of(context).maybePop(),
                ),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(child: badge),
                ),
              ],
            ),
            if (subtitle.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// دکمه دایره‌ای سفید (بازگشت و غیره)
class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  const _CircleIconBtn({
    required this.icon,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: AppColors.purple, size: 26),
        ),
      ),
    );
  }
}

/// نشان پیشرفت (مثل ۵۰/۱۰۰ با ستاره)
class HeaderBadge extends StatelessWidget {
  final String text;
  final Color color;

  const HeaderBadge({super.key, required this.text, this.color = AppColors.mint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
