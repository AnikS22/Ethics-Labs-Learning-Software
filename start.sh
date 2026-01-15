#!/bin/bash
set -e

echo "🚀 Starting Ethics Labs LMS on Railway..."

# Navigate to docker directory
cd "$(dirname "$0")/docker"

# Run init script
bash init.sh
