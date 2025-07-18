#!/bin/bash

echo "=== Health Check ==="
echo "Date: $(date)"
echo ""

echo "=== Process Status ==="
ps aux | grep -E "(nginx|reflex|supervisord)" | grep -v grep
echo ""

echo "=== Port Status ==="
netstat -tlnp | grep -E "(80|8000)"
echo ""

echo "=== Log Files ==="
echo "Supervisor logs:"
if [ -f /var/log/supervisord.log ]; then
    echo "Last 10 lines of supervisord.log:"
    tail -10 /var/log/supervisord.log
else
    echo "No supervisord.log found"
fi

echo ""
echo "Nginx logs:"
if [ -f /var/log/nginx.out.log ]; then
    echo "Last 10 lines of nginx.out.log:"
    tail -10 /var/log/nginx.out.log
else
    echo "No nginx.out.log found"
fi

echo ""
echo "Reflex logs:"
if [ -f /var/log/reflex.out.log ]; then
    echo "Last 10 lines of reflex.out.log:"
    tail -10 /var/log/reflex.out.log
else
    echo "No reflex.out.log found"
fi

echo ""
echo "=== Directory Contents ==="
echo "Contents of /app:"
ls -la /app/
echo ""
echo "Contents of /app/.web (if exists):"
if [ -d /app/.web ]; then
    ls -la /app/.web/
    if [ -d /app/.web/_static ]; then
        echo "Contents of /app/.web/_static:"
        ls -la /app/.web/_static/
    fi
else
    echo "No .web directory found"
fi
echo ""

echo "=== Environment Variables ==="
env | grep -E "(LLM_SERVICE_URL|PATH)" | sort
echo ""

echo "=== End Health Check ==="
