// تولید فایل‌های محتوای آموزشی:
//   assets/data/letters.json  — ۳۲ حرف فارسی (ترتیب فعلی: الفبایی، قابل تغییر با جابه‌جایی آرایه)
//   assets/data/numbers.json  — اعداد ۰ تا ۱۰۰ با نماد فارسی و نام فارسی
// اجرا:  node scripts/gen_data.js
const fs = require('fs');
const path = require('path');

// ---------- حروف ----------
const letters = [
  { char: 'ا', name: 'الف', word: 'آب' },
  { char: 'ب', name: 'بِ', word: 'باران' },
  { char: 'پ', name: 'پِ', word: 'پرنده' },
  { char: 'ت', name: 'تِ', word: 'توپ' },
  { char: 'ث', name: 'ثِ', word: 'ثعلب' },
  { char: 'ج', name: 'جیم', word: 'جوجه' },
  { char: 'چ', name: 'چِ', word: 'چتر' },
  { char: 'ح', name: 'حِ', word: 'حباب' },
  { char: 'خ', name: 'خِ', word: 'خرگوش' },
  { char: 'د', name: 'دال', word: 'درخت' },
  { char: 'ذ', name: 'ذال', word: 'ذرت' },
  { char: 'ر', name: 'رِ', word: 'رنگین‌کمان' },
  { char: 'ز', name: 'زِ', word: 'زرافه' },
  { char: 'ژ', name: 'ژِ', word: 'ژاله' },
  { char: 'س', name: 'سین', word: 'سیب' },
  { char: 'ش', name: 'شین', word: 'شیر' },
  { char: 'ص', name: 'صاد', word: 'صابون' },
  { char: 'ض', name: 'ضاد', word: 'ضربه' },
  { char: 'ط', name: 'طا', word: 'طوطی' },
  { char: 'ظ', name: 'ظا', word: 'ظرف' },
  { char: 'ع', name: 'عین', word: 'عینک' },
  { char: 'غ', name: 'غین', word: 'غذا' },
  { char: 'ف', name: 'فِ', word: 'فیل' },
  { char: 'ق', name: 'قاف', word: 'قاشق' },
  { char: 'ک', name: 'کاف', word: 'کتاب' },
  { char: 'گ', name: 'گاف', word: 'گل' },
  { char: 'ل', name: 'لام', word: 'لیوان' },
  { char: 'م', name: 'میم', word: 'ماهی' },
  { char: 'ن', name: 'نون', word: 'نان' },
  { char: 'و', name: 'واو', word: 'وطن' },
  { char: 'ه', name: 'هِ', word: 'هوا' },
  { char: 'ی', name: 'یِ', word: 'یخ' },
];

const lettersData = letters.map((l, i) => ({
  order: i + 1,
  id: l.char,
  char: l.char,
  name: l.name,
  word: l.word,
}));

// ---------- اعداد ۰ تا ۱۰۰ ----------
const ones = ['صفر', 'یک', 'دو', 'سه', 'چهار', 'پنج', 'شش', 'هفت', 'هشت', 'نه', 'ده'];
const teens = {
  11: 'یازده', 12: 'دوازده', 13: 'سیزده', 14: 'چهارده',
  15: 'پانزده', 16: 'شانزده', 17: 'هفده', 18: 'هجده', 19: 'نوزده',
};
const tens = { 2: 'بیست', 3: 'سی', 4: 'چهل', 5: 'پنجاه', 6: 'شصت', 7: 'هفتاد', 8: 'هشتاد', 9: 'نود' };

function numberWord(n) {
  if (n <= 10) return ones[n];
  if (n < 20) return teens[n];
  if (n === 100) return 'صد';
  const t = Math.floor(n / 10);
  const o = n % 10;
  return o === 0 ? tens[t] : `${tens[t]} و ${ones[o]}`;
}

const faDigits = '۰۱۲۳۴۵۶۷۸۹';
const faSymbol = (n) => String(n).split('').map((d) => faDigits[+d]).join('');

const numbersData = [];
for (let n = 0; n <= 100; n++) {
  numbersData.push({ value: n, symbol: faSymbol(n), word: numberWord(n) });
}

// ---------- نوشتن فایل‌ها ----------
const dataDir = path.join(__dirname, '..', 'assets', 'data');
fs.mkdirSync(dataDir, { recursive: true });

fs.writeFileSync(
  path.join(dataDir, 'letters.json'),
  JSON.stringify(lettersData, null, 2) + '\n',
  'utf8',
);
fs.writeFileSync(
  path.join(dataDir, 'numbers.json'),
  JSON.stringify(numbersData, null, 2) + '\n',
  'utf8',
);

console.log(`letters.json: ${lettersData.length} حرف`);
console.log(`numbers.json: ${numbersData.length} عدد`);
console.log('نمونه اعداد:', numbersData[0].word, '|', numbersData[21].word, '|', numbersData[55].word, '|', numbersData[100].word);
