#!/bin/sh
set -e

echo "Starting Immich Public Proxy Add-on..."

# 1. Core URLs
export IMMICH_URL=$(jq --raw-output '.immich_url' /data/options.json)
export PUBLIC_BASE_URL=$(jq --raw-output '.public_url' /data/options.json)

# 2. Advanced Options
export CONFIG=$(jq -n \
  --arg sg "$(jq --raw-output '.single_image_gallery' /data/options.json)" \
  --arg do "$(jq --raw-output '.download_original' /data/options.json)" \
  --arg df "$(jq --raw-output '.downloaded_filename' /data/options.json)" \
  --arg gt "$(jq --raw-output '.show_gallery_title' /data/options.json)" \
  --arg da "$(jq --raw-output '.allow_download_all' /data/options.json)" \
  --arg hp "$(jq --raw-output '.show_home_page' /data/options.json)" \
  --arg desc "$(jq --raw-output '.show_image_description' /data/options.json)" \
  '{
    ipp: {
      singleImageGallery: ($sg == "true"),
      downloadOriginalPhoto: ($do == "true"),
      downloadedFilename: ($df | tonumber),
      showGalleryTitle: ($gt == "true"),
      allowDownloadAll: ($da | tonumber),
      showHomePage: ($hp == "true"),
      showMetadata: {
        title: ($gt == "true"),
        description: ($desc == "true")
      }
    }
  }')

echo "Configuring environment..."

exec npm start
