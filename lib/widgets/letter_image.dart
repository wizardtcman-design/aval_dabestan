import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import '../data/models/letter_model.dart';

/// تصویر حرف: اگر فایل تصویر در assets موجود باشد نمایش داده می‌شود،
/// وگرنه کارت ایموجی زیبا با پس‌زمینه رنگی (کاملاً آفلاین و بدون خطا)
class LetterImage extends StatelessWidget {
  final LetterModel letter;
  final double size;

  const LetterImage({super.key, required this.letter, this.size = 200});

  @override
  Widget build(BuildContext context) {
    final asset = letter.imageAsset;
    if (asset != null) {
      return Image.asset(
        asset,
        width: size,
        height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _emojiFallback(),
      );
    }
    return _emojiFallback();
  }

  Widget _emojiFallback() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: letter.accentSoft,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: letter.accent.withOpacity(0.35), width: 2),
      ),
      child: Center(
        child: Text(
          letter.emoji,
          style: TextStyle(fontSize: size * 0.5),
        ),
      ),
    );
  }
}
