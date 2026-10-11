import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../state/settings_provider.dart';
import '../main_shell.dart';

/// صفحه خانه — مطابق طرح سازمانی:
/// روباه ملوس + دکمه‌های حروف الفبا و اعداد + بنر تشویقی
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _openMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.purpleSoft,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(height: 16),
              _MenuTile(
                icon: Icons.tune_rounded,
                label: 'تنظیمات',
                color: AppColors.purple,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const SizedBox(height: 10),
              _MenuTile(
                icon: Icons.emoji_events_rounded,
                label: 'داشبورد والدین',
                color: AppColors.coral,
                onTap: () {
                  Navigator.pop(context);
                  MainShell.of(context)?.goToTab(3);
                },
              ),
              const SizedBox(height: 10),
              const _OfflineTile(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- ردیف بالا ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _PillIconButton(
                    icon: Icons.menu_rounded,
                    onTap: () => _openMenu(context),
                  ),
                  Row(
                    children: [
                      Text(
                        settings.soundOn ? '🔊' : '🔇',
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 10),
                      _PillIconButton(
                        icon: Icons.child_care_rounded,
                        onTap: () => MainShell.of(context)?.goToTab(3),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // ---------- ابر و قلب ----------
              const Center(
                child: IconWithPadding(),
              ),

              // ---------- عنوان ----------
              const SizedBox(height: 4),
              const AppTitle(),

              // ---------- شخصیت روباه ----------
              const SizedBox(height: 8),
              const MascotSection(),

              // ---------- دکمه حروف الفبا ----------
              const SizedBox(height: 12),
              MainEntryButton(
                label: 'حروف الفبا',
                color: AppColors.purple,
                badgeChild: const Text(
                  'ا ب پ',
                  style: TextStyle(
                    color: AppColors.purple,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // ---------- دکمه اعداد ----------
              MainEntryButton(
                label: 'اعداد ۰ تا ۱۰۰',
                color: AppColors.coral,
                isNumberEntry: true,
                badgeChild: const Text(
                  '۱۲۳',
                  style: TextStyle(
                    color: AppColors.coral,
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ---------- بنر تشویقی ----------
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite_rounded,
                        color: AppColors.purple, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'هر روز یادگیری، هر روز لبخند',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.text,
                        ),
                      ),
                    ),
                    Icon(Icons.star_rounded,
                        color: AppColors.mint, size: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// دکمه اصلی ورود به بخش‌ها (حروف/اعداد)
class MainEntryButton extends StatelessWidget {
  final String label;
  final Color color;
  final Widget? badgeChild;
  final bool isNumberEntry;

  const MainEntryButton({
    super.key,
    required this.label,
    required this.color,
    this.badgeChild,
    this.isNumberEntry = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () {
          if (isNumberEntry) {
            Navigator.pushNamed(context, '/numbers');
          } else {
            MainShell.of(context)?.goToTab(1);
          }
        },
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              // نشان سفید کوچک
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: badgeChild,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(Icons.arrow_back_rounded,
                  color: Colors.white, size: 28),
            ],
          ),
        ),
      ),
    );
  }
}

/// آیکون ابر قلبی
class IconWithPadding extends StatelessWidget {
  const IconWithPadding({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.mintSoft,
        borderRadius: BorderRadius.circular(30),
      ),
      child: const Text('💜', style: TextStyle(fontSize: 22)),
    );
  }
}

/// عنوان بزرگ دو رنگ با خط دور سفید
class AppTitle extends StatelessWidget {
  const AppTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            children: [
              _outlined('آموزش'),
              _outlined('کلاس اول'),
            ],
          ),
          Column(
            children: const [
              Text(
                'آموزش',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: AppColors.purple,
                ),
              ),
              Text(
                'کلاس اول',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.w900,
                  color: AppColors.coral,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Widget _outlined(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 44,
        fontWeight: FontWeight.w900,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8
          ..color = Colors.white,
      ),
    );
  }
}

/// بخش شخصیت روباه با تزئینات
class MascotSection extends StatelessWidget {
  const MascotSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            left: 10,
            bottom: 30,
            child: Text('🍎', style: TextStyle(fontSize: 46)),
          ),
          const Positioned(
            right: 14,
            bottom: 24,
            child: Text('🍊', style: TextStyle(fontSize: 44)),
          ),
          const Positioned(
            right: 90,
            bottom: 46,
            child: Text('🪺', style: TextStyle(fontSize: 40)),
          ),
          Image.asset(
            'assets/images/mascot/fox_home.png',
            height: 220,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Text('🦊', style: TextStyle(fontSize: 120)),
          ),
        ],
      ),
    );
  }
}

/// دکمه قرصی بنفش بالا
class _PillIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _PillIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.purple,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 44,
          child: Icon(icon, color: Colors.white, size: 26),
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withOpacity(0.12),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Icon(icon, color: color),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: color,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_left_rounded, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

class _OfflineTile extends StatelessWidget {
  const _OfflineTile();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.mintSoft,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          Icon(Icons.wifi_off_rounded, color: AppColors.mint, size: 20),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'این اپ کاملاً آفلاین است؛ بدون اینترنت هم کار می‌کند.',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: AppColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
