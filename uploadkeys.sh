#!/bin/bash

# ========== Load local .env variables safely ==========
if [ -f .env ]; then
  set -o allexport
  source .env
  set +o allexport
else
  echo ".env file not found!"
  exit 1
fi

KEYS_DIR="vendor/lineage-priv/keys"
ARCHIVE_PATH="/tmp/lineage-keys.tar.gz"

upload_file() {
  local file_path="$1"
  local label="$2"

  if [[ ! -f "$file_path" ]]; then
    echo "No $label found at $file_path"
    return 1
  fi

  echo "Uploading $label to Pixeldrain..."

  response=$(curl -s -u ":$PIXELDRAIN_API_KEY" \
    -X POST \
    -F "file=@$file_path" \
    https://pixeldrain.com/api/file)

  file_id=$(echo "$response" | jq -r '.id')
  file_name=$(basename "$file_path")
  file_size_bytes=$(stat -c%s "$file_path")
  file_size_human=$(numfmt --to=iec --suffix=B "$file_size_bytes")
  upload_date=$(date +"%Y-%m-%d %H:%M")

  if [[ "$file_id" != "null" && -n "$file_id" ]]; then
    download_url="https://pixeldrain.com/u/$file_id"
    echo "Upload successful:"
    echo "Label: $label"
    echo "Filename: $file_name"
    echo "Size: $file_size_human"
    echo "Uploaded: $upload_date"
    echo "Download Link: $download_url"
    return 0
  else
    echo "Upload failed. Pixeldrain response:"
    echo "$response"
    return 2
  fi
}

# ========== Create keys archive ==========
if [ ! -d "$KEYS_DIR" ]; then
  echo "Keys directory $KEYS_DIR not found!"
  exit 1
fi

echo "Creating keys archive..."
tar czf "$ARCHIVE_PATH" -C "$KEYS_DIR" .

# ========== Upload archive ==========
upload_file "$ARCHIVE_PATH" "LineageOS Keys Archive"
