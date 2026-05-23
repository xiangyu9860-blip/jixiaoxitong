FROM node:22-alpine
WORKDIR /app
ENV NODE_ENV=production
ENV SERVER_HOST=0.0.0.0
ENV PORT=3000

RUN apk add --no-cache unzip coreutils
COPY deploy-source.b64 /tmp/deploy-source.b64
RUN base64 -d /tmp/deploy-source.b64 > /tmp/deploy-source.zip \
  && unzip /tmp/deploy-source.zip -d /app \
  && rm /tmp/deploy-source.b64 /tmp/deploy-source.zip

RUN npm ci
RUN npm run build
RUN npm ci --omit=dev && npm cache clean --force

EXPOSE 3000
CMD ["node", "dist/server/main.js"]
