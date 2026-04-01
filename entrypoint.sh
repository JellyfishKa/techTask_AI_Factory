#!/bin/sh
set -e

CONFIG_DIR="/home/node/.openclaw"
CONFIG_FILE="$CONFIG_DIR/openclaw.json"
CONFIG_TEMPLATE="/tmp/openclaw-config.json"

# Создаём директории если не существуют
mkdir -p "$CONFIG_DIR/workspace"

# Копируем конфиг если его нет (первый запуск с пустым volume)
if [ ! -f "$CONFIG_FILE" ]; then
  echo "First run: copying config template..."
  cp "$CONFIG_TEMPLATE" "$CONFIG_FILE"
fi

# Копируем SOUL.md если workspace пустой
if [ ! -f "$CONFIG_DIR/workspace/SOUL.md" ]; then
  echo "Copying workspace files..."
  cp -r /tmp/workspace/. "$CONFIG_DIR/workspace/"
fi

exec openclaw gateway --port 18789 --verbose
