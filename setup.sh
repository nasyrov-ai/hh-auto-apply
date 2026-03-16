#!/bin/bash
# Установка за 3 команды

echo "=== Установка hh-applicant-tool ==="
pip install hh-applicant-tool

echo "=== Установка браузера для авторизации ==="
playwright install chromium

echo "=== Авторизация на hh.ru ==="
echo "Откроется браузер — войди как СОИСКАТЕЛЬ (не работодатель)"
hh-applicant-tool authorize --no-headless --manual

echo ""
echo "=== Готово! Запускай: ./run.sh ==="
