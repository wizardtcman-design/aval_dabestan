import 'package:shared_preferences/shared_preferences.dart';

/// تنظیمات اپلیکیشن (بلندی صدا، سرعت گفتار) — محلی و آفلاین
class SettingsService {
  static const String _volumeKey = 'settings_volume';
  static const String _rateKey = 'settings_rate';

  Future<double> loadVolume() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_volumeKey) ?? 1.0;
  }

  Future<double> loadRate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_rateKey) ?? 1.0;
  }

  Future<void> saveVolume(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, value);
  }

  Future<void> saveRate(double value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_rateKey, value);
  }
}
