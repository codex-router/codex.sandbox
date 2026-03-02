#!/bin/bash

# Exit on error
set -e

# Change to the directory where the script is located
cd "$(dirname "$0")"

echo "Building craftslab/codex-sandbox:latest Docker image..."
docker build -f Dockerfile_codex.sandbox -t craftslab/codex-sandbox:latest .
