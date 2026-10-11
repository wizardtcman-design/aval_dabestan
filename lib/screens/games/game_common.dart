import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/persian_numbers.dart';
import '../../data/data/letters_data.dart';
import '../../data/models/letter_model.dart';
import '../../state/progress_provider.dart';

/// نمای عمومی یک آیتم بازی (حرف یا عدد)
class GameItem {
  final int id;
  final bool isLetter;
  final String display;
  final String label;
  final String emoji;
  final String speakText;

  const GameItem({
    required this.id,
    required this.isLetter,
    required this.display,
    required this.label,
    required this.emoji,
    required this.speakText,
  });
}

/// ترتیب بازی‌ها (برای ثبت ستاره در پروGRESS حروف)
const int kFindGame = 0;
const int kMatchGame = 1;
const int kMemoryGame = 2;
const int kDragDropGame = 3;

/// ساخت مخزن آیتم‌های مجاز برای بازی
/// [scope] = letters | numbers ، [fixedItem] = درس مشخص (از صفحه حرف)
List<GameItem> buildPool(
  BuildContext context,
  String scope,
  int? fixedItem,
) {
  final progress = context.read<ProgressProvider>();
  if (scope == 'numbers') {
    final values = <int>[];
    if (fixedItem != null) {
      values.add(fixedItem);
    } else {
      for (var v = 0; v <= 100; v++) {
        if (progress.isNumberUnlocked(v)) values.add(v);
      }
    }
    return values.map((v) {
      final tens = v ~/ 10;
      final ones = v % 10;
      return GameItem(
        id: v,
        isLetter: false,
        display: PersianNumbers.toFa(v),
        label: PersianNumbers.numberToWords(v),
        emoji: ones == 0 || v < 10 ? '🍎' : (tens.isEven ? '🍎' : '🍊'),
        speakText: PersianNumbers.numberToWords(v),
      );
    }).toList();
  }

  // حروف
  final idxs = <int>[];
  if (fixedItem != null) {
    idxs.add(fixedItem);
  } else {
    for (final l in lettersData) {
      if (progress.isLetterUnlocked(l.index)) idxs.add(l.index);
    }
  }
  return idxs.map((i) {
    final LetterModel l = lettersData[i];
    return GameItem(
      id: i,
      isLetter: true,
      display: l.char,
      label: l.word,
      emoji: l.emoji,
      speakText: l.word,
    );
  }).toList();
}

/// ثبت ستاره بازی بر اساس امتیاز
void awardStars(
  BuildContext context,
  GameItem item,
  int gameIndex,
  int stars,
) {
  final progress = context.read<ProgressProvider>();
  if (item.isLetter) {
    progress.awardGameStar(item.id, gameIndex, stars.clamp(0, 3).toInt());
  } else {
    if (stars > 0) progress.markNumberMatched(item.id);
  }
}

/// انتخاب تصادفی n آیتم متمایز از pool (به‌جز optional exclude)
List<GameItem> pickDistinct(
  List<GameItem> pool,
  int n, {
  List<GameItem> exclude = const [],
  Random? rnd,
}) {
  final random = rnd ?? Random();
  final candidates = pool
      .where(
          (p) => !exclude.any((e) => e.id == p.id && e.isLetter == p.isLetter))
      .toList()
    ..shuffle(random);
  return candidates.take(n).toList();
}

// ----------------------------------------------------------------------
//  اسکلت مشترک صفحه بازی
// ----------------------------------------------------------------------
class GameScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final Widget body;
  final Widget? bottomBar;

  const GameScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.body,
    this.bottomBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Material(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(Icons.close_rounded,
                            color: Colors.white, size: 26),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: color,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(child: body),
              if (bottomBar != null) bottomBar!,
            ],
          ),
        ),
      ),
    );
  }
}

/// نتیجه پایان بازی: ستاره‌ها + جشن + دکمه‌ها
class GameResultOverlay extends StatelessWidget {
  final int stars;
  final int maxStars;
  final String title;
  final VoidCallback onRetry;
  final VoidCallback onClose;

  const GameResultOverlay({
    super.key,
    required this.stars,
    required this.maxStars,
    required this.title,
    required this.onRetry,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      alignment: Alignment.center,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 32),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppColors.softShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🎉', style: TextStyle(fontSize: 56)),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: AppColors.text,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(maxStars, (i) {
                return Icon(
                  i < stars ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: AppColors.star,
                  size: 42,
                );
              }),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onRetry,
                    child: const Text(
                      'دوباره بازی کن',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.mint,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: onClose,
                    child: const Text(
                      'تمام شد',
                      style: TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
