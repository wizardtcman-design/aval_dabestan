import '../../core/utils/persian_numbers.dart';
import '../models/letter_model.dart';

/// تولید داده ۱۰۱ عدد (۰ تا ۱۰۰) با نام فارسی مطابق خوانش کتاب درسی
final List<NumberModel> numbersData = List.generate(101, (i) {
  return NumberModel(
    value: i,
    faDigits: PersianNumbers.toFa(i),
    name: PersianNumbers.numberToWords(i),
    emoji: i == 0 ? '⚪' : '🍎',
  );
});

/// اعداد در گروه‌های ده‌تایی: 0-9، 10-19، ... 90-99، و 100 به‌تنهایی
const int groupSize = 10;
const int numberGroups = 11; // 10 گروه ده‌تایی + گروه [100]

List<NumberModel> numbersOfGroup(int g) {
  final start = g * groupSize;
  final end = (start + groupSize) > 101 ? 101 : start + groupSize;
  return numbersData.sublist(start, end);
}
