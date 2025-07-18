# Local Model Weights Deployment

This guide explains how to deploy the LLM service with pre-downloaded model weights for fast container startup.

## Prerequisites

1. **Downloaded Model Weights**: You should have already downloaded the Gemma model weights into the `weights/` directory.
2. **Docker**: Ensure Docker is installed and running.
3. **For GPU**: Docker with NVIDIA GPU support (nvidia-docker2).

## Quick Start

### Method 1: Using Build Scripts

#### Linux/macOS
```bash
# Make script executable
chmod +x build.sh

# Build CPU version
./build.sh --target cpu

# Build GPU version
./build.sh --target gpu

# Build both versions
./build.sh --target all
```

#### Windows (PowerShell)
```powershell
# Build CPU version
.\build.ps1 -Target cpu

# Build GPU version
.\build.ps1 -Target gpu

# Build both versions
.\build.ps1 -Target all
```

### Method 2: Using Docker Compose

#### CPU Version
```bash
# Build and run CPU version
docker-compose --profile cpu up -d

# View logs
docker-compose logs -f llm-service-cpu
```

#### GPU Version
```bash
# Build and run GPU version (requires nvidia-docker)
docker-compose --profile gpu up -d

# View logs
docker-compose logs -f llm-service-gpu
```

### Method 3: Direct Docker Build

#### CPU Version
```bash
# Build
docker build -f Dockerfile.cpu -t llm-service:cpu .

# Run
docker run -p 8001:8001 llm-service:cpu
```

#### GPU Version
```bash
# Build
docker build -f Dockerfile.gpu -t llm-service:gpu .

# Run with GPU support
docker run --gpus all -p 8001:8001 llm-service:gpu
```

## Configuration

The containers are configured to use local model weights by default. You can override this by setting environment variables:

```bash
# Use local weights (default)
-e LOCAL_MODEL_PATH=./weights

# Fallback to HuggingFace (requires HUGGINGFACE_TOKEN)
-e LOCAL_MODEL_PATH=""
-e HUGGINGFACE_TOKEN=your_token_here
```

## Verification

Once the container is running, you can verify the service:

1. **Health Check**: `curl http://localhost:8001/health`
2. **Model Info**: `curl http://localhost:8001/api/v1/status`
3. **Test Generation**: `curl -X POST http://localhost:8001/api/v1/test`

## Benefits of Pre-downloaded Weights

- **Fast Startup**: No need to download ~5GB of model weights at runtime
- **Offline Deployment**: Works without internet access
- **Consistent Performance**: No network dependency for model loading
- **Better Resource Utilization**: Immediate model availability

## Troubleshooting

### Container Won't Start
- Check if the `weights/` directory exists and contains model files
- Verify Docker has enough memory (8GB+ recommended)
- For GPU: Ensure nvidia-docker is properly installed

### Model Loading Issues
- Check container logs: `docker logs <container_name>`
- Verify model file integrity in the weights directory
- Try fallback to HuggingFace with proper token

### Performance Issues
- For CPU: Consider enabling quantization
- For GPU: Check CUDA compatibility and memory
- Monitor container resource usage
