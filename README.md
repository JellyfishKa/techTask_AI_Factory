# OpenClaw Telegram Bot — Тестовое задание

Развёртывание [OpenClaw](https://github.com/openclaw/openclaw) с Telegram-ботом на базе Qwen (бесплатный провайдер через OpenRouter).

## Что сделано

- Установлен и настроен OpenClaw Gateway
- Подключён AI-провайдер Qwen через OpenRouter (бесплатный тир)
- Создан Telegram-бот, отвечающий на сообщения как AI-ассистент
- Написан кастомный `SOUL.md` с персональностью ассистента
- Настроен Docker для контейнеризированного запуска

---

## Быстрый старт

### Вариант 1: Без Docker (через WSL2)

**Требования:** Node.js 24+, WSL2 на Windows

```bash
# 1. Установить nvm и Node.js 24
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
source ~/.bashrc
nvm install 24

# 2. Установить OpenClaw
npm install -g openclaw@latest

# 3. Скопировать и заполнить конфиг
cp openclaw.json.example ~/.openclaw/openclaw.json
# Отредактировать: вставить API-ключ OpenRouter и токен Telegram-бота

# 4. Скопировать SOUL.md в workspace
cp workspace/SOUL.md ~/.openclaw/workspace/SOUL.md

# 5. Запустить Gateway
openclaw gateway --port 18789 --verbose
```

### Вариант 2: Через Docker

**Требования:** Docker Desktop + Docker Compose v2

```bash
# 1. Создать .env из примера
cp .env.example .env
# Отредактировать .env: вставить реальные ключи

# 2. Создать openclaw.json из примера
cp openclaw.json.example openclaw.json
# Отредактировать: вставить API-ключ и токен

# 3. Запустить
docker compose up --build

# Остановить
docker compose down
```

Gateway доступен на `http://localhost:18789`

---

## Получение API-ключей

### OpenRouter (бесплатный AI-провайдер с Qwen)
1. Зарегистрироваться: https://openrouter.ai
2. Перейти в Keys → Create Key
3. Скопировать ключ в `.env` → `OPENROUTER_API_KEY`

### Telegram Bot Token
1. Открыть [@BotFather](https://t.me/BotFather) в Telegram
2. Отправить `/newbot` и следовать инструкциям
3. Скопировать токен в `.env` → `TELEGRAM_BOT_TOKEN`

---

## Проверка работы

```bash
# Статус Gateway
openclaw status

# Тест через CLI
openclaw agent --message "Привет, как дела?"

# Диагностика при проблемах
openclaw doctor --deep --yes
openclaw logs --follow
```

---

## Структура проекта

```
├── Dockerfile              # Docker-образ
├── docker-compose.yml      # Оркестрация контейнера
├── openclaw.json.example   # Пример конфига (без секретов)
├── .env.example            # Пример переменных окружения
├── .gitignore              # Исключает .env и openclaw.json
├── SOUL.md                 # Персональность ассистента
└── workspace/
    └── SOUL.md             # SOUL.md для workspace OpenClaw
```

---

## Использованные инструменты

- **OpenClaw** — open-source AI Gateway
- **Qwen 2.5 72B** через OpenRouter (бесплатный тир)
- **Claude (Anthropic)** — помощь в написании конфигов и отладке
- **Docker** — контейнеризация
- **WSL2** — среда выполнения на Windows

---

## Трудности

- Настройка кастомного провайдера (Qwen через OpenRouter) требует ручного редактирования `openclaw.json` — онбординг-wizard не предлагает этот вариант напрямую
- На Windows необходим WSL2; нативный запуск нестабилен
- `dmPolicy: "open"` нужно выставить явно, иначе посторонние не смогут написать боту без pairing-кода
