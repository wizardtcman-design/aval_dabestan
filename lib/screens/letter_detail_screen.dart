import 'package:flutter/material.dart';

import '../models/letter.dart';
import '../services/progress_service.dart';
import '../theme/app_colors.dart';

/// صفحه آموزش یک حرف — در فازهای بعد صدا، نوشتن و بازی‌ها به آن اضافه می‌شود
class LetterDetailScreen extends StatefulWidget {
  final Letter letter;

  const LetterDetailScreen({super.key, required this.letter});

  @override
  State<LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<LetterDetailScreen> {
  bool _saving = false;

  Future<void> _markLearned() async {
    setState(() => _saving = true);
    await ProgressService().completeLetter(widget.letter.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('آفرین! حرف «${widget.letter.char}» را یاد گرفتی.'),
        backgroundColor: AppColors.mint,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final Letter letter = widget.letter;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('حرف ${letter.name}')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 12),
            Center(
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Center(
                  child: Text(
                    letter.char,
                    style: const TextStyle(
                      fontSize: 88,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Text(
                'این حرف «${letter.name}» نام دارد',
                style: textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'کلمه نمونه: ${letter.exampleWord}',
                style: textTheme.bodyLarge,
              ),
            ),
            const SizedBox(height: 28),
            Card(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: AppColors.coral, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'در فازهای بعدی، صدای حرف، تمرین نوشتن و چهار بازی سرگرم‌کننده اینجا اضافه می‌شود.',
                        style: textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _saving ? null : _markLearned,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.mint,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Vazirmatn',
                ),
              ),
              icon: const Icon(Icons.check_circle),
              label: const Text('یاد گرفتم!'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
