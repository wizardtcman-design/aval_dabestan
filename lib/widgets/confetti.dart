import 'dart:math';

import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';

/// نمایش ستاره‌ها: پرشده / خالی
class StarRow extends StatelessWidget {
  final int filled;
  final int total;
  final double size;
  final Color filledColor;

  const StarRow({
    super.key,
    required this.filled,
    required this.total,
    this.size = 16,
    this.filledColor = AppColors.star,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        return Icon(
          i < filled ? Icons.star_rounded : Icons.star_outline_rounded,
          color: i < filled ? filledColor : AppColors.textSoft.withOpacity(0.4),
          size: size,
        );
      }),
    );
  }
}

/// جشن کاغذرنگی (Confetti) برای موفقیت — بدون پکیج اضافه
class ConfettiBurst extends StatefulWidget {
  final bool play;
  final Widget child;

  const ConfettiBurst({super.key, required this.play, required this.child});

  @override
  State<ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<ConfettiBurst>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late List<_Particle> _particles;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _particles = _makeParticles();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {});
      }
    });
  }

  List<_Particle> _makeParticles() {
    final colors = [
      AppColors.purple,
      AppColors.coral,
      AppColors.mint,
      AppColors.star,
      AppColors.success,
    ];
    return List.generate(42, (i) {
      final angle = _random.nextDouble() * 2 * pi;
      final speed = 0.5 + _random.nextDouble() * 0.9;
      return _Particle(
        dx: cos(angle) * speed,
        dy: sin(angle) * speed * 1.2 - 0.4,
        color: colors[_random.nextInt(colors.length)],
        size: 6 + _random.nextDouble() * 8,
        isCircle: _random.nextBool(),
      );
    });
  }

  @override
  void didUpdateWidget(covariant ConfettiBurst oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.play && !oldWidget.play) {
      _particles = _makeParticles();
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (_controller.isAnimating || _controller.isCompleted)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _controller.value,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  final double dx;
  final double dy;
  final Color color;
  final double size;
  final bool isCircle;
  _Particle({
    required this.dx,
    required this.dy,
    required this.color,
    required this.size,
    required this.isCircle,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1) return;
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    for (final p in particles) {
      final t = progress;
      final pos = center +
          Offset(p.dx, p.dy + 1.1 * t * t) * size.shortestSide * 0.55 * t;
      paint.color = p.color.withOpacity((1 - t).clamp(0.0, 1.0).toDouble());
      if (p.isCircle) {
        canvas.drawCircle(pos, p.size * (1 - t * 0.5), paint);
      } else {
        canvas.drawCircle(pos, p.size * (1 - t * 0.5), paint..strokeWidth = 0);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) =>
      old.progress != progress || old.particles != particles;
}
