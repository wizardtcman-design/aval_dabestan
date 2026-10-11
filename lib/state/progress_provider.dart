import 'package:flutter/foundation.dart';

import '../core/services/storage_service.dart';
import '../data/models/letter_model.dart';
import '../data/data/letters_data.dart';
import '../data/data/numbers_data.dart';

/// نام بازی‌ها به ترتیب ستاره‌ها
const List<String> gameNames = [
  'پیدا کن',
  'جورچین',
  'حافظه',
  'بکش و رها کن',
];

/// مدیریت پیشرفت دانش‌آموز — با قفل مرحله‌ای
///
/// قفل حروف: تا حرف قبلی کامل نشود (تمرین نوشتن + هر ۴ بازی)، حرف بعدی باز نمی‌شود.
/// قفل اعداد: تا گروه ده‌تایی قبلی حداقل ۶۰٪ کامل نشود، گروه بعدی باز نمی‌شود.
class ProgressProvider extends ChangeNotifier {
  final StorageService _storage = StorageService.instance;

  Map<int, LetterProgress> _letters = {};
  Map<int, NumberProgress> _numbers = {};

  /// حالت آزاد: باز کردن همه مراحل (برای والدین/تست)
  bool freeMode = false;

  Map<int, LetterProgress> get letters => _letters;
  Map<int, NumberProgress> get numbers => _numbers;

  // ------------------------------------------------------------------
  //  بارگذاری اولیه
  // ------------------------------------------------------------------
  void load() {
    _letters = _storage.lettersProgress
        .map((k, v) => MapEntry(k, LetterProgress.fromMap(v)));
    _numbers = _storage.numbersProgress
        .map((k, v) => MapEntry(k, NumberProgress.fromMap(v)));
    freeMode = _storage.getSetting('freeMode', false);
    notifyListeners();
  }

  LetterProgress letterProgressOf(int index) =>
      _letters[index] ?? LetterProgress();

  NumberProgress numberProgressOf(int value) =>
      _numbers[value] ?? NumberProgress();

  // ------------------------------------------------------------------
  //  قفل مرحله‌ای حروف
  // ------------------------------------------------------------------
  bool isLetterUnlocked(int index) {
    if (freeMode) return true;
    if (index <= 0) return true;
    return letterProgressOf(index - 1).completed;
  }

  /// اولین درسی که هنوز کامل نشده (برای «ادامه بده»)
  int get currentLessonIndex {
    for (var i = 0; i < lettersData.length; i++) {
      if (!letterProgressOf(i).completed) return i;
    }
    return lettersData.length - 1;
  }

  // ------------------------------------------------------------------
  //  ثبت فعالیت حروف
  // ------------------------------------------------------------------
  void completeWriting(int index) {
    final p = letterProgressOf(index);
    p.writingDone = true;
    _persistLetters();
  }

  /// ثبت ستارهٔ یک بازی حرف (بیشترین ستاره حفظ می‌شود)
  /// [gameIndex] ۰ تا ۳ — [stars] ۱ تا ۳
  void awardGameStar(int letterIndex, int gameIndex, int stars) {
    final p = letterProgressOf(letterIndex);
    if (stars > p.gameStars[gameIndex]) {
      p.gameStars[gameIndex] = stars.clamp(1, 3).toInt();
    }
    _persistLetters();
  }

  void _persistLetters() {
    final map = _letters.map((k, v) => MapEntry(k, v.toMap()));
    _storage.saveLettersProgress(map);
    notifyListeners();
  }

  // ------------------------------------------------------------------
  //  قفل مرحله‌ای اعداد (گروه‌های ده‌تایی)
  // ------------------------------------------------------------------
  bool isNumberUnlocked(int value) {
    if (freeMode) return true;
    final group = value ~/ 10; // 100 → گروه 10
    if (group <= 0) return true;
    return isNumberGroupUnlocked(group);
  }

  bool isNumberGroupUnlocked(int group) {
    if (freeMode) return true;
    if (group <= 0) return true;
    final prev = numbersOfGroup(group - 1);
    final doneCount = prev
        .where((n) => numberProgressOf(n.value).completed)
        .length;
    return doneCount >= (prev.length * 0.6).ceil();
  }

  int get currentNumberGroup {
    for (var g = 0; g < numberGroups; g++) {
      final list = numbersOfGroup(g);
      final allDone = list.every((n) => numberProgressOf(n.value).completed);
      if (!allDone) return g;
    }
    return numberGroups - 1;
  }

  // ------------------------------------------------------------------
  //  ثبت فعالیت اعداد
  // ------------------------------------------------------------------
  void markNumberLearned(int value) {
    final p = numberProgressOf(value);
    if (!p.learned) {
      p.learned = true;
      _persistNumbers();
    }
  }

  void markNumberMatched(int value) {
    final p = numberProgressOf(value);
    if (!p.matched) {
      p.matched = true;
      _persistNumbers();
    }
  }

  void _persistNumbers() {
    final map = _numbers.map((k, v) => MapEntry(k, v.toMap()));
    _storage.saveNumbersProgress(map);
    notifyListeners();
  }

  // ------------------------------------------------------------------
  //  آمار کلی برای داشبورد والدین
  // ------------------------------------------------------------------
  int get totalLetterStars => lettersData
      .map((l) => letterProgressOf(l.index).stars)
      .fold(0, (a, b) => a + b);

  int get maxLetterStars => lettersData.length * LetterProgress.maxStars;

  int get completedLettersCount =>
      lettersData.where((l) => letterProgressOf(l.index).completed).length;

  int get totalNumberStars {
    var sum = 0;
    for (var i = 0; i <= 100; i++) {
      sum += numberProgressOf(i).stars;
    }
    return sum;
  }

  int get maxNumberStars => 101 * NumberProgress.maxStars;

  int get completedNumbersCount =>
      List.generate(101, (i) => i)
          .where((i) => numberProgressOf(i).completed)
          .length;

  double get overallPercent {
    final total = maxLetterStars + maxNumberStars;
    if (total == 0) return 0;
    return (totalLetterStars + totalNumberStars) / total;
  }

  // ------------------------------------------------------------------
  //  حالت آزاد و پاک‌سازی
  // ------------------------------------------------------------------
  void setFreeMode(bool value) {
    freeMode = value;
    _storage.setSetting('freeMode', value);
    notifyListeners();
  }

  Future<void> resetAll() async {
    await _storage.clearProgress();
    _letters = {};
    _numbers = {};
    notifyListeners();
  }
}
