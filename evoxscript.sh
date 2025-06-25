#!/bin/bash

# ====== BUILD SECTION ======

# Remove local manifests
rm -rf .repo/local_manifests

# Initialize repo for Evolution-X
repo init -u https://github.com/Evolution-X/manifest -b bka --git-lfs

# Sync
/opt/crave/resync.sh

# Clone device/vendor/kernel repositories
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s-common  vendor/samsung/a21s-common -b lineage-22.2
git clone https://github.com/TheMuppets/proprietary_vendor_samsung_a21s vendor/samsung/a21s -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s-common device/samsung/a21s-common -b lineage-22.2
git clone https://github.com/mustafa-dgaf/android_device_samsung_a21s device/samsung/a21s -b lineage-22.2
git clone https://github.com/samsungexynos850/upstream_exynos850 kernel/samsung/exynos850 -b master

# Build
source build/envsetup.sh 
lunch lineage_a21s-bp2a-userdebug && m evolution

# ====== UPLOAD SECTION ======

# Load local .env variables safely
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

# Upload latest ROM zip
latest_zip=$(find "$DEVICE_PATH" -maxdepth 1 -type f -iname "*.zip" ! -iname "*recovery*" ! -iname "*dtbo*" ! -iname "*vbmeta*" -printf "%T@ %p\n" | sort -n | tail -n1 | cut -d' ' -f2-)
if [[ -n "$latest_zip" && -f "$latest_zip" ]]; then
  upload_file "$latest_zip" "A21s ROM"
else
  echo "No ROM .zip found in $DEVICE_PATH"
fi

# Upload recovery.img
recovery_img="$DEVICE_PATH/recovery.img"
if [[ -f "$recovery_img" ]]; then
  upload_file "$recovery_img" "A21s Recovery"
else
  echo "No recovery.img found in $DEVICE_PATH"
fi
