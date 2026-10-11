import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../widgets/confetti.dart';

/// تمرین نوشتن حرف با انگشت (یا قلم) روی خطوط نقطه‌چین
/// حرف محو (شبح) سمت راست هر خط است و کودک روی آن می‌کشد.
/// وقتی پوشش کافی باشد، تمرین تایید می‌شود.
class WritingPractice extends StatefulWidget {
  final String char;
  final Color accent;
  final bool alreadyDone;
  final VoidCallback onDone;

  const WritingPractice({
    super.key,
    required this.char,
    required this.accent,
    required this.alreadyDone,
    required this.onDone,
  });

  @override
  State<WritingPractice> createState() => _WritingPracticeState();
}

class _WritingPracticeState extends State<WritingPractice> {
  static const int _bands = 3;
  static const double _cell = 26.0;
  static const double _passRatio = 0.42;

  final List<List<Offset>> _strokes = [];
  List<Offset> _active = [];
  bool _celebrate = false;

  void _clear() => setState(() {
        _strokes.clear();
        _celebrate = false;
      });

  void _checkCoverage(Size size) {
    final zones = _letterZones(size);
    final painted = <String>{};
    var total = 0;
    for (final zone in zones) {
      for (double x = zone.left; x < zone.right; x += _cell) {
        for (double y = zone.top; y < zone.bottom; y += _cell) {
          total++;
        }
      }
    }
    if (total == 0) return;
    for (final stroke in _strokes) {
      for (final p in stroke) {
        final key =
            '${(p.dx / _cell).floor()}_${(p.dy / _cell).floor()}';
        painted.add(key);
      }
    }
    // چند سلول رنگ‌شده داخل ناحیه‌های حرف
    var hit = 0;
    for (final zone in zones) {
      for (double x = zone.left; x < zone.right; x += _cell) {
        for (double y = zone.top; y < zone.bottom; y += _cell) {
          final key =
              '${(x / _cell).floor()}_${(y / _cell).floor()}';
          if (painted.contains(key)) hit++;
        }
      }
    }
    if (hit / total >= _passRatio && !_celebrate) {
      setState(() => _celebrate = true);
      widget.onDone();
    }
  }

  List<Rect> _letterZones(Size size) {
    final bandH = size.height / _bands;
    return List.generate(_bands, (i) {
      final top = i * bandH;
      return Rect.fromLTWH(
        size.width * 0.60,
        top + bandH * 0.08,
        size.width * 0.36,
        bandH * 0.84,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ConfettiBurst(
          play: _celebrate,
          child: Container(
            height: 240,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final size = Size(
                  constraints.maxWidth,
                  constraints.maxHeight,
                );
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onPanStart: (d) =>
                      setState(() => _active = [d.localPosition]),
                  onPanUpdate: (d) =>
                      setState(() => _active.add(d.localPosition)),
                  onPanEnd: (_) {
                    setState(() {
                      if (_active.length > 1) _strokes.add(_active);
                      _active = [];
                    });
                    _checkCoverage(size);
                  },
                  child: CustomPaint(
                    size: Size.infinite,
                    painter: _TracingPainter(
                      char: widget.char,
                      accent: widget.accent,
                      strokes: _strokes,
                      active: _active,
                      bands: _bands,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _MiniBtn(
                label: 'پاک کردن',
                icon: Icons.refresh_rounded,
                color: AppColors.textSoft,
                onTap: _clear,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _MiniBtn(
                label: widget.alreadyDone || _celebrate
                    ? 'عالی بود! ✓'
                    : 'روی حرف خط بکش ✍️',
                icon: widget.alreadyDone || _celebrate
                    ? Icons.check_circle_rounded
                    : Icons.edit_rounded,
                color: widget.alreadyDone || _celebrate
                    ? AppColors.success
                    : widget.accent,
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MiniBtn({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.14),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TracingPainter extends CustomPainter {
  final String char;
  final Color accent;
  final List<List<Offset>> strokes;
  final List<Offset> active;
  final int bands;

  _TracingPainter({
    required this.char,
    required this.accent,
    required this.strokes,
    required this.active,
    this.bands = 3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final bandH = size.height / bands;

    // ---------- خطوط نقطه‌چین هر باند ----------
    final dashPaint = Paint()
      ..color = AppColors.textSoft.withOpacity(0.45)
      ..strokeWidth = 1.6;
    for (var b = 0; b < bands; b++) {
      final top = b * bandH;
      final bottom = (b + 1) * bandH;
      _dashedLine(canvas, Offset(12, top + 4), Offset(size.width - 12, top + 4),
          dashPaint);
      _dashedLine(
          canvas, Offset(12, bottom - 4), Offset(size.width - 12, bottom - 4),
          dashPaint);
    }

    // ---------- فلش‌های جهت نوشتن (چپ‌گرد) ----------
    final arrowPaint = Paint()
      ..color = AppColors.textSoft.withOpacity(0.55)
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    for (var b = 0; b < bands; b++) {
      final cy = b * bandH + bandH / 2;
      final start = Offset(24, cy);
      final end = Offset(52, cy);
      canvas.drawLine(start, end, arrowPaint);
      canvas.drawLine(end, Offset(end.dx - 8, cy - 6), arrowPaint);
      canvas.drawLine(end, Offset(end.dx - 8, cy + 6), arrowPaint);
    }

    // ---------- حرف شبح در هر خط ----------
    for (var b = 0; b < bands; b++) {
      final tp = TextPainter(
        text: TextSpan(
          text: char,
          style: TextStyle(
            fontSize: bandH * 0.72,
            fontWeight: FontWeight.w900,
            color: accent.withOpacity(0.38),
          ),
        ),
        textDirection: TextDirection.rtl,
      )..layout();
      final x = size.width - 18 - tp.width;
      final y = b * bandH + (bandH - tp.height) / 2;
      tp.paint(canvas, Offset(x, y));
    }

    // ---------- خطوط کودک ----------
    final penPaint = Paint()
      ..color = accent
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final all = [...strokes, if (active.length > 1) active];
    for (final stroke in all) {
      final path = Path()..moveTo(stroke.first.dx, stroke.first.dy);
      for (final p in stroke.skip(1)) {
        path.lineTo(p.dx, p.dy);
      }
      canvas.drawPath(path, penPaint);
    }
  }

  void _dashedLine(Canvas canvas, Offset a, Offset b, Paint paint) {
    const dashLen = 9.0;
    const gap = 7.0;
    final total = (b - a).distance;
    if (total == 0) return;
    final dir = (b - a) / total;
    var t = 0.0;
    while (t < total) {
      final end = (t + dashLen).clamp(0.0, total).toDouble();
      canvas.drawLine(a + dir * t, a + dir * end, paint);
      t = end + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _TracingPainter old) => true;
}
