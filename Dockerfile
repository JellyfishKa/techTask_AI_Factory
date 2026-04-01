FROM node:24-slim

# Установка системных зависимостей
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Установка OpenClaw глобально
RUN npm install -g openclaw@latest

# Рабочая директория
WORKDIR /home/node

# Создаём директории
RUN mkdir -p /home/node/.openclaw/workspace

# Копируем конфиг и SOUL.md
COPY openclaw.json /home/node/.openclaw/openclaw.json
COPY workspace/ /home/node/.openclaw/workspace/

# Переменные окружения (значения передаются через .env / docker-compose)
ENV OPENROUTER_API_KEY=""
ENV TELEGRAM_BOT_TOKEN=""

# Открываем порт Gateway
EXPOSE 18789

# Запуск Gateway
CMD ["openclaw", "gateway", "--port", "18789", "--verbose"]
