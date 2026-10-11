import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/persian_numbers.dart';
import '../../data/data/numbers_data.dart';
import '../../data/models/letter_model.dart';
import '../../state/progress_provider.dart';
import '../../state/settings_provider.dart';
import '../../widgets/app_header.dart';
import '../../widgets/buttons.dart';
import '../main_shell.dart';

/// صفحه اعداد ۰ تا ۱۰۰:
/// عدد بزرگ + شمارش تصویری + جدول شمارش ۱ تا ۱۰۰ + بازی پیدا کردن جفت
class NumbersHomeScreen extends StatefulWidget {
  const NumbersHomeScreen({super.key});

  @override
  State<NumbersHomeScreen> createState() => _NumbersHomeScreenState();
}

class _NumbersHomeScreenState extends State<NumbersHomeScreen> {
  int _index = 0; // اندیس در numbersData (۰ تا ۱۰۰)

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final progress = context.read<ProgressProvider>();
      final startGroup = progress.currentNumberGroup;
      setState(() {
        _index = (startGroup * 10).clamp(0, 100).toInt();
      });
      _announce();
    });
  }

  void _announce() {
    final number = numbersData[_index];
    final settings = context.read<SettingsProvider>();
    context.read<ProgressProvider>().markNumberLearned(number.value);
    AppAudio.instance.say(
      assetPath: 'assets/sounds/number_${number.value}.mp3',
      fallbackText: number.name,
      soundOn: settings.soundOn,
      rate: settings.speechRate,
    );
  }

  void _go(int index) {
    final clamped = index.clamp(0, 100).toInt();
    final progress = context.read<ProgressProvider>();
    if (!progress.isNumberUnlocked(clamped)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('اول اعداد قبلی را کامل کن تا این عدد باز شود! 🔒'),
        ),
      );
      return;
    }
    setState(() => _index = clamped);
    _announce();
  }

  @override
  Widget build(BuildContext context) {
    final number = numbersData[_index];
    final progress = context.watch<ProgressProvider>();
    final settings = context.watch<SettingsProvider>();
    final totalStars = progress.totalNumberStars;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- هدر ----------
              _NumbersHeader(
                badgeText: '$totalStars/${progress.maxNumberStars}',
                onBack: () => Navigator.of(context).maybePop(),
              ),

              const SizedBox(height: 12),

              // ---------- عدد بزرگ ----------
              _BigNumberSection(number: number),

              // ---------- شمارش تصویری ----------
              const SizedBox(height: 12),
              _CountingSection(value: number.value),

              // ---------- جدول شمارش ----------
              const SizedBox(height: 16),
              _NumberGrid(current: number.value, onTap: _go),

              // ---------- بازی پیدا کردن جفت ----------
              const SizedBox(height: 16),
              _PairGameSection(
                key: ValueKey('pair_${number.value}'),
                number: number,
                soundOn: settings.soundOn,
                rate: settings.speechRate,
                onWin: () {
                  context
                      .read<ProgressProvider>()
                      .markNumberMatched(number.value);
                  AppAudio.instance.cheer(
                    soundOn: settings.soundOn,
                    rate: settings.speechRate,
                  );
                },
              ),

              // ---------- ردیف پایین ----------
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: BigButton(
                      label: 'خانه',
                      icon: Icons.home_rounded,
                      color: AppColors.purple,
                      height: 56,
                      fontSize: 16,
                      onTap: () {
                        Navigator.of(context).pop();
                        MainShell.of(context)?.goToTab(0);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  RoundIconButton(
                    icon: Icons.star_rounded,
                    color: AppColors.coral,
                    size: 58,
                    onTap: _announce,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: BigButton(
                      label: 'بعدی',
                      icon: Icons.check_rounded,
                      color: AppColors.mint,
                      height: 56,
                      fontSize: 16,
                      onTap: () => _go(_index + 1),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =====================================================================
//  هدر اعداد
// =====================================================================
class _NumbersHeader extends StatelessWidget {
  final String badgeText;
  final VoidCallback onBack;

  const _NumbersHeader({required this.badgeText, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: AppColors.purple,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onBack,
              child: const SizedBox(
                width: 44,
                height: 44,
                child: Icon(Icons.arrow_back_rounded,
                    color: AppColors.purple, size: 26),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: const [
                Text(
                  'اعداد ۰ تا ۱۰۰',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  'بیا با هم اعداد رو یاد بگیریم!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Icon(Icons.star_rounded,
                    color: Colors.white, size: 18),
                Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
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

// =====================================================================
//  نمایش عدد بزرگ دو رنگ + نام + بلندگو
// =====================================================================
class _BigNumberSection extends StatelessWidget {
  final NumberModel number;

  const _BigNumberSection({required this.number});

  @override
  Widget build(BuildContext context) {
    final digits = number.faDigits;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🍎', style: TextStyle(fontSize: 44)),
              const SizedBox(width: 16),
              // عدد دو رنگ مثل طرح
              Row(
                children: List.generate(digits.length, (i) {
                  return Text(
                    digits[i],
                    style: TextStyle(
                      fontSize: 84,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                      color: i.isEven ? AppColors.purple : AppColors.coral,
                    ),
                  );
                }),
              ),
              const SizedBox(width: 16),
              const Text('🍊', style: TextStyle(fontSize: 44)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundIconButton(
                icon: Icons.volume_up_rounded,
                color: AppColors.coral,
                size: 46,
                onTap: () {
                  final settings = context.read<SettingsProvider>();
                  AppAudio.instance.speak(
                    number.name,
                    soundOn: settings.soundOn,
                    rate: settings.speechRate,
                  );
                },
              ),
              const SizedBox(width: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.coral,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Text(
                  number.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =====================================================================
//  شمارش تصویری: تا ۲۰ با میوه، بیشتر با بسته‌های ده‌تایی
// =====================================================================
class _CountingSection extends StatelessWidget {
  final int value;

  const _CountingSection({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.starSoft.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.star.withOpacity(0.5)),
      ),
      child: value <= 20
          ? _FruitCount(value: value)
          : _BundleCount(value: value),
    );
  }
}

class _FruitCount extends StatelessWidget {
  final int value;

  const _FruitCount({required this.value});

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return const Center(
        child: Text(
          'هیچ! هنوز چیزی نیست 🙂',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
        ),
      );
    }
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 4,
      runSpacing: 2,
      children: List.generate(value, (i) {
        return Text(
          i.isEven ? '🍎' : '🍊',
          style: const TextStyle(fontSize: 26),
        );
      }),
    );
  }
}

class _BundleCount extends StatelessWidget {
  final int value;

  const _BundleCount({required this.value});

  @override
  Widget build(BuildContext context) {
    final tens = value ~/ 10;
    final ones = value % 10;
    return Column(
      children: [
        Text(
          '${PersianNumbers.toFa(tens)} بستهٔ ده‌تایی'
          '${ones > 0 ? ' و ${PersianNumbers.toFa(ones)} تا' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
        ),
        const SizedBox(height: 8),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            ...List.generate(tens, (i) => _bundle(i)),
            if (ones > 0) _loose(ones),
          ],
        ),
      ],
    );
  }

  Widget _bundle(int i) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.mint, width: 1.6),
      ),
      child: Text('🍎' * 10, style: const TextStyle(fontSize: 12, height: 1.1)),
    );
  }

  Widget _loose(int n) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.coral, width: 1.6),
      ),
      child: Text(
        List.generate(n, (i) => i.isEven ? '🍊' : '🍎').join(),
        style: const TextStyle(fontSize: 13, height: 1.1),
      ),
    );
  }
}

// =====================================================================
//  جدول شمارش ۱ تا ۱۰۰
// =====================================================================
class _NumberGrid extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const _NumberGrid({required this.current, required this.onTap});

  static const _cellColors = [
    AppColors.purpleSoft,
    AppColors.coralSoft,
    AppColors.mintSoft,
    AppColors.starSoft,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          const SectionPill(
            label: 'جدول شمارش',
            icon: Icons.grid_view_rounded,
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 6,
              crossAxisSpacing: 6,
              childAspectRatio: 1.25,
            ),
            itemCount: 100,
            itemBuilder: (context, i) {
              final value = i + 1; // ۱ تا ۱۰۰
              final isCurrent = value == current;
              final unlocked =
                  context.watch<ProgressProvider>().isNumberUnlocked(value);
              final color = _cellColors[((value - 1) ~/ 5) % 4];
              return GestureDetector(
                onTap: () => onTap(value),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  decoration: BoxDecoration(
                    color: unlocked ? color : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isCurrent ? AppColors.coral : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        PersianNumbers.toFa(value),
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: unlocked
                              ? AppColors.text
                              : AppColors.textSoft.withOpacity(0.5),
                        ),
                      ),
                      if (isCurrent)
                        const Positioned(
                          top: -2,
                          left: 2,
                          child: Icon(Icons.star_rounded,
                              color: AppColors.star, size: 16),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

// =====================================================================
//  بازی پیدا کردن جفت عدد
// =====================================================================
class _PairGameSection extends StatefulWidget {
  final NumberModel number;
  final bool soundOn;
  final double rate;
  final VoidCallback onWin;

  const _PairGameSection({
    super.key,
    required this.number,
    required this.soundOn,
    required this.rate,
    required this.onWin,
  });

  @override
  State<_PairGameSection> createState() => _PairGameSectionState();
}

class _PairGameSectionState extends State<_PairGameSection> {
  late List<_PairCard> _cards;
  final Set<int> _found = {};
  int? _firstPick;

  @override
  void initState() {
    super.initState();
    _deal();
  }

  void _deal() {
    final value = widget.number.value;
    // دو کارت با عدد درست + دو کارت عدد دیگر
    int decoy;
    do {
      decoy = (value + 1 + (value * 7) % 13) % 101;
    } while (decoy == value);
    _cards = [
      _PairCard(value: value, emoji: '🍎', correct: true),
      _PairCard(value: value, emoji: '🍊', correct: true),
      _PairCard(value: decoy, emoji: '🍋', correct: false),
      _PairCard(value: decoy, emoji: '🍇', correct: false),
    ]..shuffle();
    _found.clear();
    _firstPick = null;
  }

  void _tap(int i) {
    if (_found.contains(i) || _found.length == 2) return;
    final card = _cards[i];
    if (!card.correct) {
      AppAudio.instance.speak(
        'این یکی نیست، دوباره امتحان کن',
        soundOn: widget.soundOn,
        rate: widget.rate,
      );
      return;
    }
    setState(() {
      _found.add(i);
      if (_found.length == 2) {
        widget.onWin();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final win = _found.length == 2;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        children: [
          SectionPill(
            label: 'بازی پیدا کردن جفت',
            icon: Icons.extension_rounded,
            color: AppColors.mint,
          ),
          const SizedBox(height: 12),
          if (win)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.celebration_rounded,
                      color: AppColors.star, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    'آفرین! جفت ${widget.number.name} را پیدا کردی!',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 15),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => setState(_deal),
                    child: const Text('دوباره 🔁'),
                  ),
                ],
              ),
            ),
          Row(
            children: List.generate(4, (i) {
              final card = _cards[i];
              final revealed = _found.contains(i);
              return Expanded(
                child: GestureDetector(
                  onTap: () => _tap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 92,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: revealed
                          ? AppColors.mintSoft
                          : _cardBg(i),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: revealed ? AppColors.mint : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(card.emoji,
                            style: const TextStyle(fontSize: 26)),
                        Text(
                          revealed || card.correct
                              ? PersianNumbers.toFa(card.value)
                              : '؟',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: revealed
                                ? AppColors.mint
                                : AppColors.purple,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Color _cardBg(int i) {
    const bgs = [
      AppColors.purpleSoft,
      AppColors.coralSoft,
      AppColors.starSoft,
      AppColors.mintSoft,
    ];
    return bgs[i % 4];
  }
}

class _PairCard {
  final int value;
  final String emoji;
  final bool correct;
  _PairCard({
    required this.value,
    required this.emoji,
    required this.correct,
  });
}
