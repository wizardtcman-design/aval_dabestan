import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/persian_numbers.dart';
import '../../state/settings_provider.dart';
import '../../widgets/confetti.dart';
import 'game_common.dart';

/// بازی «جورچین» — هر حرف را به تصویر/کلمه‌اش وصل کن
class MatchGameScreen extends StatefulWidget {
  final String scope;
  final int? fixedItem;

  const MatchGameScreen({super.key, required this.scope, this.fixedItem});

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen> {
  late List<GameItem> _pool;
  late List<GameItem> _roundItems;
  late List<GameItem> _shuffledLabels;
  final Set<int> _matchedIds = {};
  int? _selectedItemId;
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
    _roundItems = pickDistinct(_pool, 3);
    _shuffledLabels = [..._roundItems]..shuffle(Random());
    _matchedIds.clear();
    _selectedItemId = null;
    _mistakes = 0;
    _finished = false;
  }

  void _tapItem(GameItem item) {
    if (_matchedIds.contains(item.id)) return;
    setState(() => _selectedItemId = item.id);
    final settings = context.read<SettingsProvider>();
    AppAudio.instance.speak(
      item.speakText,
      soundOn: settings.soundOn,
      rate: settings.speechRate,
    );
  }

  void _tapLabel(GameItem label) {
    if (_matchedIds.contains(label.id) || _selectedItemId == null) return;
    if (_selectedItemId == label.id) {
      setState(() {
        _matchedIds.add(label.id);
        _selectedItemId = null;
      });
      final settings = context.read<SettingsProvider>();
      AppAudio.instance.cheer(
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      if (_matchedIds.length == _roundItems.length) {
        final stars = _mistakes == 0 ? 3 : (_mistakes <= 2 ? 2 : 1);
        awardStars(context, _roundItems.first, kMatchGame, stars);
        setState(() {
          _stars = stars;
          _finished = true;
        });
      }
    } else {
      setState(() {
        _mistakes++;
        _selectedItemId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'بازی جورچین 🧩',
      subtitle: 'حرف یا عدد را به تصویرش وصل کن',
      color: AppColors.coral,
      body: ConfettiBurst(
        play: _finished,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // ستون آیتم‌ها (حرف/عدد)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _roundItems.map((item) {
                            final matched = _matchedIds.contains(item.id);
                            final selected = _selectedItemId == item.id;
                            return _MatchCard(
                              color: AppColors.purple,
                              soft: AppColors.purpleSoft,
                              selected: selected,
                              matched: matched,
                              onTap: () => _tapItem(item),
                              child: Text(
                                item.display,
                                style: TextStyle(
                                  fontSize:
                                      widget.scope == 'numbers' ? 40 : 52,
                                  fontWeight: FontWeight.w900,
                                  color: matched
                                      ? AppColors.success
                                      : AppColors.purpleDark,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(width: 14),
                      // ستون برچسب‌ها (کلمه + ایموجی)
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: _shuffledLabels.map((item) {
                            final matched = _matchedIds.contains(item.id);
                            return _MatchCard(
                              color: AppColors.coral,
                              soft: AppColors.coralSoft,
                              selected: false,
                              matched: matched,
                              onTap: () => _tapLabel(item),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(item.emoji,
                                      style: const TextStyle(fontSize: 26)),
                                  const SizedBox(height: 2),
                                  Text(
                                    item.label,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w900,
                                      color: matched
                                          ? AppColors.success
                                          : AppColors.text,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'خطاها: ${PersianNumbers.toFa(_mistakes)}',
                  textAlign: TextAlign.center,
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
                title: 'همه جفت‌ها را پیدا کردی!',
                onRetry: () => setState(_deal),
                onClose: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}

class _MatchCard extends StatelessWidget {
  final Color color;
  final Color soft;
  final bool selected;
  final bool matched;
  final VoidCallback onTap;
  final Widget child;

  const _MatchCard({
    required this.color,
    required this.soft,
    required this.selected,
    required this.matched,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 86,
        decoration: BoxDecoration(
          color: matched ? AppColors.successSoft : soft,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: matched
                ? AppColors.success
                : (selected ? color : Colors.transparent),
            width: 3,
          ),
        ),
        child: Center(child: child),
      ),
    );
  }
}
