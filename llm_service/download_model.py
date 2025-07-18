#!/usr/bin/env python3
"""
Download Gemma-2-2B model weights using huggingface_hub.
This script handles authentication properly using the HUGGINGFACE_HUB_TOKEN environment variable.
"""

import os
import sys
from pathlib import Path
from huggingface_hub import snapshot_download, login

def main():
    # Get token from environment
    token = os.getenv("HUGGINGFACE_HUB_TOKEN")
    if not token:
        print("Error: HUGGINGFACE_HUB_TOKEN environment variable not set", file=sys.stderr)
        sys.exit(1)
    
    # Login with the token
    try:
        login(token=token)
        print("Successfully authenticated with Hugging Face Hub")
    except Exception as e:
        print(f"Error logging in to Hugging Face Hub: {e}", file=sys.stderr)
        sys.exit(1)
    
    # Set download directory
    weights_dir = Path("./weights")
    weights_dir.mkdir(exist_ok=True)
    
    print("Downloading Gemma-2-2B model...")
    try:
        snapshot_download(
            repo_id="google/gemma-2-2b",
            local_dir=str(weights_dir),
            local_dir_use_symlinks=False,  # Use actual files, not symlinks
            token=token
        )
        print(f"Model successfully downloaded to {weights_dir}")
    except Exception as e:
        print(f"Error downloading model: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == "__main__":
    main()

