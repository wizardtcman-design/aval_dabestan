import 'package:flutter/material.dart';

import '../core/constants/app_colors.dart';
import 'games/games_hub_screen.dart';
import 'home/home_screen.dart';
import 'letters/letters_list_screen.dart';
import 'progress/parent_dashboard_screen.dart';

/// شل اصلی با نویگیشن پایین: خانه، درس‌ها، بازی‌ها، پیشرفت
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  /// تب فعال برای دسترسی از صفحات دیگر
  static _MainShellState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainShellState>();

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;

  void goToTab(int index) =>
      setState(() => _tab = index.clamp(0, 3).toInt());

  @override
  Widget build(BuildContext context) {
    final pages = [
      const HomeScreen(),
      const LettersListScreen(),
      const GamesHubScreen(),
      const ParentDashboardScreen(),
    ];

    return Scaffold(
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: _BottomNav(
        current: _tab,
        onTap: goToTab,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.current, required this.onTap});

  static const List<({IconData icon, String label})> _items = [
    (icon: Icons.home_rounded, label: 'خانه'),
    (icon: Icons.menu_book_rounded, label: 'درس‌ها'),
    (icon: Icons.videogame_asset_rounded, label: 'بازی‌ها'),
    (icon: Icons.emoji_events_rounded, label: 'پیشرفت'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, 8, 8, bottomInset > 0 ? 4 : 8),
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = current == i;
              return Expanded(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOutCubic,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: active ? AppColors.purple : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          item.icon,
                          size: 26,
                          color: active ? Colors.white : AppColors.textSoft,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: active ? Colors.white : AppColors.textSoft,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
