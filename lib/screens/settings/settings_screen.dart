import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/audio_service.dart';
import '../../state/settings_provider.dart';
import '../../widgets/app_header.dart';

/// تنظیمات: صدا، سرعت تلفظ، اطلاعات آفلاین
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: Column(
        children: [
          AppHeader(title: 'تنظیمات', subtitle: 'صدا و سرعت تلفظ را تنظیم کنید'),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // ---------- صدا ----------
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: SwitchListTile(
                    value: settings.soundOn,
                    onChanged: (v) =>
                        context.read<SettingsProvider>().setSoundOn(v),
                    secondary: Icon(
                      settings.soundOn
                          ? Icons.volume_up_rounded
                          : Icons.volume_off_rounded,
                      color: AppColors.purple,
                    ),
                    title: const Text(
                      'صدای اپلیکیشن',
                      style:
                          TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                    ),
                    subtitle: const Text('تلفظ حروف و اعداد'),
                    activeColor: AppColors.mint,
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- سرعت تلفظ ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.speed_rounded,
                              color: AppColors.coral),
                          const SizedBox(width: 8),
                          const Text(
                            'سرعت تلفظ',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 15,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            settings.speechRate < 0.4
                                ? 'خیلی آرام'
                                : (settings.speechRate < 0.7
                                    ? 'آرام'
                                    : 'معمولی'),
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.coral,
                            ),
                          ),
                        ],
                      ),
                      Slider(
                        value: settings.speechRate,
                        min: 0.2,
                        max: 1.0,
                        divisions: 8,
                        activeColor: AppColors.coral,
                        onChanged: (v) => context
                            .read<SettingsProvider>()
                            .setSpeechRate(v),
                      ),
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            AppAudio.instance.speak(
                              'سلام! این سرعت تلفظ است',
                              soundOn: settings.soundOn,
                              rate: settings.speechRate,
                            );
                          },
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text('تست صدا'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.coral,
                            side: const BorderSide(color: AppColors.coral),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- حالت آفلاین ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.mintSoft,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.wifi_off_rounded,
                          color: AppColors.mint),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'حالت آفلاین: همیشه فعال ✅',
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'این اپ بدون اینترنت کامل کار می‌کند. همه صداها، تصاویر و پیشرفت‌ها روی خود گوشی ذخیره می‌شوند.',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSoft,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // ---------- درباره ----------
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: AppColors.softShadow,
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'آموزش کلاس اول',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          color: AppColors.purpleDark,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'نسخه ۱٫۰٫۰ — آموزش حروف الفبا و اعداد ۰ تا ۱۰۰ مطابق کتاب درسی ایران',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSoft,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '🛍 آماده انتشار در کافه‌بازار',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.mint,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
