import 'package:flutter/material.dart';

import '../data/content_repository.dart';
import '../models/letter.dart';
import '../models/progress.dart';
import '../services/progress_service.dart';
import '../theme/app_colors.dart';
import 'letter_detail_screen.dart';

/// فهرست حروف با سیستم قفل مرحله‌ای:
/// هر حرف فقط بعد از یادگیری حرف قبلی باز می‌شود.
class LettersScreen extends StatefulWidget {
  const LettersScreen({super.key});

  @override
  State<LettersScreen> createState() => _LettersScreenState();
}

class _LettersScreenState extends State<LettersScreen> {
  List<Letter> _letters = const <Letter>[];
  Progress _progress = const Progress();
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final List<Letter> letters = await ContentRepository.loadLetters();
      final Progress progress = await ProgressService().load();
      if (!mounted) return;
      setState(() {
        _letters = letters;
        _progress = progress;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  bool _isUnlocked(int index) {
    if (index == 0) return true;
    return _progress.completedLetters.contains(_letters[index - 1].id);
  }

  Future<void> _openLetter(int index) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => LetterDetailScreen(letter: _letters[index]),
      ),
    );
    if (mounted) await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('حرف‌های فارسی')),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('خطا در بارگذاری حرف‌ها'),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('تلاش دوباره')),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.95,
      ),
      itemCount: _letters.length,
      itemBuilder: (context, index) {
        final Letter letter = _letters[index];
        return _LetterTile(
          letter: letter,
          unlocked: _isUnlocked(index),
          completed: _progress.completedLetters.contains(letter.id),
          onTap: _isUnlocked(index) ? () => _openLetter(index) : null,
        );
      },
    );
  }
}

class _LetterTile extends StatelessWidget {
  final Letter letter;
  final bool unlocked;
  final bool completed;
  final VoidCallback? onTap;

  const _LetterTile({
    required this.letter,
    required this.unlocked,
    required this.completed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = completed
        ? AppColors.mint
        : (unlocked ? AppColors.primary : Colors.grey.shade400);

    return Opacity(
      opacity: unlocked ? 1.0 : 0.55,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: color.withValues(alpha: 0.35)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  letter.char,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: color,
                    fontFamily: 'Vazirmatn',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  letter.name,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.ink.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 4),
                if (completed)
                  const Icon(Icons.check_circle,
                      color: AppColors.mint, size: 16)
                else if (!unlocked)
                  Icon(Icons.lock, color: Colors.grey.shade400, size: 14)
                else
                  const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
