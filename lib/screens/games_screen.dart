import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// زمین بازی — چهار نوع بازی برای هر حرف و عدد (در فازهای بعد فعال می‌شود)
class GamesScreen extends StatelessWidget {
  const GamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final List<({String title, String subtitle, IconData icon, Color color})>
        games = const <({String title, String subtitle, IconData icon, Color color})>[
      (
        title: 'پیدا کن',
        subtitle: 'حرف یا عدد درست را پیدا کن',
        icon: Icons.search,
        color: AppColors.primary,
      ),
      (
        title: 'پازل حرف‌ها',
        subtitle: 'قطعه‌ها را سر جای خودشان بگذار',
        icon: Icons.extension,
        color: AppColors.coral,
      ),
      (
        title: 'حافظه',
        subtitle: 'جفت‌های یکسان را پیدا کن',
        icon: Icons.memory,
        color: AppColors.mint,
      ),
      (
        title: 'کشیدن و رها کردن',
        subtitle: 'حرف‌ها را به جای درست بکش',
        icon: Icons.swipe,
        color: AppColors.ink,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('زمین بازی')),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: game.color.withOpacity(0.25)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: game.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(game.icon, color: game.color, size: 28),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(game.title, style: textTheme.titleLarge),
                        const SizedBox(height: 4),
                        Text(
                          game.subtitle,
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.ink.withOpacity(0.65),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Chip(
                    backgroundColor: game.color.withOpacity(0.12),
                    label: Text(
                      'به‌زودی',
                      style: TextStyle(
                        color: game.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
