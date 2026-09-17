FROM node:20-alpine

LABEL maintainer="Bishwayan Chatterjee <bish@example.com>" \
      description="Production containerized microservice"

WORKDIR /usr/src/app

ENV NODE_ENV=production \
    PORT=3000

# Leverage Docker layer caching by copying package manifests first
COPY package*.json ./

RUN npm install --only=production --no-audit --no-fund && \
    npm cache clean --force

# Copy application source code
COPY server.js ./

# Create a dedicated non-root user for principle of least privilege
RUN addgroup -g 1001 -S bishgroup && \
    adduser -u 1001 -S bish -G bishgroup && \
    chown -R bish:bishgroup /usr/src/app

USER bish

EXPOSE 3000

HEALTHCHECK --interval=15s --timeout=3s --start-period=5s --retries=3 \
  CMD wget --no-verbose --tries=1 --spider http://127.0.0.1:3000/health || exit 1

CMD ["node", "server.js"]
