/// مدل حرف فارسی — محتوا از فایل letters.json داخل اپ خوانده می‌شود
class Letter {
  final int order;
  final String id;
  final String char;
  final String name;
  final String exampleWord;

  const Letter({
    required this.order,
    required this.id,
    required this.char,
    required this.name,
    required this.exampleWord,
  });

  factory Letter.fromJson(Map<String, dynamic> json) {
    return Letter(
      order: json['order'] as int,
      id: json['id'] as String,
      char: json['char'] as String,
      name: json['name'] as String,
      exampleWord: json['word'] as String,
    );
  }
}
