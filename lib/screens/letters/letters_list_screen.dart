import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../data/data/letters_data.dart';
import '../../data/models/letter_model.dart';
import '../../state/progress_provider.dart';
import '../../widgets/app_header.dart';
import '../../widgets/confetti.dart';
import 'letter_detail_screen.dart';

/// لیست حروف الفبا با قفل مرحله‌ای
/// تا درس قبلی کامل نشود (تمرین + ۴ بازی)، درس بعدی باز نمی‌شود.
class LettersListScreen extends StatelessWidget {
  const LettersListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final done = progress.completedLettersCount;

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'حروف الفبا',
            subtitle: 'بیا با هم حرف‌ها را یاد بگیریم! ✨',
            badge: HeaderBadge(text: '$done/${lettersData.length}'),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              itemCount: lettersData.length,
              itemBuilder: (context, i) {
                return _LetterCard(letter: lettersData[i]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LetterCard extends StatelessWidget {
  final LetterModel letter;

  const _LetterCard({required this.letter});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final lp = progress.letterProgressOf(letter.index);
    final unlocked = progress.isLetterUnlocked(letter.index);
    final completed = lp.completed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: () {
          if (unlocked) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    LetterDetailScreen(letterIndex: letter.index),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('اول درس قبلی را کامل کن تا این حرف باز شود! 🔒'),
              ),
            );
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: unlocked
                ? Colors.white
                : Colors.white.withOpacity(0.55),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: unlocked
                  ? letter.accent.withOpacity(0.5)
                  : Colors.grey.withOpacity(0.25),
              width: 2,
            ),
            boxShadow: unlocked ? AppColors.softShadow : [],
          ),
          child: Row(
              children: [
                // دایره حرف
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: unlocked ? letter.accent : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    unlocked ? letter.char : '🔒',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      color: unlocked ? Colors.white : AppColors.textSoft,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        unlocked ? letter.word : 'درس ${letter.index + 1}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color:
                              unlocked ? AppColors.text : AppColors.textSoft,
                        ),
                      ),
                      const SizedBox(height: 2),
                      if (unlocked)
                        Row(
                          children: [
                            StarRow(filled: lp.stars, total: 5, size: 15),
                            const SizedBox(width: 8),
                            if (completed)
                              const Icon(Icons.check_circle_rounded,
                                  color: AppColors.success, size: 18),
                          ],
                        )
                      else
                        Text(
                          'اول درس قبلی را کامل کن',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSoft,
                          ),
                        ),
                    ],
                  ),
                ),
                if (unlocked)
                  Icon(
                    Icons.chevron_left_rounded,
                    color: letter.accent,
                    size: 30,
                  ),
              ],
          ),
        ),
      ),
    );
  }
}
