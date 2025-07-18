# Dockerfile for Token Visualizer (Single Container with Nginx)
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies, uv, and nginx
RUN apt-get update && apt-get install -y \
    curl \
    unzip \
    nginx \
    supervisor \
    net-tools \
    procps \
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

# Copy nginx configuration
COPY nginx.conf /etc/nginx/sites-available/default

# Copy supervisor configuration
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Copy health check script
COPY health_check.sh /health_check.sh
RUN chmod +x /health_check.sh

# Set environment variables
ENV LLM_SERVICE_URL=http://localhost:8001
ENV DEBUG=true

# Expose port 80 (nginx will handle routing)
EXPOSE 80

# Run startup script
CMD ["/start.sh"]
