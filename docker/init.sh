#!/bin/bash
set -e  # Exit on error

echo "=== Ethics Labs LMS - Railway Deployment ==="
echo "Starting initialization..."

# Source profile to get PATH from Dockerfile
if [ -f ~/.profile ]; then
    source ~/.profile
fi
if [ -f ~/.bashrc ]; then
    source ~/.bashrc
fi

# Ensure PATH includes bench location (from Dockerfile)
export PATH="/home/frappe/.local/bin:/usr/local/bin:/usr/bin:/bin:${PATH}"

# Function to find bench
find_bench() {
    # Try common locations
    BENCH_LOCATIONS=(
        "/home/frappe/.local/bin/bench"
        "/usr/local/bin/bench"
        "/usr/bin/bench"
        "$(which bench 2>/dev/null)"
    )
    
    for location in "${BENCH_LOCATIONS[@]}"; do
        if [ -x "$location" ]; then
            echo "$location"
            return 0
        fi
    done
    
    # Try to find it
    FOUND=$(find /home/frappe/.local -name bench -type f 2>/dev/null | head -1)
    if [ -n "$FOUND" ] && [ -x "$FOUND" ]; then
        echo "$FOUND"
        return 0
    fi
    
    return 1
}

# Check if bench command is available
echo "Checking for bench command..."
echo "Current PATH: $PATH"

BENCH_PATH=$(find_bench)

if [ -z "$BENCH_PATH" ]; then
    echo "⚠️  bench command not found, installing..."
    
    # Try to find Python
    if command -v python3 &> /dev/null; then
        PYTHON_CMD="python3"
    elif command -v python &> /dev/null; then
        PYTHON_CMD="python"
    else
        echo "❌ ERROR: Python not found! Cannot install bench."
        exit 1
    fi
    
    echo "Found Python: $(which $PYTHON_CMD) ($($PYTHON_CMD --version))"
    
    # Install bench using pip (user install)
    echo "Installing frappe-bench..."
    $PYTHON_CMD -m pip install --user frappe-bench || pip3 install --user frappe-bench || pip install --user frappe-bench
    
    # Update PATH to include user local bin
    export PATH="/home/frappe/.local/bin:${PATH}"
    
    # Try to find bench again
    BENCH_PATH=$(find_bench)
    
    if [ -z "$BENCH_PATH" ]; then
        echo "❌ ERROR: bench still not found after installation!"
        echo "PATH: $PATH"
        echo "Trying to locate bench..."
        find /home/frappe -name bench -type f 2>/dev/null || true
        find /usr -name bench -type f 2>/dev/null || true
        exit 1
    fi
    echo "✅ bench installed successfully: $BENCH_PATH"
else
    echo "✅ bench found: $BENCH_PATH ($($BENCH_PATH --version 2>/dev/null || echo 'version unknown'))"
fi

# Create bench alias/function to use full path
alias bench="$BENCH_PATH" 2>/dev/null || true
export BENCH_CMD="$BENCH_PATH"

# Use full path for all bench commands
bench() {
    "$BENCH_CMD" "$@"
}

# Check if node is already in PATH (frappe/bench image includes it)
if ! command -v node &> /dev/null; then
    # Node not found, try to use NVM if available
    if [ -n "$NVM_DIR" ] && [ -n "$NODE_VERSION_DEVELOP" ]; then
        export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"
        echo "Using NVM Node.js version ${NODE_VERSION_DEVELOP}"
    else
        # Try common Node.js installation paths
        if [ -d "/usr/local/bin" ]; then
            export PATH="/usr/local/bin:${PATH}"
        fi
        echo "Warning: Node.js not found in PATH, attempting to use system Node.js"
    fi
else
    echo "✅ Node.js found: $(which node) ($(node --version))"
fi

# Check if bench already exists
if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "✅ Bench already exists, skipping init"
    cd frappe-bench
    "$BENCH_CMD" start
    exit 0
fi

echo "Creating new bench..."
"$BENCH_CMD" init --skip-redis-config-generation frappe-bench

cd frappe-bench

# Use environment variables from Railway (or default to local docker)
MARIADB_HOST="${MYSQL_HOST:-mariadb}"
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
MARIADB_PASSWORD="${MYSQL_ROOT_PASSWORD:-123}"

"$BENCH_CMD" set-mariadb-host $MARIADB_HOST
"$BENCH_CMD" set-redis-cache-host redis://${REDIS_HOST}:${REDIS_PORT}
"$BENCH_CMD" set-redis-queue-host redis://${REDIS_HOST}:${REDIS_PORT}
"$BENCH_CMD" set-redis-socketio-host redis://${REDIS_HOST}:${REDIS_PORT}

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

echo "Getting LMS app from /home/frappe/lms-app..."
"$BENCH_CMD" get-app lms /home/frappe/lms-app

echo "Creating new site lms.localhost..."
"$BENCH_CMD" new-site lms.localhost \
--force \
--mariadb-root-password $MARIADB_PASSWORD \
--admin-password admin \
--no-mariadb-socket

echo "Installing LMS app..."
"$BENCH_CMD" --site lms.localhost install-app lms

echo "Configuring site..."
"$BENCH_CMD" --site lms.localhost set-config developer_mode 1
"$BENCH_CMD" --site lms.localhost clear-cache
"$BENCH_CMD" use lms.localhost

echo "✅ Setup complete! Starting bench..."
echo "=================================="
"$BENCH_CMD" start
