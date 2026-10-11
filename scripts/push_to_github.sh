#!/usr/bin/env bash
# =============================================================
#  پوش خودکار به گیت‌هاب (add + commit + push)
#  استفاده:
#     ./scripts/push_to_github.sh "پیام کامیت"
#
#  توکن را یک بار در فایل .env قرار دهید:
#     GITHUB_TOKEN=ghp_xxxxxxxx
#  یا هنگام اجرا بدهید:
#     GITHUB_TOKEN=ghp_xxxx ./scripts/push_to_github.sh "پیام"
# =============================================================
set -euo pipefail
cd "$(dirname "$0")/.."

GREEN='\033[0;32m'; RED='\033[0;31m'; YELLOW='\033[1;33m'; NC='\033[0m'

if [ -f .env ]; then
  set -a; source .env; set +a
fi

: "${GITHUB_TOKEN:?❌ توکن گیت‌هاب لازم است. آن را در فایل .env بگذارید: GITHUB_TOKEN=ghp_xxxx}"

COMMIT_MSG="${1:-}"
if [ -z "${COMMIT_MSG}" ]; then
  echo "📝 پیام کامیت را وارد کنید (یا Enter = پیام خودکار):"
  read -r INPUT_MSG
  COMMIT_MSG="${INPUT_MSG:-🚀 به‌روزرسانی پروژه $(date '+%Y-%m-%d %H:%M')}"
fi

# --- تشخیص owner/repo از ریموت فعلی ---
REPO_SLUG="${GITHUB_REPO:-}"
if [ -z "${REPO_SLUG}" ]; then
  ORIGIN_URL=$(git remote get-url origin 2>/dev/null || echo "")
  REPO_SLUG=$(echo "${ORIGIN_URL}" | sed -E 's#.*github\.com[:/]##; s#\.git$##')
fi
: "${REPO_SLUG:?❌ ریپازیتوری پیدا نشد. اول scripts/setup_github.sh را اجرا کنید یا GITHUB_REPO=owner/name بدهید.}"

echo "🔁 ریموت با توکن تازه‌سازی می‌شود..."
git remote remove origin 2>/dev/null || true
git remote add origin "https://x-access-token:${GITHUB_TOKEN}@github.com/${REPO_SLUG}.git"

BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
echo "📌 شاخه: ${BRANCH}"

git add -A

if git diff --cached --quiet; then
  echo -e "${YELLOW}ℹ️ تغییری برای کامیت وجود ندارد.${NC}"
else
  git commit -m "${COMMIT_MSG}"
  echo -e "${GREEN}✅ کامیت شد: ${COMMIT_MSG}${NC}"
fi

echo "⬆️ در حال پوش..."
git push -u origin "${BRANCH}"

echo ""
echo -e "${GREEN}🎉 پوش با موفقیت انجام شد!${NC}"
echo "🤖 بیلد خودکار APK: https://github.com/${REPO_SLUG}/actions"
echo "📥 دانلود APK:      https://github.com/${REPO_SLUG}/actions → آخرین اجرا → Artifacts"
