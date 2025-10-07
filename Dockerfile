FROM n8nio/n8n:latest

USER root
RUN apk add --no-cache curl wget

# direkt in den globalen Kontext installieren, nicht in /usr/local/lib/node_modules/n8n!
RUN npm install -g bs58 @solana/web3.js

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fs http://localhost:5678/healthz || exit 1

USER node
WORKDIR /home/node
