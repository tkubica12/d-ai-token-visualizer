import reflex as rx
import os

config = rx.Config(
    app_name="token_visualizer",
    tailwind=None,  # Disable Tailwind to avoid deprecation warning
    backend_port=8000,
    frontend_port=3000,
    cors_allowed_origins=["*"],
    # For production deployment with HTTPS/WSS support
    env=rx.Env.PROD if os.getenv("REFLEX_ENV") == "prod" else rx.Env.DEV,
    # Enable WebSocket support for production
    backend_host="0.0.0.0",
    # Trust proxy headers for HTTPS/WSS
    backend_proxy_headers=True,
)
