import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'games_screen.dart';
import 'letters_screen.dart';
import 'numbers_screen.dart';
import 'parent_dashboard_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _open(BuildContext context, Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text(
                'سلام دوست من!',
                style: textTheme.headlineLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'آماده‌ای حرف‌ها و عدد‌ها یاد بگیری؟',
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              _MenuCard(
                title: 'حرف‌های فارسی',
                subtitle: 'حرف به حرف یاد بگیر، با قفل مرحله‌ای',
                color: AppColors.primary,
                icon: Icons.abc,
                onTap: () => _open(context, const LettersScreen()),
              ),
              _MenuCard(
                title: 'عددها (۰ تا ۱۰۰)',
                subtitle: 'عددها را بشناس و بشمار',
                color: AppColors.coral,
                icon: Icons.calculate,
                onTap: () => _open(context, const NumbersScreen()),
              ),
              _MenuCard(
                title: 'زمین بازی',
                subtitle: 'بازی‌های آموزشی و سرگرم‌کننده',
                color: AppColors.mint,
                icon: Icons.videogame_asset,
                onTap: () => _open(context, const GamesScreen()),
              ),
              _MenuCard(
                title: 'داشبورد والدین',
                subtitle: 'پیشرفت فرزندتان را ببینید',
                color: AppColors.ink,
                icon: Icons.query_stats,
                onTap: () => _open(context, const ParentDashboardScreen()),
              ),
              _MenuCard(
                title: 'تنظیمات',
                subtitle: 'بلندی صدا و سرعت گفتار',
                color: AppColors.primary,
                icon: Icons.settings,
                onTap: () => _open(context, const SettingsScreen()),
              ),
              const SizedBox(height: 12),
              Text(
                'همه‌چیز داخل خود اپلیکیشن است و بدون اینترنت کار می‌کند.',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.ink.withOpacity(0.55),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _MenuCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: color.withOpacity(0.25)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(icon, color: color, size: 30),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: textTheme.titleLarge),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.ink.withOpacity(0.65),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_left, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
