#!/bin/sh
set -e

echo "Starting Immich Public Proxy Add-on..."

# 1. Core URLs (Keep these as individual exports)
export IMMICH_URL=$(jq --raw-output '.immich_url' /data/options.json)
export PUBLIC_BASE_URL=$(jq --raw-output '.public_url' /data/options.json)

# 2. Advanced Options (Constructed as a single JSON CONFIG object)
# This replaces all the individual export lines for the sub-options.
export CONFIG=$(jq -n \
  --arg sg "$(jq --raw-output '.single_image_gallery' /data/options.json)" \
  --arg do "$(jq --raw-output '.download_original' /data/options.json)" \
  --arg df "$(jq --raw-output '.downloaded_filename' /data/options.json)" \
  --arg gt "$(jq --raw-output '.show_gallery_title' /data/options.json)" \
  --arg da "$(jq --raw-output '.allow_download_all' /data/options.json)" \
  --arg hp "$(jq --raw-output '.show_home_page' /data/options.json)" \
  '{
    ipp: {
      singleImageGallery: ($sg == "true"),
      downloadOriginalPhoto: ($do == "true"),
      downloadedFilename: ($df | tonumber),
      showGalleryTitle: ($gt == "true"),
      allowDownloadAll: ($da | tonumber),
      showHomePage: ($hp == "true")
    }
  }')

echo "Configuring environment..."
echo " - Target: $IMMICH_URL"
echo " - Base URL: $PUBLIC_BASE_URL"
# We don't print the whole CONFIG for security/clutter, 
# but we can print the Home Page status specifically:
echo " - Show Home Page: $(jq --raw-output '.show_home_page' /data/options.json)"

# 3. Start the application
exec npm start
