#!/bin/bash
# HH Auto Apply — запускает полный цикл
# ./run.sh

set -e

LOG="logs/run_$(date +%Y-%m-%d).log"
mkdir -p logs

log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG"; }

# Загружаем промпты
COVER_SYSTEM=$(cat prompts/cover.txt)
CHAT_SYSTEM=$(cat prompts/chat.txt)

COVER_PROMPT="Вакансия указана выше. Напиши сопроводительное письмо — конкретное, живое, под эту вакансию. Только текст письма."
CHAT_PROMPT="Ты — кандидат. Напиши ОДНО сообщение работодателю. Если последнее сообщение от тебя и ответа нет — верни ТОЛЬКО: NO_REPLY. Только текст, без пояснений."

# 1. Поднять резюме
log "=== Поднимаем резюме ==="
hh-applicant-tool update-resumes 2>&1 | tee -a "$LOG"

# 2. Разослать отклики с AI-письмами
log "=== Рассылаем отклики ==="
hh-applicant-tool apply-vacancies \
  --search "AI автоматизация интеграция ИИ" \
  --use-ai \
  --force-message \
  --first-prompt "$COVER_SYSTEM" \
  --prompt "$COVER_PROMPT" \
  --total-pages 5 \
  --per-page 20 \
  --order-by relevance \
  --excluded-filter "видеомонтаж|монтажёр|моушн.?дизайн|графическ\w+ дизайн|smm|таргетолог|бухгалтер|юрист|водитель|курьер|1с.?программист|android.?разработчик|ios.?разработчик|flutter|kotlin|swift" \
  2>&1 | tee -a "$LOG"

# 3. Ответить в чаты
log "=== Отвечаем в чаты ==="
hh-applicant-tool reply-employers \
  --use-ai \
  --first-prompt "$CHAT_SYSTEM" \
  --prompt "$CHAT_PROMPT" \
  --period 30 \
  2>&1 | tee -a "$LOG"

log "=== Готово ==="
