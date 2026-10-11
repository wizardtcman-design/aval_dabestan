import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';

/// سرویس صدا — کاملاً آفلاین
///
/// استراتژی پخش:
/// ۱) اگر فایل صوتی ضبط‌شده در assets موجود باشد → پخش با just_audio
/// ۲) در غیر این صورت → گویندهٔ متنی سیستم (flutter_tts) با زبان فارسی
/// ۳) اگر هیچ‌کدام نبود → بی‌صدا (بدون کرش)
class AppAudio {
  AppAudio._();
  static final AppAudio instance = AppAudio._();

  final AudioPlayer _player = AudioPlayer();
  FlutterTts? _tts;
  Set<String> _bundledAssets = {};
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
      _bundledAssets = manifest.listAssets().toSet();
    } catch (_) {
      _bundledAssets = {};
    }
    _initialized = true;
  }

  bool hasAsset(String path) => _bundledAssets.contains(path);

  /// پخش فایل صوتی از assets
  Future<void> playAsset(String assetPath) async {
    await _player.stop();
    await _player.setAsset(assetPath);
    await _player.play();
  }

  /// گفتن متن با گویندهٔ سیستم
  /// [rate] سرعت تلفظ بین ۰٫۲ (آرام) تا ۱ (معمولی)
  Future<void> speak(
    String text, {
    required bool soundOn,
    required double rate,
  }) async {
    if (!soundOn) return;
    try {
      final tts = _tts ??= FlutterTts();
      await tts.setLanguage('fa-IR');
      // اندروید: 0.0 تا 1.0
      await tts.setSpeechRate(rate.clamp(0.1, 1.0).toDouble());
      await tts.setPitch(1.1);
      await tts.setVolume(1.0);
      await tts.awaitSpeakCompletion(true);
      await tts.speak(text);
    } catch (_) {
      // اگر گویندهٔ فارسی روی دستگاه نصب نباشد، بی‌صدا رد می‌شویم
    }
  }

  /// پخش صوت حرف/عدد: اول فایل ضبط‌شده، بعد گویندهٔ سیستم
  Future<void> say({
    required String assetPath,
    required String fallbackText,
    required bool soundOn,
    required double rate,
  }) async {
    if (!soundOn) return;
    await init();
    if (hasAsset(assetPath)) {
      try {
        await playAsset(assetPath);
        return;
      } catch (_) {
        // ادامه با گویندهٔ سیستم
      }
    }
    await speak(fallbackText, soundOn: soundOn, rate: rate);
  }

  Future<void> stopAll() async {
    try {
      await _player.stop();
    } catch (_) {}
    try {
      await _tts?.stop();
    } catch (_) {}
  }

  /// پخش جلوهٔ صوتی کوچک درون‌ساختی با TTS (برای تشویق)
  Future<void> cheer({
    required bool soundOn,
    required double rate,
  }) async {
    const cheers = ['آفرین!', 'عالی بود!', 'خیلی خوب بود!', 'بارک‌الله!'];
    final text = cheers[DateTime.now().millisecond % cheers.length];
    await speak(text, soundOn: soundOn, rate: rate);
  }
}
