import 'package:flutter/material.dart';

import '../data/content_repository.dart';
import '../models/number_item.dart';
import '../theme/app_colors.dart';

/// بخش اعداد ۰ تا ۱۰۰ — شناخت عدد و نام آن
class NumbersScreen extends StatefulWidget {
  const NumbersScreen({super.key});

  @override
  State<NumbersScreen> createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen> {
  List<NumberItem> _numbers = const <NumberItem>[];
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
      final List<NumberItem> numbers = await ContentRepository.loadNumbers();
      if (!mounted) return;
      setState(() {
        _numbers = numbers;
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

  Color _colorForIndex(int index) {
    switch (index % 3) {
      case 0:
        return AppColors.primary;
      case 1:
        return AppColors.coral;
      default:
        return AppColors.mint;
    }
  }

  void _showNumber(NumberItem number) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                number.symbol,
                style: TextStyle(
                  fontSize: 72,
                  fontWeight: FontWeight.w700,
                  color: _colorForIndex(number.value % 3),
                  fontFamily: 'Vazirmatn',
                ),
              ),
              const SizedBox(height: 8),
              Text(
                number.word,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('خیلی خب'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عددها (۰ تا ۱۰۰)')),
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
            const Text('خطا در بارگذاری عددها'),
            const SizedBox(height: 8),
            TextButton(onPressed: _load, child: const Text('تلاش دوباره')),
          ],
        ),
      );
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: _numbers.length,
      itemBuilder: (context, index) {
        final NumberItem number = _numbers[index];
        final Color color = _colorForIndex(index);
        return Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showNumber(number),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: color.withOpacity(0.35)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    number.symbol,
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                      color: color,
                      fontFamily: 'Vazirmatn',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    number.word,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.ink.withOpacity(0.65),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
