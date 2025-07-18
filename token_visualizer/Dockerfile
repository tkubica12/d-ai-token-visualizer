# Use Python 3.12 as base image
FROM python:3.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install uv
RUN pip install uv

# Copy uv configuration files
COPY pyproject.toml uv.lock ./

# Install dependencies using uv
RUN uv sync --frozen

# Copy the application code
COPY . .

# Set environment variables
ENV PYTHONPATH=/app
ENV REFLEX_ENV=production

# Expose port 3000 (default Reflex port)
EXPOSE 3000

# Create a non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

# Run the Reflex application
CMD ["uv", "run", "reflex", "run", "--env", "prod", "--host", "0.0.0.0", "--port", "3000"]
