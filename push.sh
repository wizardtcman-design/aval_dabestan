#!/usr/bin/env bash
# ============================================================
#  push.sh — یک‌کلیک push به گیت‌هاب
#  استفاده:  ./push.sh "پیام کامیت"
#  توکن به‌ترتیب از این منابع خوانده می‌شود:
#    1) متغیر محیطی GITHUB_TOKEN
#    2) فایل .github-token (در .gitignore است و کامیت نمی‌شود)
#    3) ورودی دستی (بدون نمایش حروف)
# ============================================================
set -euo pipefail
cd "$(dirname "$0")"

REPO="${GITHUB_REPO:-wizardtcman-design/aval_dabestan}"
TOKEN_FILE=".github-token"

TOKEN="${GITHUB_TOKEN:-}"
if [ -z "$TOKEN" ] && [ -f "$TOKEN_FILE" ]; then
  TOKEN="$(tr -d '[:space:]' < "$TOKEN_FILE")"
fi
if [ -z "$TOKEN" ]; then
  printf 'GitHub Personal Access Token: '
  read -rs TOKEN
  printf '\n'
fi
if [ -z "$TOKEN" ]; then
  echo "خطا: توکن خالی است."
  exit 1
fi

# اگر ریپازیتوری هنوز مقداردهی نشده باشد
if [ ! -d .git ]; then
  echo "== مقداردهی اولیه گیت =="
  git init -b main
  git config user.name  "${GIT_USER_NAME:-wizardtcman-design}"
  git config user.email "${GIT_USER_EMAIL:-322121961+wizardtcman-design@users.noreply.github.com}"
fi

git remote add origin "https://github.com/${REPO}.git" 2>/dev/null \
  || git remote set-url origin "https://github.com/${REPO}.git"

git add -A
if git diff --cached --quiet; then
  echo "== هیچ تغییری برای کامیت وجود ندارد =="
else
  git commit -m "${1:-به‌روزرسانی: محتوا و کد}"
fi

echo "== ارسال به گیت‌هاب... =="
git push "https://x-access-token:${TOKEN}@github.com/${REPO}.git" HEAD:main --tags

echo "== انجام شد! کامیت‌ها به github.com/${REPO} ارسال شدند =="
echo "ساخت خودکار APK در تب Actions آغاز می‌شود."
