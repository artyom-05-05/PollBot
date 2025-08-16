# Stage 1: builder
FROM node:18-alpine AS builder
WORKDIR /app

# Копируем package.json (+ package-lock.json если есть) и ставим зависимости (legacy peer deps)
COPY package*.json ./
RUN npm ci --legacy-peer-deps

# Копируем весь код и билдим
COPY . .
RUN npm run build

# Stage 2: runtime
FROM node:18-alpine AS runner
WORKDIR /app

# Копируем только production-зависимости
COPY package*.json ./
RUN npm ci --omit=dev --legacy-peer-deps

# Копируем dist из билдера и .env (если используешь env_file в compose — этот шаг можно убрать)
COPY --from=builder /app/dist ./dist
# Если у тебя есть статические конфиги или локальные файлы, добавь их по необходимости

EXPOSE 3000
CMD ["node", "--es-module-specifier-resolution=node", "dist/main.js"]
