FROM node:24-slim

# Системные зависимости
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Установка OpenClaw глобально
RUN npm install -g openclaw@latest

# Установка зависимостей Telegram-плагина внутри openclaw
# (grammy и co. — peer deps, не устанавливаются автоматически через npm)
RUN npm install --prefix /usr/local/lib/node_modules/openclaw --no-save \
    grammy \
    @grammyjs/runner \
    @grammyjs/transformer-throttler \
    @grammyjs/hydrate \
    @grammyjs/auto-retry

WORKDIR /home/node

# Конфиг и workspace сохраняем во временные папки —
# entrypoint скопирует их в volume при первом запуске
RUN mkdir -p /tmp/workspace
COPY openclaw.json /tmp/openclaw-config.json
COPY workspace/ /tmp/workspace/
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# HOME нужен чтобы openclaw нашёл ~/.openclaw
ENV HOME=/home/node
ENV OPENROUTER_API_KEY=""
ENV TELEGRAM_BOT_TOKEN=""

EXPOSE 18789

ENTRYPOINT ["/entrypoint.sh"]
