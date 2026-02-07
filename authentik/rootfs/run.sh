#!/bin/bash
set -e

echo "Starting RhinoHouse Authentik All-in-One..."

# --- CONFIGURATION ---
DATA_DIR="/data"
PG_DATA="$DATA_DIR/postgresql"
REDIS_DATA="$DATA_DIR/redis"

# Export standard Authentik Configs
export AUTHENTIK_SECRET_KEY=$(jq --raw-output '.secret_key' /data/options.json)
export AUTHENTIK_REDIS__HOST="127.0.0.1"
export AUTHENTIK_POSTGRESQL__HOST="127.0.0.1"
export AUTHENTIK_POSTGRESQL__USER="authentik"
export AUTHENTIK_POSTGRESQL__NAME="authentik"
export AUTHENTIK_POSTGRESQL__PASSWORD="authentik_local_pass" # Local only, safe-ish
export AUTHENTIK_ERROR_REPORTING__ENABLED=false
export AUTHENTIK_DISABLE_UPDATE_CHECK=true

# --- STEP 1: PREPARE DATA DIRS ---
mkdir -p "$PG_DATA" "$REDIS_DATA"
chown -R postgres:postgres "$PG_DATA"
chown -R redis:redis "$REDIS_DATA"

# --- STEP 2: START REDIS ---
echo "Starting Redis..."
# Run redis in background, pointing to our persistent data dir
redis-server --dir "$REDIS_DATA" --daemonize yes

# --- STEP 3: START POSTGRES ---
echo "Starting PostgreSQL..."
if [ ! -s "$PG_DATA/PG_VERSION" ]; then
    echo "Initializing new Database in /data..."
    sudo -u postgres /usr/lib/postgresql/15/bin/initdb -D "$PG_DATA"
    
    # Configure Postgres to listen on localhost
    echo "listen_addresses='127.0.0.1'" >> "$PG_DATA/postgresql.conf"
    
    # Start it temporarily to create user/db
    sudo -u postgres /usr/lib/postgresql/15/bin/pg_ctl -D "$PG_DATA" -w start
    
    echo "Creating Authentik User and DB..."
    sudo -u postgres psql -c "CREATE USER authentik WITH PASSWORD 'authentik_local_pass';"
    sudo -u postgres psql -c "CREATE DATABASE authentik OWNER authentik;"
    
    sudo -u postgres /usr/lib/postgresql/15/bin/pg_ctl -D "$PG_DATA" -m fast -w stop
fi

# Start Postgres for real (in background)
sudo -u postgres /usr/lib/postgresql/15/bin/pg_ctl -D "$PG_DATA" -w start &

# Wait for DB to be ready
until sudo -u postgres psql -h 127.0.0.1 -c '\q'; do
  echo "Waiting for Database..."
  sleep 1
done

# --- STEP 4: AUTHENTIK MIGRATIONS ---
echo "Running Authentik Migrations..."
/lifecycle/ak migrate

# --- STEP 5: START AUTHENTIK ---
# We need to run both Worker and Server.
# We put Worker in background, and Server in foreground to keep container alive.

echo "Starting Worker..."
/lifecycle/ak worker &
WORKER_PID=$!

echo "Starting Server..."
/lifecycle/ak server &
SERVER_PID=$!

# Trap shutdowns to kill everything cleanly
trap "kill $WORKER_PID $SERVER_PID; sudo -u postgres /usr/lib/postgresql/15/bin/pg_ctl -D \"$PG_DATA\" stop" SIGTERM SIGINT

# Wait for processes
wait -n $WORKER_PID $SERVER_PID
