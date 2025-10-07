FROM n8nio/n8n:latest

USER root

# bs58 global installieren statt im n8n-Verzeichnis
RUN npm install -g bs58

# Symbolischen Link erstellen, damit n8n es findet
RUN ln -s /usr/local/lib/node_modules/bs58 /usr/local/lib/node_modules/n8n/node_modules/bs58 || true

USER node
