FROM n8nio/n8n:latest

USER root

# Direktes Installieren im Zielverzeichnis
WORKDIR /usr/local/lib/node_modules/n8n
RUN npm install bs58 @solana/web3.js

# Berechtigungen anpassen (falls nötig)
RUN chown -R node:node /usr/local/lib/node_modules/n8n/node_modules/bs58 /usr/local/lib/node_modules/n8n/node_modules/@solana

# Zurück zum n8n-Benutzer wechseln
USER node

# Arbeitsverzeichnis zurücksetzen
WORKDIR /home/node
