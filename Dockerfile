# Stage 1: Install production dependencies only
FROM node:20-alpine as deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Stage 2: Create clean production image
FROM node:20-alpine
WORKDIR /app

# Copy production dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy ONLY application source
COPY src ./src

# Create non-root user and set permissions
RUN adduser -D appuser && \
    chown -R appuser:appuser /app
USER appuser

# Runtime configuration
ENV NODE_ENV=production
EXPOSE 8080
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8080/health || exit 1

CMD ["node", "src/index.js"]