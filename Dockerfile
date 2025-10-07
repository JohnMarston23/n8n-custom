FROM n8nio/n8n:latest

USER root

# --- Tools für Healthchecks (Alpine!) ---
RUN apk add --no-cache curl wget

# --- Eigene Node-Module sauber separat installieren ---
WORKDIR /home/node/custom_libs
RUN npm init -y && \
    npm install \
      bs58@^5.0.0 \
      @solana/web3.js@^1.87.6

# --- n8n soll diese Module finden ---
ENV NODE_PATH=/home/node/custom_libs/node_modules
ENV N8N_CUSTOM_EXTENSIONS=/home/node/custom_libs

# --- Healthcheck ---
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fs http://localhost:5678/healthz || wget -q -O - http://localhost:5678/healthz || exit 1

USER node
WORKDIR /home/node
