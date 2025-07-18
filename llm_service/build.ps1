# Build script for LLM Service Docker containers (PowerShell)

param(
    [string]$Target = "cpu",
    [string]$Version = "latest",
    [string]$Name = "llm-service",
    [switch]$Help
)

if ($Help) {
    Write-Host "Usage: .\build.ps1 [OPTIONS]"
    Write-Host "Options:"
    Write-Host "  -Target <cpu|gpu|all>     Target to build (default: cpu)"
    Write-Host "  -Version <version>        Image version tag (default: latest)"
    Write-Host "  -Name <name>              Base image name (default: llm-service)"
    Write-Host "  -Help                     Show this help message"
    exit 0
}

function Build-Image {
    param(
        [string]$Target,
        [string]$ImageName,
        [string]$Version
    )
    
    $dockerfile = "Dockerfile.$Target"
    $imageTag = "${ImageName}:${Target}-${Version}"
    
    Write-Host "🏗️  Building $Target image: $imageTag" -ForegroundColor Cyan
    Write-Host "📁 Using dockerfile: $dockerfile" -ForegroundColor Gray
    
    # Check if weights directory exists
    if (!(Test-Path "weights")) {
        Write-Host "⚠️  Warning: weights directory not found. Make sure you have downloaded the model weights." -ForegroundColor Yellow
        Write-Host "   The container will fall back to downloading from HuggingFace." -ForegroundColor Yellow
    } else {
        Write-Host "✅ Found weights directory - using local model weights" -ForegroundColor Green
    }
    
    # Build the image
    try {
        docker build -f $dockerfile -t $imageTag .
        Write-Host "✅ Successfully built $imageTag" -ForegroundColor Green
        Write-Host "🚀 To run: docker run -p 8001:8001 $imageTag" -ForegroundColor Cyan
    } catch {
        Write-Host "❌ Failed to build $imageTag" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor Red
        exit 1
    }
}

# Build based on target
switch ($Target.ToLower()) {
    "cpu" {
        Build-Image -Target "cpu" -ImageName $Name -Version $Version
    }
    "gpu" {
        Build-Image -Target "gpu" -ImageName $Name -Version $Version
    }
    "all" {
        Build-Image -Target "cpu" -ImageName $Name -Version $Version
        Build-Image -Target "gpu" -ImageName $Name -Version $Version
    }
    default {
        Write-Host "❌ Invalid target: $Target. Use 'cpu', 'gpu', or 'all'" -ForegroundColor Red
        exit 1
    }
}

Write-Host "🎉 Build complete!" -ForegroundColor Green
