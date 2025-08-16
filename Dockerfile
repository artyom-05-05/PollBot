# Stage 1: builder
FROM node:18-alpine AS builder
WORKDIR /app

# Копируем package.json (+ package-lock.json если есть) и ставим зависимости (legacy peer deps)
COPY package*.json ./
RUN npm install --legacy-peer-deps

# Копируем весь код и билдим
COPY . .
RUN npm run build

CMD ["npm", "run", "start"]
