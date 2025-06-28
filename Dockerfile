# Builder stage
FROM node:20-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm i
COPY . .

# Production stage
FROM node:20-alpine
WORKDIR /app
COPY --from=builder /app /app

# Create non-root user and set permissions
RUN adduser -D appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s \
    CMD wget --quiet --tries=1 --spider http://localhost:8080/health || exit 1

CMD ["node", "src/index.js"]