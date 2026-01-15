#!/bin/bash
set -e  # Exit on error

echo "🚀 Starting Ethics Labs LMS initialization..."

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "✅ Bench already exists, skipping init"
    cd frappe-bench
    bench start
else
    echo "📦 Creating new bench..."
fi

export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

bench init --skip-redis-config-generation frappe-bench

cd frappe-bench

# Use environment variables from Railway (or default to local docker)
MARIADB_HOST="${MYSQL_HOST:-${MYSQLHOST:-mariadb}}"
REDIS_HOST="${REDIS_HOST:-${REDISHOST:-redis}}"
REDIS_PORT="${REDIS_PORT:-${REDISPORT:-6379}}"
MARIADB_PASSWORD="${MYSQL_ROOT_PASSWORD:-${MYSQLPASSWORD:-123}}"

echo "🔧 Configuring database connections..."
echo "   MySQL Host: $MARIADB_HOST"
echo "   Redis Host: $REDIS_HOST:$REDIS_PORT"

bench set-mariadb-host $MARIADB_HOST
bench set-redis-cache-host redis://${REDIS_HOST}:${REDIS_PORT}
bench set-redis-queue-host redis://${REDIS_HOST}:${REDIS_PORT}
bench set-redis-socketio-host redis://${REDIS_HOST}:${REDIS_PORT}

# Remove redis, watch from Procfile
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

echo "📥 Getting Ethics Labs LMS app..."
bench get-app lms /workspace/lms || bench get-app https://github.com/frappe/lms.git

echo "🏗️ Creating new site..."
bench new-site lms.localhost \
--force \
--mariadb-root-password ${MARIADB_PASSWORD} \
--admin-password admin \
--no-mariadb-socket

echo "📦 Installing Ethics Labs LMS..."
bench --site lms.localhost install-app lms

echo "⚙️ Configuring site..."
bench --site lms.localhost set-config developer_mode 1
bench --site lms.localhost clear-cache
bench use lms.localhost

echo "✅ Initialization complete!"
echo "🚀 Starting Ethics Labs LMS server..."
bench start
