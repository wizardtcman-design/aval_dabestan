/// مدل پیشرفت یادگیری کودک — روی خود گوشی ذخیره می‌شود (کاملاً آفلاین)
class Progress {
  final Set<String> completedLetters;
  final Map<String, int> letterStars;

  const Progress({
    this.completedLetters = const <String>{},
    this.letterStars = const <String, int>{},
  });

  bool isLetterCompleted(String letterId) =>
      completedLetters.contains(letterId);

  int get completedCount => completedLetters.length;

  int get totalStars =>
      letterStars.values.fold(0, (sum, stars) => sum + stars);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'completedLetters': completedLetters.toList(),
        'letterStars': letterStars,
      };

  factory Progress.fromJson(Map<String, dynamic> json) {
    final List<dynamic> letters =
        (json['completedLetters'] as List<dynamic>?) ?? const <dynamic>[];
    final Map<dynamic, dynamic> stars =
        (json['letterStars'] as Map<dynamic, dynamic>?) ?? const <dynamic, dynamic>{};
    return Progress(
      completedLetters: letters.cast<String>().toSet(),
      letterStars: stars.cast<String, int>(),
    );
  }

  Progress copyWith({
    Set<String>? completedLetters,
    Map<String, int>? letterStars,
  }) {
    return Progress(
      completedLetters: completedLetters ?? this.completedLetters,
      letterStars: letterStars ?? this.letterStars,
    );
  }
}
