import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/persian_numbers.dart';
import '../../state/progress_provider.dart';

/// هاب بازی‌های مستقل — حالت حروف یا اعداد انتخاب می‌شود
class GamesHubScreen extends StatefulWidget {
  const GamesHubScreen({super.key});

  @override
  State<GamesHubScreen> createState() => _GamesHubScreenState();
}

class _GamesHubScreenState extends State<GamesHubScreen> {
  String _scope = 'letters';

  static const List<({String label, String emoji, Color color, String route})>
      _games = [
    (label: 'پیدا کن', emoji: '🔍', color: AppColors.mint, route: 'find'),
    (label: 'جورچین', emoji: '🧩', color: AppColors.coral, route: 'match'),
    (label: 'حافظه', emoji: '🃏', color: AppColors.purple, route: 'memory'),
    (
      label: 'بکش و رها کن',
      emoji: '🎯',
      color: Color(0xFFF2A65A),
      route: 'dragdrop'
    ),
  ];

  int get _unlockedCount {
    final progress = context.read<ProgressProvider>();
    if (_scope == 'numbers') {
      var count = 0;
      for (var v = 0; v <= 100; v++) {
        if (progress.isNumberUnlocked(v)) count++;
      }
      return count;
    }
    return progress.completedLettersCount + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ---------- هدر ----------
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  color: AppColors.purple,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    const Text(
                      'بازی‌ها 🎮',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${PersianNumbers.toFa(_unlockedCount)} تا از درس‌هایت برای بازی باز است!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ---------- انتخاب حالت ----------
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppColors.softShadow,
                ),
                child: Row(
                  children: [
                    _ScopeChip(
                      label: 'حروف الفبا',
                      emoji: '🔤',
                      selected: _scope == 'letters',
                      color: AppColors.purple,
                      onTap: () => setState(() => _scope = 'letters'),
                    ),
                    const SizedBox(width: 6),
                    _ScopeChip(
                      label: 'اعداد',
                      emoji: '🔢',
                      selected: _scope == 'numbers',
                      color: AppColors.coral,
                      onTap: () => setState(() => _scope = 'numbers'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ---------- کارت‌های بازی ----------
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.05,
                ),
                itemCount: _games.length,
                itemBuilder: (context, i) {
                  final g = _games[i];
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: () => Navigator.pushNamed(
                        context,
                        '/game/${g.route}?scope=$_scope',
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: g.color.withOpacity(0.4),
                            width: 2,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: g.color.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                g.emoji,
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              g.label,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w900,
                                color: AppColors.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              // ---------- راهنما ----------
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.mintSoft,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  '💡 با هر برد در بازی، ستاره می‌گیری و درس‌های بیشتری باز می‌شود!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                    color: AppColors.text,
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

class _ScopeChip extends StatelessWidget {
  final String label;
  final String emoji;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ScopeChip({
    required this.label,
    required this.emoji,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            color: selected ? color : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 18)),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                  color: selected ? Colors.white : AppColors.textSoft,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
