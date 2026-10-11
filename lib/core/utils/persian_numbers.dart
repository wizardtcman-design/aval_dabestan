/// ابزار تبدیل اعداد لاتین به فارسی و تبدیل عدد به نام فارسی
/// مطابق خوانش استاندارد کتاب ریاضی اول دبستان
class PersianNumbers {
  PersianNumbers._();

  static const String _digits = '۰۱۲۳۴۵۶۷۸۹';

  /// تبدیل همه ارقام لاتین یک رشته به ارقام فارسی
  static String toFa(Object input) {
    final s = input.toString();
    final buffer = StringBuffer();
    for (final code in s.codeUnits) {
      if (code >= 0x30 && code <= 0x39) {
        buffer.write(_digits[code - 0x30]);
      } else {
        buffer.writeCharCode(code);
      }
    }
    return buffer.toString();
  }

  /// تبدیل ارقام فارسی به لاتین (برای پارس ورودی)
  static String toEn(String s) {
    return s.replaceAllMapped(RegExp('[۰-۹]'), (m) {
      return (_digits.indexOf(m.group(0)!)).toString();
    });
  }

  static const List<String> _ones = [
    'صفر', 'یک', 'دو', 'سه', 'چهار', 'پنج', 'شش', 'هفت', 'هشت', 'نه',
    'ده', 'یازده', 'دوازده', 'سیزده', 'چهارده', 'پانزده', 'شانزده',
    'هفده', 'هجده', 'نوزده',
  ];

  static const List<String> _tens = [
    '', '', 'بیست', 'سی', 'چهل', 'پنجاه', 'شصت', 'هفتاد', 'هشتاد', 'نود',
  ];

  /// تبدیل عدد ۰ تا ۱۰۰ به نام فارسی آن
  /// مثال: 42 → «چهل و دو» ، 100 → «صد»
  static String numberToWords(int n) {
    if (n < 0 || n > 100) return toFa(n);
    if (n < 20) return _ones[n];
    if (n == 100) return 'صد';
    final t = n ~/ 10;
    final o = n % 10;
    if (o == 0) return _tens[t];
    return '${_tens[t]} و ${_ones[o]}';
  }

  /// فاصله‌گذاری سه‌رقمی فارسی (فعلاً برای اعداد تا ۱۰۰ نیازی نیست)
  static String grouped(int n) => toFa(n);
}
