import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../data/data/letters_data.dart';
import '../../data/models/letter_model.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/app_header.dart';
import '../../widgets/buttons.dart';
import '../../widgets/letter_image.dart';
import 'writing_practice.dart';

/// صفحه آموزش هر حرف:
/// تصویر + صدا + تمرین نوشتن با خطوط نقطه‌چین + چهار بازی
class LetterDetailScreen extends StatefulWidget {
  final int letterIndex;

  const LetterDetailScreen({super.key, required this.letterIndex});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  @override
  void initState() {
    super.initState();
    // بعد از باز شدن صفحه، تلفظ حرف پخش می‌شود
    WidgetsBinding.instance.addPostFrameCallback((_) => _speakLetter());
  }

  void _speakLetter() {
    final letter = lettersData[widget.letterIndex];
    final settings = context.read<SettingsProvider>();
    AppAudio.instance.say(
      assetPath: letter.soundAsset,
      fallbackText: '${letter.char} ، ${letter.word}',
      soundOn: settings.soundOn,
      rate: settings.speechRate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final letter = lettersData[widget.letterIndex];
    final progress = context.watch<ProgressProvider>();
    final lp = progress.letterProgressOf(letter.index);
    final settings = context.watch<SettingsProvider>();
    final totalStars = progress.totalLetterStars;
    final isLast = letter.index == lettersData.length - 1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ---------- هدر ----------
            AppHeader(
              title: 'درس الفبا',
              subtitle: 'حرف امروز را یاد بگیر و تمرین کن! ✨',
              badge: HeaderBadge(
                text: '$totalStars/${progress.maxLetterStars}',
                color: AppColors.star,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                children: [
                  // ---------- حرف بزرگ ----------
                  _BigLetterSection(letter: letter),

                  // ---------- تصویر کلمه ----------
                  const SizedBox(height: 12),
                  _WordImageCard(letter: letter),

                  // ---------- دکمه بشنو ----------
                  const SizedBox(height: 12),
                  BigButton(
                    label: 'بشنو',
                    icon: Icons.volume_up_rounded,
                    color: AppColors.coral,
                    height: 60,
                    onTap: _speakLetter,
                  ),

                  // ---------- تمرین نوشتن ----------
                  const SizedBox(height: 18),
                  _WritingSection(
                    letter: letter,
                    done: lp.writingDone,
                    soundOn: settings.soundOn,
                    rate: settings.speechRate,
                  ),

                  // ---------- بازی‌ها ----------
                  const SizedBox(height: 18),
                  _GamesGrid(letter: letter),

                  // ---------- وضعیت درس بعدی ----------
                  const SizedBox(height: 20),
                  _NextLessonHint(
                    completed: lp.completed,
                    isLast: isLast,
                    accent: letter.accent,
                    letterIndex: letter.index,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
//  حرف بزرگ با حباب گفتار
// =====================================================================
class _BigLetterSection extends StatelessWidget {
  final LetterModel letter;

  const _BigLetterSection({required this.letter});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 6,
            top: 10,
            child: Text('☁️', style: TextStyle(fontSize: 34)),
          ),
          const Positioned(
            right: 6,
            top: 16,
            child: Text('💜', style: TextStyle(fontSize: 26)),
          ),
          Text(
            letter.char,
            style: TextStyle(
              fontSize: 110,
              fontWeight: FontWeight.w900,
              color: AppColors.purpleDark,
              height: 1.0,
            ),
          ),
          // حباب «حرف ب»
          Positioned(
            right: 8,
            top: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.coral,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    letter.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(-10, -3),
                  child: CustomPaint(
                    size: const Size(14, 10),
                    painter: _BubbleTailPainter(AppColors.coral),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BubbleTailPainter extends CustomPainter {
  final Color color;
  _BubbleTailPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(0, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BubbleTailPainter old) => old.color != color;
}

// =====================================================================
//  کارت تصویر کلمه با حاشیه نقطه‌چین
// =====================================================================
class _WordImageCard extends StatelessWidget {
  final LetterModel letter;

  const _WordImageCard({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: letter.accent,
          width: 2,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              letter.accentSoft,
              Colors.white,
            ],
          ),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            LetterImage(letter: letter, size: 190),
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 22, vertical: 9),
              decoration: BoxDecoration(
                color: AppColors.coral,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(letter.emoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Text(
                    letter.word,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
//  بخش تمرین نوشتن
// =====================================================================
class _WritingSection extends StatelessWidget {
  final LetterModel letter;
  final bool done;
  final bool soundOn;
  final double rate;

  const _WritingSection({
    required this.letter,
    required this.done,
    required this.soundOn,
    required this.rate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.mintSoft.withOpacity(0.5),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: AppColors.mint.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SectionPill(label: 'تمرین بنویس', icon: Icons.edit_rounded),
              const SizedBox(width: 10),
              Icon(
                done ? Icons.check_circle_rounded : Icons.star_outline_rounded,
                color: done ? AppColors.success : AppColors.textSoft,
                size: 26,
              ),
            ],
          ),
          const SizedBox(height: 12),
          WritingPractice(
            char: letter.char,
            accent: letter.accent,
            alreadyDone: done,
            onDone: () {
              context.read<ProgressProvider>().completeWriting(letter.index);
              AppAudio.instance.speak(
                'آفرین! خیلی خوب نوشتی',
                soundOn: soundOn,
                rate: rate,
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================================
//  شبکه بازی‌ها (۴ بازی)
// =====================================================================
class _GamesGrid extends StatelessWidget {
  final LetterModel letter;

  const _GamesGrid({required this.letter});

  static const List<({String label, String emoji, Color color, String route})>
      games = [
    (label: 'پیدا کن', emoji: '🔍', color: AppColors.mint, route: 'find'),
    (label: 'جورچین', emoji: '🧩', color: AppColors.coral, route: 'match'),
    (label: 'حافظه', emoji: '🃏', color: AppColors.purple, route: 'memory'),
    (
      label: 'بکش و رها کن',
      emoji: '🎯',
      color: Color(0xFFF2A65A),
      route: 'dragdrop'
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.55,
      ),
      itemCount: games.length,
      itemBuilder: (context, i) {
        final g = games[i];
        return Material(
          color: g.color,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.pushNamed(
              context,
              '/game/${g.route}?scope=letters&item=${letter.index}',
            ),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: g.color.withOpacity(0.4),
                    blurRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(g.emoji, style: const TextStyle(fontSize: 26)),
                  const SizedBox(height: 4),
                  Text(
                    g.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// =====================================================================
//  راهنمای درس بعدی
// =====================================================================
class _NextLessonHint extends StatelessWidget {
  final bool completed;
  final bool isLast;
  final Color accent;
  final int letterIndex;

  const _NextLessonHint({
    required this.completed,
    required this.isLast,
    required this.accent,
    required this.letterIndex,
  });

  @override
  Widget build(BuildContext context) {
    if (isLast && completed) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.successSoft,
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Text(
          '🏆 آفرین! همه حرف‌ها را یاد گرفتی!',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: accent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed
            ? '✅ این درس کامل شد — درس بعدی باز شد!'
            : '🔒 برای باز شدن درس بعدی: تمرین نوشتن + ۴ بازی را کامل کن',
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 14,
          color: AppColors.text,
        ),
      ),
    );
  }
}
