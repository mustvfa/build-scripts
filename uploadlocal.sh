#!/bin/bash

# ========== Dependency Checks ==========
if ! command -v curl &> /dev/null; then
    echo "Error: curl is required but not installed"
    exit 1
fi

if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed"
    exit 1
fi

# ========== Environment Setup ==========
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/.env"

if [[ ! -f "$ENV_FILE" ]]; then
    echo "Error: .env file not found at $ENV_FILE"
    exit 1
fi

source "$ENV_FILE"

if [[ -z "$PIXELDRAIN_API_KEY" ]]; then
    echo "Error: PIXELDRAIN_API_KEY is not set in .env"
    exit 1
fi

# ========== Configuration ==========
DEVICE_PATH="out/target/product/a21s"

# ========== File Upload Function ==========
upload_file() {
    local file_path="$1"
    local label="$2"

    if [[ ! -f "$file_path" ]]; then
        echo "Error: $label file not found at $file_path"
        return 1
    fi

    echo "Uploading $label to Pixeldrain..."
    
    # Execute upload and capture full response
    local response
    response=$(curl -s -w "\n%{http_code}" -u ":$PIXELDRAIN_API_KEY" -X POST -F "file=@$file_path" https://pixeldrain.com/api/file 2>&1)
    
    # Separate HTTP status code from response body
    local http_code=${response##*$'\n'}
    local body=${response%$http_code}

    # Handle curl failures
    if [[ $? -ne 0 ]]; then
        echo "CURL FAILURE:"
        echo "$body"
        return 2
    fi

    # Check HTTP status code
    if [[ ! "$http_code" =~ ^2[0-9]{2}$ ]]; then
        echo "HTTP ERROR ($http_code):"
        echo "$body"
        return 3
    fi

    # Parse JSON response
    local file_id=$(echo "$body" | jq -r '.id')
    if [[ "$file_id" == "null" || -z "$file_id" ]]; then
        echo "API ERROR:"
        echo "$body"
        return 4
    fi

    # Generate download URL and file info
    local download_url="https://pixeldrain.com/u/$file_id"
    local file_name=$(basename "$file_path")
    local file_size_bytes=$(stat -c%s "$file_path")
    local file_size_human=$(numfmt --to=iec --suffix=B "$file_size_bytes")
    local upload_date=$(date +"%Y-%m-%d %H:%M")

    echo "UPLOAD SUCCESS:"
    echo "Label:    $label"
    echo "File:     $file_name"
    echo "Size:     $file_size_human"
    echo "Date:     $upload_date"
    echo "URL:      $download_url"
    return 0
}

# ========== Main Upload Process ==========
# Find latest ROM zip (excluding recovery/dtbo/vbmeta files)
latest_zip=$(find "$DEVICE_PATH" -maxdepth 1 -type f \( -iname "*.zip" ! -iname "*recovery*" ! -iname "*dtbo*" ! -iname "*vbmeta*" \) -printf "%T@ %p\n" | sort -nr | head -n1 | cut -d' ' -f2-)

if [[ -n "$latest_zip" ]]; then
    upload_file "$latest_zip" "A21s ROM" || true
else
    echo "Warning: No ROM zip found in $DEVICE_PATH"
fi

# Upload recovery image
recovery_img="$DEVICE_PATH/recovery.img"
if [[ -f "$recovery_img" ]]; then
    upload_file "$recovery_img" "A21s Recovery" || true
else
    echo "Warning: No recovery.img found in $DEVICE_PATH"
fi
