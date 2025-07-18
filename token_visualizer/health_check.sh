#!/bin/bash

echo "========================================================================================"
echo "=== HEALTH CHECK REPORT ==="
echo "========================================================================================"
echo "Date: $(date)"
echo ""

echo "=== PROCESS STATUS ==="
echo "All processes:"
ps aux
echo ""
echo "Filtered processes (nginx, reflex, supervisord):"
ps aux | grep -E "(nginx|reflex|supervisord)" | grep -v grep
echo ""

echo "=== PORT STATUS ==="
echo "Listening ports:"
netstat -tlnp 2>/dev/null || ss -tlnp 2>/dev/null || echo "No netstat/ss available"
echo ""
echo "Filtered ports (80, 8000):"
netstat -tlnp 2>/dev/null | grep -E "(80|8000)" || ss -tlnp 2>/dev/null | grep -E "(80|8000)" || echo "No matching ports found"
echo ""

echo "=== DIRECTORY CONTENTS ==="
echo "Contents of /app:"
ls -la /app/
echo ""
echo "Contents of /app/.web (if exists):"
if [ -d /app/.web ]; then
    ls -la /app/.web/
    if [ -d /app/.web/_static ]; then
        echo ""
        echo "Contents of /app/.web/_static:"
        ls -la /app/.web/_static/
        echo ""
        echo "Sample static files:"
        find /app/.web/_static -type f | head -10
    fi
else
    echo "No .web directory found"
fi
echo ""

echo "=== ENVIRONMENT VARIABLES ==="
echo "All environment variables:"
env | sort
echo ""

echo "=== CONFIGURATION FILES ==="
echo "Nginx configuration:"
cat /etc/nginx/sites-available/default
echo ""
echo "Supervisor configuration:"
cat /etc/supervisor/conf.d/supervisord.conf
echo ""

echo "=== CONNECTIVITY TESTS ==="
echo "Testing localhost:8000 (Reflex backend):"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:8000/ping 2>/dev/null || echo "Connection failed"
echo ""
echo "Testing localhost:80 (Nginx):"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost:80/ 2>/dev/null || echo "Connection failed"
echo ""
echo "Testing WebSocket endpoint on backend:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" "http://localhost:8000/_event/?EIO=4&transport=polling" 2>/dev/null || echo "WebSocket polling test failed"
echo ""
echo "Testing WebSocket endpoint through nginx:"
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" "http://localhost:80/_event/?EIO=4&transport=polling" 2>/dev/null || echo "WebSocket polling test through nginx failed"
echo ""

echo "=== SYSTEM RESOURCES ==="
echo "Memory usage:"
free -h 2>/dev/null || echo "free command not available"
echo ""
echo "Disk usage:"
df -h 2>/dev/null || echo "df command not available"
echo ""

echo "========================================================================================"
echo "=== END HEALTH CHECK ==="
echo "========================================================================================"
