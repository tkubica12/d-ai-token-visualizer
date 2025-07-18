"""Configuration management for Token Visualizer application."""

import os
from dataclasses import dataclass
from typing import Optional
from dotenv import load_dotenv


@dataclass
class LLMServiceConfig:
    """Configuration for LLM service (remote HTTP service)."""
    service_url: str
    
    def __post_init__(self):
        """Validate configuration after initialization."""
        if not self.service_url:
            raise ValueError("LLM_SERVICE_URL is required")


# Legacy Azure OpenAI Config (kept for backwards compatibility)
@dataclass
class AzureOpenAIConfig:
    """Configuration for Azure OpenAI service (deprecated)."""
    endpoint: str = ""
    deployment_name: str = ""
    api_version: str = ""
    api_key: Optional[str] = None
    use_azure_default_credentials: bool = True


@dataclass
class AppConfig:
    """Main application configuration."""
    llm_service: LLMServiceConfig
    debug: bool = False
    
    @classmethod
    def load_from_env(cls) -> "AppConfig":
        """Load configuration from environment variables."""
        # Load .env file if it exists
        load_dotenv()
        
        # Get Local LLM configuration - only need service URL
        service_url = os.getenv("LLM_SERVICE_URL", "http://localhost:8001")
        
        # Create LLM service config
        llm_service_config = LLMServiceConfig(
            service_url=service_url
        )
        
        # Get general app configuration
        debug = os.getenv("DEBUG", "false").lower() == "true"
        
        return cls(
            llm_service=llm_service_config,
            debug=debug
        )
    
    def is_valid(self) -> tuple[bool, str]:
        """Check if configuration is valid."""
        try:
            # This will raise ValueError if invalid
            self.llm_service.__post_init__()
            return True, "Configuration is valid"
        except ValueError as e:
            return False, str(e)


# Global configuration instance
_config: Optional[AppConfig] = None


def get_config() -> AppConfig:
    """Get the global configuration instance."""
    global _config
    if _config is None:
        _config = AppConfig.load_from_env()
    return _config


def reload_config() -> AppConfig:
    """Reload configuration from environment variables."""
    global _config
    _config = AppConfig.load_from_env()
    return _config


def test_config() -> dict:
    """Test configuration and return status information."""
    try:
        config = get_config()
        is_valid, message = config.is_valid()
        
        return {
            "valid": is_valid,
            "message": message,
            "service_url": config.llm_service.service_url,
            "debug": config.debug
        }
    except Exception as e:
        return {
            "valid": False,
            "message": f"Configuration error: {str(e)}",
            "error": str(e)
        }
