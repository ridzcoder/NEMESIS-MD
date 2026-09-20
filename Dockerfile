FROM node:20-slim

# Native dependencies that were previously supplied by the four
# buildpacks in app.json. In container mode, buildpacks don't run, so
# these must be installed here instead:
#   - ffmpeg       → audio/video conversion (was: ffmpeg buildpack)
#   - webp         → provides cwebp/dwebp for sticker commands (was: webp-binaries buildpack)
#   - imagemagick  → image manipulation / sticker resize (was: imagemagick buildpack)
#   - git, build-essential, python3 → native npm modules sometimes need these
RUN apt-get update && apt-get install -y --no-install-recommends \
      ffmpeg \
      imagemagick \
      webp \
      git \
      ca-certificates \
      curl \
      python3 \
      make \
      g++ \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy manifests first so Docker caches the install layer — rebuilding
# after only source changes won't re-download every dependency.
COPY package*.json ./
COPY yarn.lock* ./

# Install with yarn if a lockfile exists, otherwise fall back to npm.
# Install devDependencies too (no --production / --omit=dev) — some
# WhatsApp bots load helpers from devDependencies at runtime.
RUN if [ -f yarn.lock ]; then \
      yarn install --frozen-lockfile --network-timeout 600000; \
    else \
      npm install --no-audit --no-fund; \
    fi

# Copy the rest of the source.
COPY . .

ENV NODE_ENV=production

# Heroku assigns $PORT at runtime. If the bot runs an HTTP/health
# server it should listen on process.env.PORT, not a hardcoded port.
EXPOSE 3000

CMD ["node", "index.js"]