import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../state/settings_provider.dart';
import '../../widgets/confetti.dart';
import 'game_common.dart';

/// بازی «بکش و رها کن» — حرف/عدد را بکش و روی تصویر درست رها کن
class DragDropGameScreen extends StatefulWidget {
  final String scope;
  final int? fixedItem;

  const DragDropGameScreen({super.key, required this.scope, this.fixedItem});

  @override
  State<DragDropGameScreen> createState() => _DragDropGameScreenState();
}

class _DragDropGameScreenState extends State<DragDropGameScreen> {
  late List<GameItem> _pool;
  late List<GameItem> _targets;
  late List<GameItem> _chips;
  final Set<int> _doneIds = {};
  int _mistakes = 0;
  bool _finished = false;
  int _stars = 0;

  @override
  void initState() {
    super.initState();
    _pool = buildPool(context, widget.scope, widget.fixedItem);
    _deal();
  }

  void _deal() {
    _targets = pickDistinct(_pool, 3);
    _chips = [..._targets]..shuffle(Random());
    _doneIds.clear();
    _mistakes = 0;
    _finished = false;
  }

  void _onDropped(GameItem target, GameItem chip) {
    final settings = context.read<SettingsProvider>();
    if (target.id == chip.id && target.isLetter == chip.isLetter) {
      setState(() => _doneIds.add(target.id));
      AppAudio.instance.cheer(
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      if (_doneIds.length == _targets.length) {
        final stars = _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
        awardStars(context, target, kDragDropGame, stars);
        setState(() {
          _stars = stars;
          _finished = true;
        });
      }
    } else {
      setState(() => _mistakes++);
      AppAudio.instance.speak(
        'این جای درست نیست، ببین کجاست',
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isNumber = widget.scope == 'numbers';
    return GameScaffold(
      title: 'بکش و رها کن 🎯',
      subtitle: 'کارتی را که می‌بینی به جای درستش بکش',
      color: const Color(0xFFF2A65A),
      body: ConfettiBurst(
        play: _finished,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ---------- جایگاه‌ها ----------
                Row(
                  children: _targets.map((t) {
                    final done = _doneIds.contains(t.id);
                    return Expanded(
                      child: DragTarget<GameItem>(
                        builder: (context, accepted, rejected) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            height: 130,
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: done
                                  ? AppColors.successSoft
                                  : AppColors.purpleSoft,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: done
                                    ? AppColors.success
                                    : AppColors.purple.withOpacity(0.4),
                                width: 2,
                              ),
                            ),
                            child: done
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.check_circle_rounded,
                                          color: AppColors.success, size: 30),
                                      Text(
                                        t.display,
                                        style: TextStyle(
                                          fontSize: isNumber ? 22 : 28,
                                          fontWeight: FontWeight.w900,
                                          color: AppColors.success,
                                        ),
                                      ),
                                    ],
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(t.emoji,
                                          style:
                                              const TextStyle(fontSize: 30)),
                                      const SizedBox(height: 4),
                                      Text(
                                        t.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.text,
                                        ),
                                      ),
                                    ],
                                  ),
                          );
                        },
                        onAcceptWithDetails: (details) => _onDropped(t, details.data),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                const Center(
                  child: Text(
                    '👇 این‌ها را بکش',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                      color: AppColors.textSoft,
                    ),
                  ),
                ),
                // ---------- کارت‌های قابل کشیدن ----------
                Expanded(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: _chips.where((c) => !_doneIds.contains(c.id)).map(
                      (chip) {
                        return Draggable<GameItem>(
                          data: chip,
                          feedback: Material(
                            color: Colors.transparent,
                            child: _Chip(
                              item: chip,
                              isNumber: isNumber,
                              elevated: true,
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: _Chip(item: chip, isNumber: isNumber),
                          ),
                          child: _Chip(item: chip, isNumber: isNumber),
                        );
                      },
                    ).toList(),
                  ),
                ),
              ],
            ),
            if (_finished)
              GameResultOverlay(
                stars: _stars,
                maxStars: 3,
                title: 'همه را درست جاگذاری کردی!',
                onRetry: () => setState(_deal),
                onClose: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final GameItem item;
  final bool isNumber;
  final bool elevated;

  const _Chip({
    required this.item,
    required this.isNumber,
    this.elevated = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 84,
      height: 84,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(20),
        boxShadow: elevated
            ? [
                BoxShadow(
                  color: AppColors.mint.withOpacity(0.5),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ]
            : const [],
      ),
      child: Center(
        child: Text(
          item.display,
          style: TextStyle(
            fontSize: isNumber ? 30 : 38,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
