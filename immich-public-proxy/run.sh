#!/bin/sh
set -e

echo "Starting Immich Public Proxy Add-on..."

# --- DEBUG LINE ---
# This prints the raw settings so we can see exactly what 'jq' sees
echo "Raw options from HA: $(cat /data/options.json)"
# ------------------

# Read core options
export IMMICH_URL=$(jq --raw-output '.immich_url' /data/options.json)
export PUBLIC_BASE_URL=$(jq --raw-output '.public_url' /data/options.json)

# Map Boolean and List options
# Note: Ensure these keys (e.g., .show_home_page) match your config.yaml exactly
export SINGLE_IMAGE_GALLERY=$(jq --raw-output '.single_image_gallery' /data/options.json)
export DOWNLOAD_ORIGINAL_PHOTO=$(jq --raw-output '.download_original' /data/options.json)
export DOWNLOADED_FILENAME=$(jq --raw-output '.downloaded_filename' /data/options.json)
export SHOW_GALLERY_TITLE=$(jq --raw-output '.show_gallery_title' /data/options.json)
export ALLOW_DOWNLOAD_ALL=$(jq --raw-output '.allow_download_all' /data/options.json)
export SHOW_HOME_PAGE=$(jq --raw-output '.show_home_page' /data/options.json)

echo "Configuring environment..."
echo " - Target: $IMMICH_URL"
echo " - Show Home Page: $SHOW_HOME_PAGE"

exec npm start
