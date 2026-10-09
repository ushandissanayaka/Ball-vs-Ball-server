# Ball vs Ball game server image, built and pushed by .github/workflows/deploy-bloxity.yml.
# The official node image, pulled from AWS's public mirror: Docker Hub rate-limits GitHub's runners (HTTP 429).
FROM public.ecr.aws/docker/library/node:22-alpine

WORKDIR /app
ENV NODE_ENV=production

COPY package.json package-lock.json ./
RUN npm ci --omit=dev

COPY src ./src
RUN mkdir -p data && chown -R node:node /app

ARG APP_VERSION=dev
ENV APP_VERSION=$APP_VERSION \
    PORT=2568 \
    CLIENT_ORIGIN=https://ball-vs-ball.play.bloxity.io,https://ball-vs-ball.dev.play.bloxity.io,https://bloxity.io,https://*.bloxity.io

USER node
EXPOSE 2568
CMD ["node", "src/index.js"]
