#!/bin/bash

echo "=== Starting Token Visualizer ==="
echo "Container started at: $(date)"
echo "Environment variables:"
echo "  LLM_SERVICE_URL: ${LLM_SERVICE_URL}"
echo "  PWD: $(pwd)"
echo ""

# Create log directory if it doesn't exist
mkdir -p /var/log

# Check if Reflex was properly initialized
echo "Checking Reflex initialization..."
if [ ! -d "/app/.web" ]; then
    echo "WARNING: .web directory not found, running reflex init..."
    cd /app && uv run reflex init
    echo "Running reflex export..."
    cd /app && uv run reflex export --frontend-only --no-zip
fi

# Check if static files exist
if [ -d "/app/.web/_static" ]; then
    echo "✓ Static files found at /app/.web/_static"
    echo "Static files:"
    ls -la /app/.web/_static/
else
    echo "✗ Static files not found at /app/.web/_static"
fi

# Test nginx configuration
echo "Testing nginx configuration..."
nginx -t
if [ $? -eq 0 ]; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ Nginx configuration is invalid"
    exit 1
fi

echo ""
echo "Starting supervisord..."
echo "Logs will be available at:"
echo "  - Supervisor: /var/log/supervisord.log"
echo "  - Nginx: /var/log/nginx.out.log and /var/log/nginx.err.log"
echo "  - Reflex: /var/log/reflex.out.log and /var/log/reflex.err.log"
echo ""
echo "To debug issues, run: /health_check.sh"
echo ""

# Start supervisor with logging
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
