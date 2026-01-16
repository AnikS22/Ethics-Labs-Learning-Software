#!/bin/bash
set -e  # Exit on error

echo "=== Ethics Labs LMS - Railway Deployment ==="
echo "Starting initialization..."

# Check if bench command is available
echo "Checking for bench command..."
if ! command -v bench &> /dev/null; then
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
    
    # Verify bench is now available
    if ! command -v bench &> /dev/null; then
        echo "❌ ERROR: bench still not found after installation!"
        echo "PATH: $PATH"
        echo "Trying to locate bench..."
        find /home/frappe -name bench -type f 2>/dev/null || true
        find /usr -name bench -type f 2>/dev/null || true
        exit 1
    fi
    echo "✅ bench installed successfully: $(which bench)"
else
    echo "✅ bench found: $(which bench) ($(bench --version 2>/dev/null || echo 'version unknown'))"
fi

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
    bench start
    exit 0
fi

echo "Creating new bench..."
bench init --skip-redis-config-generation frappe-bench

cd frappe-bench

# Use environment variables from Railway (or default to local docker)
MARIADB_HOST="${MYSQL_HOST:-mariadb}"
REDIS_HOST="${REDIS_HOST:-redis}"
REDIS_PORT="${REDIS_PORT:-6379}"
MARIADB_PASSWORD="${MYSQL_ROOT_PASSWORD:-123}"

bench set-mariadb-host $MARIADB_HOST
bench set-redis-cache-host redis://${REDIS_HOST}:${REDIS_PORT}
bench set-redis-queue-host redis://${REDIS_HOST}:${REDIS_PORT}
bench set-redis-socketio-host redis://${REDIS_HOST}:${REDIS_PORT}

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

echo "Getting LMS app from /home/frappe/lms-app..."
bench get-app lms /home/frappe/lms-app

echo "Creating new site lms.localhost..."
bench new-site lms.localhost \
--force \
--mariadb-root-password $MARIADB_PASSWORD \
--admin-password admin \
--no-mariadb-socket

echo "Installing LMS app..."
bench --site lms.localhost install-app lms

echo "Configuring site..."
bench --site lms.localhost set-config developer_mode 1
bench --site lms.localhost clear-cache
bench use lms.localhost

echo "✅ Setup complete! Starting bench..."
echo "=================================="
bench start
