import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// دکمه بزرگ قرصی‌شکل مخصوص بچه‌ها
class BigButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Widget? leading;
  final Color color;
  final Color textColor;
  final VoidCallback? onTap;
  final double height;
  final double fontSize;

  const BigButton({
    super.key,
    required this.label,
    this.icon,
    this.leading,
    this.color = AppColors.purple,
    this.textColor = Colors.white,
    this.onTap,
    this.height = 64,
    this.fontSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.35),
                blurRadius: 0,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (leading != null) ...[
                leading!,
                const SizedBox(width: 12),
              ] else if (icon != null) ...[
                Icon(icon, color: textColor, size: 28),
                const SizedBox(width: 10),
              ],
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// دکمه گرد کوچک (مانند دکمه بلندگو)
class RoundIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color iconColor;
  final VoidCallback? onTap;
  final double size;

  const RoundIconButton({
    super.key,
    required this.icon,
    this.color = AppColors.coral,
    this.iconColor = Colors.white,
    this.onTap,
    this.size = 52,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, color: iconColor, size: size * 0.5),
        ),
      ),
    );
  }
}

/// عنوان بخش به شکل قرص رنگی — مثل «تمرین بنویس» و «جدول شمارش»
class SectionPill extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;

  const SectionPill({
    super.key,
    required this.label,
    this.icon,
    this.color = AppColors.mint,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.softShadow,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
