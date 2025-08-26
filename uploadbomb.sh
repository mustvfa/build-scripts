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

if [[ -f "$ENV_FILE" ]]; then
    source "$ENV_FILE"
fi

# Optional API key for GoFile account
API_KEY="${GOFILE_API_KEY:-}"

# ========== Configuration ==========
DEVICE_PATH="out/target/product/a21s"

# ========== Functions ==========

# Query GoFile for best server
get_server() {
    curl -s https://api.gofile.io/servers | jq -r '.data.servers[0].name'
}

# Upload file
upload_file() {
    local file_path="$1"
    local label="$2"

    if [[ ! -f "$file_path" ]]; then
        echo "Error: $label file not found at $file_path"
        return 1
    fi

    echo "Fetching the best server for upload..."
    local server
    server=$(get_server)

    if [[ -z "$server" ]]; then
        echo "ERROR: Failed to retrieve GoFile server"
        return 1
    fi

    echo "Uploading $label to server: $server..."

    local response
    if [[ -n "$API_KEY" ]]; then
        response=$(curl -s -F "file=@$file_path" -F "token=$API_KEY" "https://${server}.gofile.io/uploadFile")
    else
        response=$(curl -s -F "file=@$file_path" "https://${server}.gofile.io/uploadFile")
    fi

    local link
    link=$(echo "$response" | jq -r '.data.downloadPage')

    if [[ "$link" == "null" || -z "$link" ]]; then
        echo "Upload failed:"
        echo "$response"
        return 1
    fi

    local file_name
    file_name=$(basename "$file_path")
    local file_size_bytes
    file_size_bytes=$(stat -c%s "$file_path")
    local file_size_human
    file_size_human=$(numfmt --to=iec --suffix=B "$file_size_bytes")
    local upload_date
    upload_date=$(date +"%Y-%m-%d %H:%M")

    echo "UPLOAD SUCCESS:"
    echo "Label:    $label"
    echo "File:     $file_name"
    echo "Size:     $file_size_human"
    echo "Date:     $upload_date"
    echo "URL:      $link"
    echo
}

# ========== Main Upload Process ==========

# Upload latest ROM zip
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
