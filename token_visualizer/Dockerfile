# Multi-stage build for Token Visualizer
FROM python:3.12-slim as builder

# Set working directory
WORKDIR /app

# Install system dependencies and uv
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl -LsSf https://astral.sh/uv/install.sh | sh

# Add uv to PATH
ENV PATH="/root/.local/bin:$PATH"

# Copy project files
COPY pyproject.toml uv.lock* ./

# Install Python dependencies using uv
RUN uv sync --no-dev

# Copy application code
COPY . .

# Initialize Reflex and build frontend
RUN uv run reflex init
RUN uv run reflex export --frontend-only --no-zip

# Production stage
FROM nginx:alpine

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Copy built frontend from builder
COPY --from=builder /app/.web/_static /usr/share/nginx/html

# Create template for runtime configuration
RUN echo 'window.ENV = {' > /usr/share/nginx/html/env-config.js.template && \
    echo '  BACKEND_URL: "${BACKEND_URL}",' >> /usr/share/nginx/html/env-config.js.template && \
    echo '  API_URL: "${API_URL}"' >> /usr/share/nginx/html/env-config.js.template && \
    echo '};' >> /usr/share/nginx/html/env-config.js.template

# Configure nginx for SPA
RUN echo 'server {' > /etc/nginx/conf.d/default.conf && \
    echo '    listen 80;' >> /etc/nginx/conf.d/default.conf && \
    echo '    location / {' >> /etc/nginx/conf.d/default.conf && \
    echo '        root /usr/share/nginx/html;' >> /etc/nginx/conf.d/default.conf && \
    echo '        try_files $uri $uri/ /index.html;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '    # Proxy API calls to backend service' >> /etc/nginx/conf.d/default.conf && \
    echo '    location /_event/ {' >> /etc/nginx/conf.d/default.conf && \
    echo '        proxy_pass http://backend:8000;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '    location /ping {' >> /etc/nginx/conf.d/default.conf && \
    echo '        proxy_pass http://backend:8000;' >> /etc/nginx/conf.d/default.conf && \
    echo '    }' >> /etc/nginx/conf.d/default.conf && \
    echo '}' >> /etc/nginx/conf.d/default.conf

# Create startup script
RUN echo '#!/bin/sh' > /docker-entrypoint.sh && \
    echo 'echo "Configuring frontend with environment variables..."' >> /docker-entrypoint.sh && \
    echo 'echo "BACKEND_URL: ${BACKEND_URL:-http://backend:8000}"' >> /docker-entrypoint.sh && \
    echo 'echo "API_URL: ${API_URL:-${BACKEND_URL:-http://backend:8000}}"' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Generate env-config.js from template' >> /docker-entrypoint.sh && \
    echo 'envsubst < /usr/share/nginx/html/env-config.js.template > /usr/share/nginx/html/env-config.js' >> /docker-entrypoint.sh && \
    echo '' >> /docker-entrypoint.sh && \
    echo '# Start nginx' >> /docker-entrypoint.sh && \
    echo 'nginx -g "daemon off;"' >> /docker-entrypoint.sh && \
    chmod +x /docker-entrypoint.sh

# Set default environment variables
ENV BACKEND_URL=http://backend:8000
ENV API_URL=

EXPOSE 80

# Use custom entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]
