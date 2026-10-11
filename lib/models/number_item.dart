/// مدل عدد — از ۰ تا ۱۰۰
class NumberItem {
  final int value;
  final String symbol;
  final String word;

  const NumberItem({
    required this.value,
    required this.symbol,
    required this.word,
  });

  factory NumberItem.fromJson(Map<String, dynamic> json) {
    return NumberItem(
      value: json['value'] as int,
      symbol: json['symbol'] as String,
      word: json['word'] as String,
    );
  }
}
