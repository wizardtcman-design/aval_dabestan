#!/usr/bin/env bash
# =============================================================
#  بیلد محلی APK (نیازمند نصب Flutter SDK روی سیستم شما)
#  استفاده:
#     ./scripts/build_apk.sh            → Release
#     ./scripts/build_apk.sh debug      → Debug
#     ./scripts/build_apk.sh release    → Release
# =============================================================
set -euo pipefail
cd "$(dirname "$0")/.."

GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
BUILD_TYPE="${1:-release}"

if ! command -v flutter >/dev/null 2>&1; then
  echo -e "${RED}❌ Flutter نصب نیست. از https://docs.flutter.dev نصب کنید.${NC}"
  exit 1
fi

echo "📦 دریافت پکیج‌ها..."
flutter pub get

echo "🧹 پاک‌سازی..."
flutter clean >/dev/null

if [ "${BUILD_TYPE}" = "debug" ]; then
  echo "🧪 بیلد Debug APK ..."
  flutter build apk --debug
  OUT="build/app/outputs/flutter-apk/app-debug.apk"
else
  echo "🚀 بیلد Release APK ..."
  flutter build apk --release
  OUT="build/app/outputs/flutter-apk/app-release.apk"
  echo "🚀 بیلد نسخه سبک برای هر معماری ..."
  flutter build apk --release --split-per-abi
fi

echo ""
echo -e "${GREEN}✅ بیلد کامل شد!${NC}"
echo "📱 فایل APK: ${OUT}"
echo ""
echo "نصب روی گوشی: adb install -r ${OUT}"
echo "یا فایل APK را به گوشی منتقل و اجرا کنید (فعال‌سازی نصب از منابع ناشناس)."
