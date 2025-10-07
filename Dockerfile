FROM n8nio/n8n:latest

USER root

# Alle benötigten Module global installieren
RUN npm install -g bs58 @solana/web3.js && \
    chmod -R 755 /usr/local/lib/node_modules/bs58 /usr/local/lib/node_modules/@solana

# Symbolische Links erstellen, damit n8n die Module findet
RUN ln -s /usr/local/lib/node_modules/bs58 /usr/local/lib/node_modules/n8n/node_modules/bs58 || true && \
    ln -s /usr/local/lib/node_modules/@solana /usr/local/lib/node_modules/n8n/node_modules/@solana || true

USER node
