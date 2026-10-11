import 'package:flutter/material.dart';

import '../services/settings_service.dart';
import '../theme/app_colors.dart';

/// تنظیمات — بلندی صدا و سرعت گفتار (برای صدا در فازهای بعد)
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _service = SettingsService();

  double _volume = 1.0;
  double _rate = 1.0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final double volume = await _service.loadVolume();
    final double rate = await _service.loadRate();
    if (!mounted) return;
    setState(() {
      _volume = volume;
      _rate = rate;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('تنظیمات')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.volume_up,
                              color: AppColors.primary),
                          const SizedBox(width: 10),
                          Text('بلندی صدا', style: textTheme.titleLarge),
                          const Spacer(),
                          Text('${(_volume * 100).round()}٪'),
                        ],
                      ),
                      Slider(
                        value: _volume,
                        min: 0,
                        max: 1,
                        divisions: 10,
                        activeColor: AppColors.primary,
                        label: '${(_volume * 100).round()}٪',
                        onChanged: (value) =>
                            setState(() => _volume = value),
                        onChangeEnd: (value) => _service.saveVolume(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: AppColors.coral.withValues(alpha: 0.25)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed, color: AppColors.coral),
                          const SizedBox(width: 10),
                          Text('سرعت گفتار', style: textTheme.titleLarge),
                          const Spacer(),
                          Text('${_rate.toStringAsFixed(1)} برابر'),
                        ],
                      ),
                      Slider(
                        value: _rate,
                        min: 0.5,
                        max: 1.5,
                        divisions: 10,
                        activeColor: AppColors.coral,
                        label: '${_rate.toStringAsFixed(1)} برابر',
                        onChanged: (value) => setState(() => _rate = value),
                        onChangeEnd: (value) => _service.saveRate(value),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border:
                        Border.all(color: AppColors.mint.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off, color: AppColors.mint),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'حالت آفلاین',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'همه صداها و تصویرها داخل خود اپلیکیشن هستند؛ همیشه و همه‌جا بدون اینترنت کار می‌کند.',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.ink.withValues(alpha: 0.65),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.check_circle, color: AppColors.mint),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
