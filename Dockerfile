# Use Node 20 (npm only – no Bun)
FROM node:20-alpine AS builder

WORKDIR /app

# Install deps from lockfile (npm only)
COPY package.json package-lock.json ./
RUN npm ci

# Build frontend
COPY . .
RUN npm run build

# Production image: serve with Node
FROM node:20-alpine

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY --from=builder /app/dist ./dist
COPY server ./server
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN sed -i 's/\r$//' /docker-entrypoint.sh && chmod +x /docker-entrypoint.sh

ENV NODE_ENV=production
EXPOSE 3001

ENTRYPOINT ["/docker-entrypoint.sh"]
