import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../core/utils/persian_numbers.dart';
import '../../state/settings_provider.dart';
import '../../widgets/buttons.dart';
import '../../widgets/confetti.dart';
import 'game_common.dart';

/// بازی «پیدا کن» — حرف یا عدد درست را بین گزینه‌ها پیدا کن
class FindGameScreen extends StatefulWidget {
  final String scope;
  final int? fixedItem;

  const FindGameScreen({super.key, required this.scope, this.fixedItem});

  @override
  State<FindGameScreen> createState() => _FindGameScreenState();
}

class _FindGameScreenState extends State<FindGameScreen> {
  static const int totalRounds = 5;

  late List<GameItem> _pool;
  late GameItem _current;
  late List<GameItem> _options;
  int _round = 1;
  int _score = 0;
  bool _finished = false;
  int _stars = 0;
  int? _wrongPickId;
  int? _rightPickId;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _pool = buildPool(context, widget.scope, widget.fixedItem);
    _newRound(first: true);
  }

  void _newRound({bool first = false}) {
    final rnds = pickDistinct(_pool, 1, exclude: first ? [] : [_current]);
    _current = first ? _pool.first : rnds.first;
    final others = pickDistinct(_pool, 3, exclude: [_current]);
    _options = [...others, _current]..shuffle();
    _wrongPickId = null;
    _rightPickId = null;
    _busy = false;
    _speakQuestion();
  }

  void _speakQuestion() {
    final settings = context.read<SettingsProvider>();
    final q = widget.scope == 'numbers'
        ? 'عدد ${_current.speakText} کدام است؟'
        : 'حرف ${_current.display} کدام است؟';
    AppAudio.instance.speak(
      q,
      soundOn: settings.soundOn,
      rate: settings.speechRate,
    );
  }

  void _pick(GameItem option) {
    if (_busy || _finished) return;
    if (option.id == _current.id && option.isLetter == _current.isLetter) {
      setState(() {
        _rightPickId = option.id;
        _score++;
        _busy = true;
      });
      final settings = context.read<SettingsProvider>();
      AppAudio.instance.cheer(
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      Timer(const Duration(milliseconds: 900), () {
        if (!mounted) return;
        if (_round >= totalRounds) {
          _finish();
        } else {
          setState(() {
            _round++;
            _newRound();
          });
        }
      });
    } else {
      setState(() => _wrongPickId = option.id);
      final settings = context.read<SettingsProvider>();
      AppAudio.instance.speak(
        'این نیست، دوباره نگاه کن',
        soundOn: settings.soundOn,
        rate: settings.speechRate,
      );
      Timer(const Duration(milliseconds: 700), () {
        if (mounted) setState(() => _wrongPickId = null);
      });
    }
  }

  void _finish() {
    final stars = _score >= 5 ? 3 : (_score >= 4 ? 2 : (_score >= 3 ? 1 : 0));
    if (stars > 0) awardStars(context, _current, kFindGame, stars);
    setState(() {
      _stars = stars;
      _finished = true;
    });
  }

  void _retry() {
    setState(() {
      _round = 1;
      _score = 0;
      _finished = false;
      _newRound(first: true);
    });
  }

  String get _question => widget.scope == 'numbers'
      ? 'عدد ${_current.speakText} کدام است؟'
      : 'حرف ${_current.display} کدام است؟';

  @override
  Widget build(BuildContext context) {
    return GameScaffold(
      title: 'بازی پیدا کن 🔍',
      subtitle: 'دور ${PersianNumbers.toFa(_round)} از ${PersianNumbers.toFa(totalRounds)}',
      color: AppColors.mint,
      body: ConfettiBurst(
        play: _finished && _stars > 0,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    children: [
                      Text(
                        _question,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.text,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RoundIconButton(
                        icon: Icons.volume_up_rounded,
                        color: AppColors.mint,
                        size: 46,
                        onTap: _speakQuestion,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.3,
                    ),
                    itemCount: _options.length,
                    itemBuilder: (context, i) {
                      final option = _options[i];
                      final isRight =
                          _rightPickId != null && option.id == _rightPickId;
                      final isWrong = _wrongPickId == option.id;
                      return GestureDetector(
                        onTap: () => _pick(option),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          decoration: BoxDecoration(
                            color: isRight
                                ? AppColors.successSoft
                                : (isWrong
                                    ? AppColors.coralSoft
                                    : AppColors.purpleSoft),
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(
                              color: isRight
                                  ? AppColors.success
                                  : (isWrong
                                      ? AppColors.error
                                      : Colors.transparent),
                              width: 3,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              option.display,
                              style: TextStyle(
                                fontSize: widget.scope == 'numbers' ? 44 : 56,
                                fontWeight: FontWeight.w900,
                                color: AppColors.purpleDark,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'امتیاز: ${PersianNumbers.toFa(_score)}',
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
                title: _stars > 0
                    ? 'آفرین! ${PersianNumbers.toFa(_score)} تا درست پیدا کردی!'
                    : 'اشکالی نداره، دوباره امتحان کن!',
                onRetry: _retry,
                onClose: () => Navigator.of(context).pop(),
              ),
          ],
        ),
      ),
    );
  }
}
