# Token Visualizer Docker

This directory contains the Docker configuration for the Token Visualizer application.

## Architecture

The Token Visualizer runs as a **single-container Reflex application** that includes:

- **Frontend**: React frontend on port 3000 (Next.js dev server)
- **Backend**: Python Reflex backend on port 8000 (FastAPI server)  
- **Single container**: Both processes run together (suitable for workshop/demo)

**Note**: This is a development-style deployment where both frontend and backend run in the same container. The frontend automatically connects to the backend via WebSocket on port 8000.

## Ports

- **Port 3000**: Frontend (React app)
- **Port 8000**: Backend (Python API + WebSocket)

**For Azure Container Apps**: Expose port 3000 (frontend) as the main ingress port.

## Environment Variables

The container needs configuration to connect to the LLM service:

- `LLM_SERVICE_URL`: URL of the LLM service (default: `http://localhost:8001`)
- `LOCAL_MODEL_NAME`: Model name to use (default: `google/gemma-2-2b`)
- `HUGGINGFACE_TOKEN`: Hugging Face token for model access
- `DEVICE`: Device to use (default: `auto`)
- `USE_QUANTIZATION`: Enable quantization (default: `true`)
- `DEBUG`: Enable debug mode (default: `false`)

## Usage Examples

### Azure Container Apps

```bash
# Deploy LLM service
az containerapp create \
  --name llm-service \
  --image ghcr.io/tkubica12/d-ai-token-visualizer/llm_service:cpu \
  --env-vars HUGGINGFACE_TOKEN=your_token_here \
  --ingress internal --target-port 8001

# Deploy Token Visualizer (exposes frontend on port 3000)
az containerapp create \
  --name token-visualizer \
  --image ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest \
  --env-vars LLM_SERVICE_URL=https://llm-service.internal.azurecontainerapps.io \
  --env-vars HUGGINGFACE_TOKEN=your_token_here \
  --ingress external --target-port 3000
```

**Note**: Only port 3000 needs to be exposed externally. The frontend will automatically connect to the backend running on port 8000 within the same container.

### Docker Compose

```yaml
version: '3.8'
services:
  # LLM Service
  llm-service:
    image: ghcr.io/tkubica12/d-ai-token-visualizer/llm_service:cpu
    ports:
      - "8001:8001"
    environment:
      - HUGGINGFACE_TOKEN=your_token_here
  
  # Token Visualizer (single container)
  token-visualizer:
    image: ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest
    ports:
      - "3000:3000"
    environment:
      - LLM_SERVICE_URL=http://llm-service:8001
      - HUGGINGFACE_TOKEN=your_token_here
    depends_on:
      - llm-service
```

## Communication Flow

```
User Browser → Token Visualizer Container → LLM Service
              (Frontend + Backend)        HTTP API
              Port 3000                   Port 8001
```

1. **User** accesses the web app on port 3000
2. **Reflex** serves both frontend and backend from the same container
3. **Python backend** makes HTTP calls to LLM service
4. **WebSocket** communication stays within the same container (no CORS issues)

## Building the Image

```bash
docker build -t token-visualizer .
```

## Running Locally

```bash
# Start LLM service first
docker run -p 8001:8001 \
  -e HUGGINGFACE_TOKEN=your_token_here \
  ghcr.io/tkubica12/d-ai-token-visualizer/llm_service:cpu

# Start Token Visualizer
docker run -p 3000:3000 \
  -e LLM_SERVICE_URL=http://host.docker.internal:8001 \
  -e HUGGINGFACE_TOKEN=your_token_here \
  ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest
```

## Testing URLs

Once running, you can test:

- **Main app**: `http://localhost:3000/` (or your deployed URL)
- **Help page**: `http://localhost:3000/help`
- **Interactive mode**: `http://localhost:3000/interactive`
- **Token tree**: `http://localhost:3000/token-tree`

## GitHub Actions

The image is automatically built and pushed to GitHub Container Registry:
- `ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest`

## Benefits of Single Container

✅ **Simple deployment** - One container, one port
✅ **No WebSocket issues** - Everything runs together
✅ **No reverse proxy complexity** - Reflex handles everything
✅ **Easy to debug** - All logs in one place
✅ **Standard Reflex deployment** - Works exactly like development
