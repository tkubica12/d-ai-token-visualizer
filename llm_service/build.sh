#!/bin/bash

# Build script for LLM Service Docker containers

set -e

# Default values
TARGET="cpu"
IMAGE_NAME="llm-service"
VERSION="latest"

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            TARGET="$2"
            shift 2
            ;;
        --version)
            VERSION="$2"
            shift 2
            ;;
        --name)
            IMAGE_NAME="$2"
            shift 2
            ;;
        --help)
            echo "Usage: $0 [OPTIONS]"
            echo "Options:"
            echo "  --target <cpu|gpu|all>     Target to build (default: cpu)"
            echo "  --version <version>        Image version tag (default: latest)"
            echo "  --name <name>              Base image name (default: llm-service)"
            echo "  --help                     Show this help message"
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

# Function to build image
build_image() {
    local target=$1
    local dockerfile="Dockerfile.${target}"
    local image_tag="${IMAGE_NAME}:${target}-${VERSION}"
    
    echo "🏗️  Building ${target} image: ${image_tag}"
    echo "📁 Using dockerfile: ${dockerfile}"
    
    # Check if weights directory exists
    if [ ! -d "weights" ]; then
        echo "⚠️  Warning: weights directory not found. Make sure you have downloaded the model weights."
        echo "   The container will fall back to downloading from HuggingFace."
    else
        echo "✅ Found weights directory - using local model weights"
    fi
    
    # Build the image
    docker build -f "${dockerfile}" -t "${image_tag}" .
    
    echo "✅ Successfully built ${image_tag}"
    echo "🚀 To run: docker run -p 8001:8001 ${image_tag}"
}

# Build based on target
case $TARGET in
    cpu)
        build_image "cpu"
        ;;
    gpu)
        build_image "gpu"
        ;;
    all)
        build_image "cpu"
        build_image "gpu"
        ;;
    *)
        echo "❌ Invalid target: $TARGET. Use 'cpu', 'gpu', or 'all'"
        exit 1
        ;;
esac

echo "🎉 Build complete!"
