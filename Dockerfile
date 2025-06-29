# Stage 1: Builder for production dependencies
FROM node:20-alpine as deps
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# Stage 2: Builder for application
FROM node:20-alpine as builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY package.json package-lock.json ./
COPY src ./src
# Add build steps here if needed (e.g., for TypeScript)

# Stage 3: Final production image
FROM node:20-alpine
WORKDIR /app

# Copy only production dependencies
COPY --from=deps /app/node_modules ./node_modules

# Copy application files
COPY --from=builder /app/src ./src

# Create non-root user and set permissions
RUN addgroup -g 1001 appgroup && \
    adduser -u 1001 -G appgroup -D appuser && \
    chown -R appuser:appgroup /app
USER appuser

# Set health check
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8080/health || exit 1

# Runtime configuration
ENV NODE_ENV=production
EXPOSE 8080
CMD ["node", "src/index.js"]