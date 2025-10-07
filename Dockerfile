FROM n8nio/n8n:latest

# Root-Rechte für Installation
USER root

# --- Tools für Healthchecks ---
RUN apt-get update && \
    apt-get install -y curl wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# --- Eigene Node-Module sauber separat installieren ---
WORKDIR /home/node/custom_libs
RUN npm init -y && \
    npm install \
      bs58@^5.0.0 \
      @solana/web3.js@^1.87.6

# --- Environment Variable für n8n, damit es diese Libs sieht ---
ENV NODE_PATH=/home/node/custom_libs/node_modules
ENV N8N_CUSTOM_EXTENSIONS=/home/node/custom_libs

# --- Healthcheck ---
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fs http://localhost:5678/healthz || wget -q -O - http://localhost:5678/healthz || exit 1

# --- Zurück zu normalem User ---
USER node
WORKDIR /home/node

# --- Start (Coolify handled entrypoint) ---
