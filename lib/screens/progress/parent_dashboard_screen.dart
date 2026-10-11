import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/persian_numbers.dart';
import '../../data/data/letters_data.dart';
import '../../data/models/letter_model.dart';
import '../../state/progress_provider.dart';
import '../../widgets/app_header.dart';
import '../../widgets/confetti.dart';

/// داشبورد والدین — نمای کلی پیشرفت دانش‌آموز
class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progress = context.watch<ProgressProvider>();
    final percent = (progress.overallPercent * 100).round();

    return Scaffold(
      body: Column(
        children: [
          AppHeader(
            title: 'داشبورد والدین',
            subtitle: 'گزارش پیشرفت یادگیری فرزند شما',
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ---------- آمار کلی ----------
                Row(
                  children: [
                    _StatCard(
                      emoji: '⭐',
                      value: PersianNumbers.toFa(progress.totalLetterStars +
                          progress.totalNumberStars),
                      label: 'ستاره کل',
                      color: AppColors.star,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      emoji: '🔤',
                      value:
                          '${PersianNumbers.toFa(progress.completedLettersCount)}/${PersianNumbers.toFa(lettersData.length)}',
                      label: 'حرف کامل‌شده',
                      color: AppColors.purple,
                    ),
                    const SizedBox(width: 10),
                    _StatCard(
                      emoji: '🔢',
                      value: PersianNumbers.toFa(progress.completedNumbersCount),
                      label: 'عدد کامل‌شده',
                      color: AppColors.coral,
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ---------- نوار پیشرفت کلی ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'پیشرفت کلی',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                          Text(
                            '٪${PersianNumbers.toFa(percent)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                              color: AppColors.purple,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: progress.overallPercent,
                          minHeight: 14,
                          backgroundColor: AppColors.purpleSoft,
                          valueColor: const AlwaysStoppedAnimation(
                              AppColors.mint),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- حالت آزاد ----------
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: SwitchListTile(
                    value: progress.freeMode,
                    onChanged: (v) =>
                        context.read<ProgressProvider>().setFreeMode(v),
                    title: const Text(
                      'حالت آزاد (باز کردن همه درس‌ها)',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                    subtitle: const Text(
                      'برای تمرین آزاد کودک بدون قفل مرحله‌ای',
                      style: TextStyle(fontSize: 12),
                    ),
                    activeColor: AppColors.mint,
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- پیشرفت هر حرف ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'پیشرفت حروف الفبا',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...lettersData.map((l) {
                        final lp = progress.letterProgressOf(l.index);
                        final ratio = lp.stars / LetterProgress.maxStars;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: lp.completed
                                      ? AppColors.successSoft
                                      : l.accentSoft,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  lp.completed ? '✅' : l.char,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: l.accent,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l.word,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                        ),
                                        StarRow(
                                          filled: lp.stars.clamp(0, 5).toInt(),
                                          total: 5,
                                          size: 12,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(6),
                                      child: LinearProgressIndicator(
                                        value: ratio,
                                        minHeight: 7,
                                        backgroundColor:
                                            l.accentSoft,
                                        valueColor:
                                            AlwaysStoppedAnimation(
                                                l.accent),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- پاک کردن پیشرفت ----------
                Material(
                  color: AppColors.coralSoft,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => _confirmReset(context),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete_forever_rounded,
                              color: AppColors.error),
                          SizedBox(width: 10),
                          Text(
                            'پاک کردن همه پیشرفت‌ها',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.purpleSoft.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    '🔒 همه داده‌ها فقط روی همین گوشی ذخیره می‌شوند و هیچ اطلاعاتی به اینترنت فرستاده نمی‌شود.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmReset(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('پاک کردن پیشرفت؟'),
        content: const Text(
          'همه ستاره‌ها و درس‌های بازشده پاک می‌شوند و اپ از ابتدا شروع می‌کند. مطمئن هستید؟',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('بی‌خیال'),
          ),
          TextButton(
            onPressed: () async {
              await context.read<ProgressProvider>().resetAll();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: const Text(
              'بله، پاک کن',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: AppColors.softShadow,
          border: Border.all(color: color.withOpacity(0.35)),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 4),
            FittedBox(
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  color: color,
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: AppColors.textSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
