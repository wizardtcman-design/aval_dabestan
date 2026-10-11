#!/usr/bin/env bash
# =============================================================
#  راه‌اندازی اولیه گیت‌هاب — یک بار اجرا کنید
#  استفاده:
#     GITHUB_TOKEN=ghp_xxxx GITHUB_REPO_NAME=kelas-aval ./scripts/setup_github.sh
#  یا توکن را در فایل .env قرار دهید (GITHUB_TOKEN=ghp_xxxx)
# =============================================================
set -euo pipefail
cd "$(dirname "$0")/.."

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

# --- خواندن .env ---
if [ -f .env ]; then
  set -a; source .env; set +a
fi

: "${GITHUB_TOKEN:?❌ توکن را تنظیم کنید: GITHUB_TOKEN=ghp_xxxx ./scripts/setup_github.sh}"
REPO_NAME="${GITHUB_REPO_NAME:-kelas-aval}"
PRIVATE="${GITHUB_PRIVATE:-true}"

echo "🔍 بررسی توکن..."
USER_LOGIN=$(curl -sS -H "Authorization: token ${GITHUB_TOKEN}" https://api.github.com/user \
  | grep -m1 '"login"' | cut -d'"' -f4)

if [ -z "${USER_LOGIN}" ]; then
  echo -e "${RED}❌ توکن نامعتبر است یا دسترسی شبکه وجود ندارد.${NC}"
  exit 1
fi
echo -e "${GREEN}✅ سلام ${USER_LOGIN}!${NC}"

echo "📁 ساخت ریپازیتوری ${USER_LOGIN}/${REPO_NAME} (در صورت عدم وجود)..."
CREATE_RESULT=$(curl -sS -H "Authorization: token ${GITHUB_TOKEN}" \
  -H "Accept: application/vnd.github+json" \
  https://api.github.com/user/repos \
  -d "{\"name\":\"${REPO_NAME}\",\"private\":${PRIVATE},\"description\":\"اپلیکیشن آموزش کلاس اول - فارسی و آفلاین\",\"auto_init\":false}")

if echo "${CREATE_RESULT}" | grep -q '"full_name"'; then
  echo -e "${GREEN}✅ ریپازیتوری ساخته شد.${NC}"
elif echo "${CREATE_RESULT}" | grep -q "already exists"; then
  echo -e "${YELLOW}ℹ️ ریپازیتوری از قبل وجود دارد — ادامه می‌دهیم.${NC}"
else
  echo -e "${RED}❌ خطا در ساخت ریپازیتوری:${NC}"
  echo "${CREATE_RESULT}"
  exit 1
fi

# --- گیت ---
if [ ! -d .git ]; then
  git init -b main
  git config user.name  "${GIT_USER_NAME:-${USER_LOGIN}}"
  git config user.email "${GIT_USER_EMAIL:-${USER_LOGIN}@users.noreply.github.com}"
fi

git remote remove origin 2>/dev/null || true
git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${USER_LOGIN}/${REPO_NAME}.git"

echo "📦 add + commit + push ..."
git add -A
git diff --cached --quiet || git commit -m "🎉 نسخه اول: اپلیکیشن آموزش کلاس اول (فارسی و آفلاین)"
git push -u origin main

echo ""
echo -e "${GREEN}🎉 همه‌چیز آماده است!${NC}"
echo "🔗 ریپازیتوری: https://github.com/${USER_LOGIN}/${REPO_NAME}"
echo "🤖 از این به بعد با هر پوش، APK خودکار ساخته می‌شود:"
echo "   https://github.com/${USER_LOGIN}/${REPO_NAME}/actions"
echo ""
echo "💡 برای ساخت نسخه منتشرشده (Release):"
echo "   git tag v1.0.0 && ./scripts/push_to_github.sh 'انتشار نسخه ۱.۰.۰' && git push origin v1.0.0"
