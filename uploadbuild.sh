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

if ! command -v numfmt &> /dev/null; then
    echo "Error: numfmt is required (usually part of coreutils)"
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

# Upload file (with progress bar + info)
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
    echo

    local response
    if [[ -n "$API_KEY" ]]; then
        response=$(curl -# -F "file=@$file_path" -F "token=$API_KEY" "https://${server}.gofile.io/uploadFile" 2>&1)
    else
        response=$(curl -# -F "file=@$file_path" "https://${server}.gofile.io/uploadFile" 2>&1)
    fi
    echo

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

    echo "========== UPLOAD SUCCESS =========="
    echo "Label:    $label"
    echo "File:     $file_name"
    echo "Size:     $file_size_human"
    echo "Date:     $upload_date"
    echo "Link:     $link"
    echo "===================================="
    echo
}

# ========== Main Uploads ==========
upload_file "$DEVICE_PATH/recovery.img" "Recovery"
upload_file "$DEVICE_PATH/boot.img" "Boot"
