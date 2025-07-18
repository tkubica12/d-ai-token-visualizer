#!/bin/bash

# Set Reflex environment
export REFLEX_ENV=prod

echo "========================================================================================"
echo "=== STARTING TOKEN VISUALIZER ==="
echo "========================================================================================"
echo "Container started at: $(date)"
echo "Environment variables:"
echo "  LLM_SERVICE_URL: ${LLM_SERVICE_URL}"
echo "  REFLEX_ENV: ${REFLEX_ENV}"
echo "  PWD: $(pwd)"
echo "  PATH: ${PATH}"
echo ""

# Create log directory if it doesn't exist (still needed for some services)
mkdir -p /var/log

# Check if Reflex was properly initialized
echo "=== CHECKING REFLEX INITIALIZATION ==="
if [ ! -d "/app/.web" ]; then
    echo "WARNING: .web directory not found, running reflex init..."
    cd /app && uv run reflex init
    echo "Running reflex export..."
    cd /app && uv run reflex export --frontend-only --no-zip
else
    echo "✓ .web directory already exists"
fi

# Check if static files exist
if [ -d "/app/.web/_static" ]; then
    echo "✓ Static files found at /app/.web/_static"
    echo "Static files:"
    ls -la /app/.web/_static/
else
    echo "✗ Static files not found at /app/.web/_static"
    echo "Contents of /app/.web:"
    ls -la /app/.web/ 2>/dev/null || echo "No .web directory found"
fi

# Test nginx configuration
echo ""
echo "=== TESTING NGINX CONFIGURATION ==="
nginx -t
if [ $? -eq 0 ]; then
    echo "✓ Nginx configuration is valid"
else
    echo "✗ Nginx configuration is invalid"
    echo "Nginx config content:"
    cat /etc/nginx/sites-available/default
    exit 1
fi

# Show process and network status
echo ""
echo "=== SYSTEM STATUS ==="
echo "Available ports before starting:"
netstat -tlnp 2>/dev/null || echo "netstat not available"
echo "Running processes:"
ps aux | head -10

echo ""
echo "=== STARTING SERVICES ==="
echo "Starting supervisord..."
echo "All service logs will appear below in real-time:"
echo "  - Supervisor messages will be prefixed with supervisord"
echo "  - Nginx messages will appear directly"
echo "  - Reflex backend messages will appear directly"
echo ""
echo "========================================================================================"

# Start supervisor with all output going to stdout/stderr
exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
