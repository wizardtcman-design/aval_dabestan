import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/persian_numbers.dart';
import '../../state/settings_provider.dart';
import '../../widgets/confetti.dart';
import 'game_common.dart';

/// بازی «حافظه» — جفت‌های همسان را پیدا کن
/// حرف ↔ کلمه یا عدد ↔ نام عدد
class MemoryGameScreen extends StatefulWidget {
  final String scope;
  final int? fixedItem;

  const MemoryGameScreen({super.key, required this.scope, this.fixedItem});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryCard {
  final int pairId;
  final bool isFaceSide; // true = حرف/عدد ، false = کلمه/نام
  final String text;
  bool revealed = false;
  bool matched = false;
  _MemoryCard({
    required this.pairId,
    required this.isFaceSide,
    required this.text,
  });
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  late List<_MemoryCard> _cards;
  int _firstIndex = -1;
  bool _lock = false;
  int _mistakes = 0;
  bool _finished = false;
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _deal();
  }

  void _deal() {
    final pool = buildPool(context, widget.scope, widget.fixedItem);
    final items = pickDistinct(pool, 4);
    _cards = [
      for (final item in items) ...[
        _MemoryCard(pairId: item.id, isFaceSide: true, text: item.display),
        _MemoryCard(pairId: item.id, isFaceSide: false, text: item.label),
      ],
    ]..shuffle(Random());
    _firstIndex = -1;
    _lock = false;
    _mistakes = 0;
    _finished = false;
  }

  Future<void> _tap(int index) async {
    if (_lock || _finished) return;
    final card = _cards[index];
    if (card.revealed || card.matched) return;

    final settings = context.read<SettingsProvider>();

    if (_firstIndex == -1) {
      setState(() {
        card.revealed = true;
        _firstIndex = index;
      });
      AppAudio.instance.speak(
        card.text,
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      return;
    }

    final first = _cards[_firstIndex];
    setState(() => card.revealed = true);

    if (first.pairId == card.pairId && first.isFaceSide != card.isFaceSide) {
      // جفت درست
      await Future.delayed(const Duration(milliseconds: 350));
      if (!mounted) return;
      setState(() {
        first.matched = true;
        card.matched = true;
        _firstIndex = -1;
      });
      AppAudio.instance.cheer(
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      if (_cards.every((c) => c.matched)) {
        final stars = _mistakes == 0 ? 3 : (_mistakes <= 4 ? 2 : 1);
        awardStars(context, buildPool(context, widget.scope, widget.fixedItem)
            .firstWhere((p) => p.id == first.pairId), kMemoryGame, stars);
        setState(() {
          _stars = stars;
          _finished = true;
        });
      }
    } else {
      // جفت اشتباه
      _mistakes++;
      _lock = true;
      await Future.delayed(const Duration(milliseconds: 800));
      if (!mounted) return;
      setState(() {
        first.revealed = false;
        card.revealed = false;
        _firstIndex = -1;
        _lock = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'بازی حافظه 🃏',
      subtitle: 'جفت همسان را پیدا کن',
      color: AppColors.purple,
      body: ConfettiBurst(
        play: _finished,
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _cards.length,
                    itemBuilder: (context, i) {
                      final card = _cards[i];
                      final show = card.revealed || card.matched;
                      return GestureDetector(
                        onTap: () => _tap(i),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          transitionBuilder: (child, anim) =>
                              ScaleTransition(scale: anim, child: child),
                          child: Container(
                            key: ValueKey('${i}_$show'),
                            decoration: BoxDecoration(
                              color: card.matched
                                  ? AppColors.successSoft
                                  : (show
                                      ? Colors.white
                                      : AppColors.purple),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: card.matched
                                    ? AppColors.success
                                    : Colors.transparent,
                                width: 2.5,
                              ),
                            ),
                            child: Center(
                              child: show
                                  ? Text(
                                      card.text,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: card.isFaceSide
                                            ? (widget.scope == 'numbers'
                                                ? 26
                                                : 32)
                                            : 13,
                                        fontWeight: FontWeight.w900,
                                        color: card.matched
                                            ? AppColors.success
                                            : AppColors.purpleDark,
                                      ),
                                    )
                                  : const Text(
                                      '؟',
                                      style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'خطاها: ${PersianNumbers.toFa(_mistakes)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: AppColors.textSoft,
                  ),
                ),
              ],
            ),
            if (_finished)
              GameResultOverlay(
                stars: _stars,
                maxStars: 3,
                title: 'حافظه‌ات عالی است!',
                onRetry: () => setState(_deal),
                onClose: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}
