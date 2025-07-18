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

DEVICE_PATH="out/target/product/a21s"

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

# ========== ROM Upload ==========
latest_zip=$(find "$DEVICE_PATH" -maxdepth 1 -type f -iname "*.zip" ! -iname "*recovery*" ! -iname "*dtbo*" ! -iname "*vbmeta*" -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d' ' -f2-)
if [[ -n "$latest_zip" && -f "$latest_zip" ]]; then
  upload_file "$latest_zip" "A21s ROM"
else
  echo "No ROM .zip found in $DEVICE_PATH"
fi

# ========== Recovery Upload ==========
recovery_img="$DEVICE_PATH/recovery.img"
if [[ -f "$recovery_img" ]]; then
  upload_file "$recovery_img" "A21s Recovery"
else
  echo "No recovery.img found in $DEVICE_PATH"
fi

# ========== Kernel Upload ==========
kernel_file="$DEVICE_PATH/kernel"
if [[ -f "$kernel_file" ]]; then
  upload_file "$kernel_file" "A21s Kernel"
else
  echo "No kernel file found at $kernel_file"
fi
