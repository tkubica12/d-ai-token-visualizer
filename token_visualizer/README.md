# Token Visualizer Docker

This directory contains the Docker configuration for the Token Visualizer application.

## Building the Image

```bash
docker build -t token-visualizer .
```

## Running the Container

```bash
docker run -p 3000:3000 token-visualizer
```

The application will be available at http://localhost:3000

## Environment Variables

The following environment variables can be configured:

- `REFLEX_ENV`: Set to `production` for production builds (default in Dockerfile)
- `PYTHONPATH`: Application path (set to `/app` in Dockerfile)

## Using with Docker Compose

```yaml
version: '3.8'
services:
  token-visualizer:
    build: .
    ports:
      - "3000:3000"
    environment:
      - REFLEX_ENV=production
```

## Dependencies

The application uses:
- Python 3.12
- uv package manager
- Reflex web framework
- Various ML libraries (torch, transformers, etc.)

## GitHub Actions

The application is automatically built and pushed to GitHub Container Registry when changes are made to the `token_visualizer/` directory.

Image location: `ghcr.io/tkubica12/d-ai-token-visualizer/token_visualizer:latest`
