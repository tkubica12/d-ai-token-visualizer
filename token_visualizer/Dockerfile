# Dockerfile for Token Visualizer (Full Reflex App)
FROM python:3.12-slim

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

# Dockerfile for Token Visualizer (Full Reflex App)
FROM python:3.12-slim

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

# Initialize Reflex
RUN uv run reflex init

# Set default environment variables
ENV LLM_SERVICE_URL=http://localhost:8001

# Expose ports for both frontend and backend
EXPOSE 3000 8000

# Create a simple startup script that runs both processes
RUN echo '#!/bin/bash' > /start.sh && \
    echo 'echo "Starting Reflex Token Visualizer..."' >> /start.sh && \
    echo 'echo "Frontend will be available on port 3000"' >> /start.sh && \
    echo 'echo "Backend will be available on port 8000"' >> /start.sh && \
    echo 'echo "Environment variables:"' >> /start.sh && \
    echo 'echo "  LLM_SERVICE_URL: $LLM_SERVICE_URL"' >> /start.sh && \
    echo 'echo ""' >> /start.sh && \
    echo 'exec uv run reflex run --env prod' >> /start.sh && \
    chmod +x /start.sh

# Run the startup script
CMD ["/start.sh"]
