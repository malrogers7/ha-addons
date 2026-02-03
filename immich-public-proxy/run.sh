#!/bin/sh
set -e

echo "Starting Immich Public Proxy Add-on..."

# 1. Read config options from Home Assistant using jq
# We extract the value from options.json and assign it to the variable the app expects
IMMICH_URL=$(jq --raw-output '.immich_url' /data/options.json)
PUBLIC_URL=$(jq --raw-output '.public_url' /data/options.json)

echo "Configuring environment..."
echo "Target Immich Instance: $IMMICH_URL"

# 2. Export them as Environment Variables
# The specific variable names (IMMICH_URL, PUBLIC_BASE_URL) depend on the app's documentation
export IMMICH_URL="$IMMICH_URL"
export PUBLIC_BASE_URL="$PUBLIC_URL"

# 3. Start the application
exec npm start
