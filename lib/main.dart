import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/audio_service.dart';
import 'core/services/storage_service.dart';
import 'state/progress_provider.dart';
import 'state/settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // آماده‌سازی ذخیره‌سازی محلی (آفلاین)
  await StorageService.instance.init();

  // آماده‌سازی سرویس صدا
  await AppAudio.instance.init();

  final settings = SettingsProvider()..load();
  final progress = ProgressProvider()..load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settings),
        ChangeNotifierProvider.value(value: progress),
      ],
      child: const KelasAvalApp(),
    ),
  );
}
