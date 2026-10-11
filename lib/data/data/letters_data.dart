import '../../core/constants/app_colors.dart';
import '../models/letter_model.dart';

/// حروف الفبا به ترتیب استاندارد کتاب فارسی کلاس اول دبستان
/// آ، ا، ب، پ، ت، ث، ج، چ، ح، خ، د، ذ، ر، ز، ژ، س، ش، ص، ض، ط، ظ، ع، غ، ف، ق، ک، گ، ل، م، ن، و، ه، ی
const List<LetterModel> lettersData = [
  LetterModel(
    index: 0, char: 'آ', name: 'حرف آ', word: 'آشیانه', emoji: '🪺',
    imageAsset: 'assets/images/letters/alef.png',
    soundAsset: 'assets/sounds/letter_00.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 1, char: 'ا', name: 'حرف ا', word: 'اسب', emoji: '🐴',
    imageAsset: 'assets/images/letters/alef_hamze.png',
    soundAsset: 'assets/sounds/letter_01.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 2, char: 'ب', name: 'حرف ب', word: 'بره', emoji: '🐑',
    soundAsset: 'assets/sounds/letter_02.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 3, char: 'پ', name: 'حرف پ', word: 'پرنده', emoji: '🐦',
    soundAsset: 'assets/sounds/letter_03.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 4, char: 'ت', name: 'حرف ت', word: 'توپ', emoji: '⚽',
    soundAsset: 'assets/sounds/letter_04.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 5, char: 'ث', name: 'حرف ث', word: 'ثانیه', emoji: '⏰',
    soundAsset: 'assets/sounds/letter_05.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 6, char: 'ج', name: 'حرف ج', word: 'جوجه', emoji: '🐥',
    soundAsset: 'assets/sounds/letter_06.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 7, char: 'چ', name: 'حرف چ', word: 'چتری', emoji: '☂️',
    soundAsset: 'assets/sounds/letter_07.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 8, char: 'ح', name: 'حرف ح', word: 'حلوا', emoji: '🥮',
    soundAsset: 'assets/sounds/letter_08.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 9, char: 'خ', name: 'حرف خ', word: 'خرگوش', emoji: '🐰',
    soundAsset: 'assets/sounds/letter_09.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 10, char: 'د', name: 'حرف د', word: 'دست', emoji: '✋',
    soundAsset: 'assets/sounds/letter_10.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 11, char: 'ذ', name: 'حرف ذ', word: 'ذرت', emoji: '🌽',
    soundAsset: 'assets/sounds/letter_11.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 12, char: 'ر', name: 'حرف ر', word: 'روباه', emoji: '🦊',
    imageAsset: 'assets/images/letters/re.png',
    soundAsset: 'assets/sounds/letter_12.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 13, char: 'ز', name: 'حرف ز', word: 'زرافه', emoji: '🦒',
    soundAsset: 'assets/sounds/letter_13.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 14, char: 'ژ', name: 'حرف ژ', word: 'ژله', emoji: '🍮',
    soundAsset: 'assets/sounds/letter_14.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 15, char: 'س', name: 'حرف س', word: 'سنجاب', emoji: '🐿️',
    soundAsset: 'assets/sounds/letter_15.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 16, char: 'ش', name: 'حرف ش', word: 'شیر', emoji: '🦁',
    soundAsset: 'assets/sounds/letter_16.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 17, char: 'ص', name: 'حرف ص', word: 'صدف', emoji: '🐚',
    soundAsset: 'assets/sounds/letter_17.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 18, char: 'ض', name: 'حرف ض', word: 'ضربدر', emoji: '❌',
    soundAsset: 'assets/sounds/letter_18.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 19, char: 'ط', name: 'حرف ط', word: 'طوطی', emoji: '🦜',
    soundAsset: 'assets/sounds/letter_19.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 20, char: 'ظ', name: 'حرف ظ', word: 'ظرف', emoji: '🍽️',
    soundAsset: 'assets/sounds/letter_20.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 21, char: 'ع', name: 'حرف ع', word: 'عسل', emoji: '🍯',
    soundAsset: 'assets/sounds/letter_21.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 22, char: 'غ', name: 'حرف غ', word: 'غاز', emoji: '🦢',
    soundAsset: 'assets/sounds/letter_22.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 23, char: 'ف', name: 'حرف ف', word: 'فیل', emoji: '🐘',
    soundAsset: 'assets/sounds/letter_23.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 24, char: 'ق', name: 'حرف ق', word: 'قناری', emoji: '🐤',
    soundAsset: 'assets/sounds/letter_24.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 25, char: 'ک', name: 'حرف ک', word: 'کتاب', emoji: '📖',
    soundAsset: 'assets/sounds/letter_25.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 26, char: 'گ', name: 'حرف گ', word: 'گوجه', emoji: '🍅',
    soundAsset: 'assets/sounds/letter_26.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 27, char: 'ل', name: 'حرف ل', word: 'لیمو', emoji: '🍋',
    soundAsset: 'assets/sounds/letter_27.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 28, char: 'م', name: 'حرف م', word: 'موز', emoji: '🍌',
    soundAsset: 'assets/sounds/letter_28.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 29, char: 'ن', name: 'حرف ن', word: 'نارنج', emoji: '🍊',
    soundAsset: 'assets/sounds/letter_29.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
  LetterModel(
    index: 30, char: 'و', name: 'حرف و', word: 'وسکه', emoji: '🪙',
    soundAsset: 'assets/sounds/letter_30.mp3',
    accent: AppColors.coral, accentSoft: AppColors.coralSoft,
  ),
  LetterModel(
    index: 31, char: 'ه', name: 'حرف ه', word: 'هدیه', emoji: '🎁',
    soundAsset: 'assets/sounds/letter_31.mp3',
    accent: AppColors.purple, accentSoft: AppColors.purpleSoft,
  ),
  LetterModel(
    index: 32, char: 'ی', name: 'حرف ی', word: 'یخ', emoji: '🧊',
    soundAsset: 'assets/sounds/letter_32.mp3',
    accent: AppColors.mint, accentSoft: AppColors.mintSoft,
  ),
];
