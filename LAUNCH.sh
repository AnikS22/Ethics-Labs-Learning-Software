#!/bin/bash

# Ethics Lab LMS Launch Script
# This script will set up and launch the LMS

echo "🚀 Ethics Lab LMS Launch Script"
echo "================================"
echo ""

# Add Docker to PATH if it's in the default location
if [ -d "/Applications/Docker.app/Contents/Resources/bin" ]; then
    export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null && [ ! -f "/Applications/Docker.app/Contents/Resources/bin/docker" ]; then
    echo "❌ Docker is not installed."
    echo ""
    echo "Please install Docker Desktop:"
    echo "  macOS: https://www.docker.com/products/docker-desktop/"
    echo "  Or run: brew install --cask docker"
    echo ""
    echo "After installing Docker, run this script again."
    exit 1
fi

# Use full path if docker not in PATH
if command -v docker &> /dev/null; then
    DOCKER_CMD="docker"
elif [ -f "/Applications/Docker.app/Contents/Resources/bin/docker" ]; then
    DOCKER_CMD="/Applications/Docker.app/Contents/Resources/bin/docker"
    export PATH="/Applications/Docker.app/Contents/Resources/bin:$PATH"
else
    echo "❌ Cannot find Docker executable."
    exit 1
fi

# Check if docker-compose is available
if $DOCKER_CMD compose version &> /dev/null; then
    DOCKER_COMPOSE="$DOCKER_CMD compose"
elif command -v docker-compose &> /dev/null; then
    DOCKER_COMPOSE="docker-compose"
else
    echo "❌ Docker Compose is not available."
    echo "Please install Docker Desktop which includes Docker Compose."
    exit 1
fi

echo "✅ Docker found!"
echo ""

# Navigate to docker directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR/docker" || exit 1

echo "📦 Starting Docker containers..."
echo "This may take a few minutes on first run..."
echo ""

# Start containers
$DOCKER_COMPOSE up -d

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Containers started successfully!"
    echo ""
    echo "⏳ Waiting for services to be ready..."
    echo "   (This may take 2-3 minutes on first run)"
    echo ""
    
    # Wait a bit for services to start
    sleep 5
    
    echo "🌐 LMS should be available at:"
    echo "   http://localhost:8000"
    echo ""
    echo "📝 Next steps:"
    echo "   1. Open http://localhost:8000 in your browser"
    echo "   2. Complete the setup wizard"
    echo "   3. Install the LMS app"
    echo "   4. Create test courses and certificates"
    echo ""
    echo "📚 See QUICK_TEST.md for detailed instructions"
    echo ""
    echo "To stop the server, run:"
    echo "   cd docker && $DOCKER_COMPOSE down"
    echo ""
    
    # Try to open browser (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        echo "🌐 Opening browser in 10 seconds..."
        sleep 10
        open http://localhost:8000 2>/dev/null || echo "Please open http://localhost:8000 manually"
    fi
else
    echo ""
    echo "❌ Failed to start containers."
    echo "Check the logs with: cd docker && $DOCKER_COMPOSE logs"
    exit 1
fi
