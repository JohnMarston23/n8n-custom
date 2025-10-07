FROM n8nio/n8n:latest

USER root

# --- Tools für Healthchecks installieren (Alpine!) ---
RUN apk add --no-cache curl wget

# --- Eigene Node-Module separat installieren ---
WORKDIR /home/node/custom_libs
RUN npm init -y && \
    npm install \
      bs58@^5.0.0 \
      @solana/web3.js@^1.87.6

# --- n8n soll diese Module finden ---
ENV NODE_PATH=/home/node/custom_libs/node_modules
ENV N8N_CUSTOM_EXTENSIONS=/home/node/custom_libs

# --- Healthcheck: als root ausführen, bevor der USER gewechselt wird ---
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD /usr/bin/curl -fs http://localhost:5678/healthz || /usr/bin/wget -q -O - http://localhost:5678/healthz || exit 1

# --- Zurück zum Standard-User ---
USER node
WORKDIR /home/node
