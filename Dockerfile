# ---- Basis ----
FROM n8nio/n8n:latest

# Root-Rechte für Installationen
USER root

# ---- Healthcheck Tools ----
RUN apk add --no-cache curl wget

# ---- Globale Node-Libraries installieren ----
# Diese Variante funktioniert auch mit dem neuen PNPM-Setup von n8n
RUN npm install -g \
    bs58@^5.0.0 \
    @solana/web3.js@^1.87.6 \
    axios \
    bignumber.js

# ---- Healthcheck für Coolify ----
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -fs http://localhost:5678/healthz || exit 1

# ---- Zurück zu Standard-User ----
USER node
WORKDIR /home/node
