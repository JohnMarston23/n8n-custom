FROM n8nio/n8n:latest

USER root

# Installieren von curl und wget für Health-Checks mit Alpine-Paketmanager
RUN apk add --no-cache curl wget

# Erstellen einer package.json mit den benötigten Abhängigkeiten
WORKDIR /tmp
RUN echo '{\
  "name": "n8n-custom-modules",\
  "version": "1.0.0",\
  "dependencies": {\
    "bs58": "^5.0.0",\
    "@solana/web3.js": "^1.87.6"\
  }\
}' > package.json

# Installieren der Abhängigkeiten
RUN npm install

# Kopieren der installierten Module nach n8n
RUN cp -r node_modules/* /usr/local/lib/node_modules/n8n/node_modules/ && \
    chmod -R 755 /usr/local/lib/node_modules/n8n/node_modules/bs58 /usr/local/lib/node_modules/n8n/node_modules/@solana

# Aufräumen
RUN rm -rf /tmp/node_modules /tmp/package.json /tmp/package-lock.json

# Eigenen Healthcheck definieren
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/healthz || wget -q -O - http://localhost:5678/healthz || exit 1

# Zurück zum n8n-Benutzer wechseln
USER node

# Arbeitsverzeichnis auf n8n setzen
WORKDIR /home/node
