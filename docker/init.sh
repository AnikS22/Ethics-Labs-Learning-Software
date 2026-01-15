#!/bin/bash

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd frappe-bench
    bench start
else
    echo "Creating new bench..."
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
    echo "Node.js found: $(which node) ($(node --version))"
fi

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

bench get-app lms /home/frappe/lms-app

bench new-site lms.localhost \
--force \
--mariadb-root-password $MARIADB_PASSWORD \
--admin-password admin \
--no-mariadb-socket

bench --site lms.localhost install-app lms
bench --site lms.localhost set-config developer_mode 1
bench --site lms.localhost clear-cache
bench use lms.localhost

bench start
