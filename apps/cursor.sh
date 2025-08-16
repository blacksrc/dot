#!/usr/bin/env bash
set -e

# Get script directory for reliable sourcing
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"

# shellcheck source=../utils.sh
source "$SCRIPT_DIR/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run cursor.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for required dependencies
if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install curl and re-run this script."
  exit 1
fi

# Installation paths
INSTALL_DIR="/opt/cursor"
APPIMAGE_PATH="$INSTALL_DIR/cursor.AppImage"
ICON_PATH="$INSTALL_DIR/cursor.png"
DESKTOP_ENTRY_PATH="/usr/share/applications/cursor.desktop"
SYMLINK_PATH="/usr/local/bin/cursor"

get_latest_version() {
  log_info "Fetching latest Cursor version..." >&2
  local response
  response=$(curl -sL "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable") || {
    log_error "Failed to fetch version information" >&2
    return 1
  }
  echo "$response" | grep -o '"version":"[^"]*"' | cut -d'"' -f4
}

get_download_url() {
  local version=$1
  if [[ -z "$version" ]]; then
    echo "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable"
  else
    echo "https://www.cursor.com/api/download?platform=linux-x64&releaseTrack=stable&version=$version"
  fi
}

get_actual_download_url() {
  local api_url="$1"
  log_info "Resolving download URL..." >&2
  local response
  response=$(curl -sL "$api_url") || {
    log_error "Failed to fetch download URL from API" >&2
    return 1
  }
  local download_url
  download_url=$(echo "$response" | grep -o '"downloadUrl":"[^"]*"' | cut -d'"' -f4)
  if [[ -z "$download_url" ]]; then
    log_error "Could not extract download URL from API response" >&2
    log_error "API response was: $response" >&2
    return 1
  fi
  echo "$download_url"
}

# Parse command line arguments
VERSION=""
if [[ $# -eq 1 ]]; then
  VERSION="$1"
  log_info "Installing Cursor version: $VERSION"
else
  if ! VERSION=$(get_latest_version); then
    log_error "Failed to get latest version"
    exit 1
  fi
  if [[ -z "$VERSION" ]]; then
    log_error "Retrieved empty version"
    exit 1
  fi
  log_info "Installing latest Cursor version: $VERSION"
fi

# Create installation directory
log_info "Creating installation directory at $INSTALL_DIR..."
mkdir -p "$INSTALL_DIR"

# Get download URLs
API_URL=$(get_download_url "$VERSION")
log_info "API URL: $API_URL"

if ! DOWNLOAD_URL=$(get_actual_download_url "$API_URL"); then
  log_error "Failed to get download URL for Cursor"
  log_error "API URL was: $API_URL"
  exit 1
fi

log_info "Download URL: $DOWNLOAD_URL"

# Remove existing installation if present
if [[ -f "$APPIMAGE_PATH" ]]; then
  log_info "Removing existing Cursor installation..."
  rm -f "$APPIMAGE_PATH"
fi

# Download Cursor AppImage
log_info "Downloading Cursor AppImage from: $DOWNLOAD_URL"
curl -L -o "$APPIMAGE_PATH" "$DOWNLOAD_URL"

# Make it executable
chmod +x "$APPIMAGE_PATH"
log_success "Cursor AppImage downloaded and made executable"

# Download icon
log_info "Downloading Cursor icon..."
curl -L -o "$ICON_PATH" "https://mintlify.s3.us-west-1.amazonaws.com/cursor/images/logo/app-logo.svg" || \
curl -L -o "$ICON_PATH" "https://avatars.githubusercontent.com/u/168563962?s=200&v=4"
log_success "Cursor icon downloaded"

# Create desktop entry
log_info "Creating desktop entry..."
cat > "$DESKTOP_ENTRY_PATH" <<EOL
[Desktop Entry]
Version=1.0
Type=Application
Name=Cursor
Comment=AI-powered code editor
Exec=$APPIMAGE_PATH --no-sandbox %F
Icon=$ICON_PATH
Terminal=false
Categories=Development;IDE;TextEditor;
StartupWMClass=Cursor
Keywords=cursor;code;editor;ide;ai;development;programming;
StartupNotify=true
EOL

log_success "Desktop entry created"

# Create wrapper script for command line access
log_info "Creating wrapper script for command line access..."
if [[ -f "$SYMLINK_PATH" ]] || [[ -L "$SYMLINK_PATH" ]]; then
  rm -f "$SYMLINK_PATH"
fi

cat > "$SYMLINK_PATH" <<EOL
#!/usr/bin/env bash
exec "$APPIMAGE_PATH" --no-sandbox "\$@"
EOL

chmod +x "$SYMLINK_PATH"
log_success "Wrapper script created at $SYMLINK_PATH"

# Update desktop database
if command -v update-desktop-database &>/dev/null; then
  log_info "Updating desktop database..."
  update-desktop-database /usr/share/applications &>/dev/null || true
fi

# Update icon cache
if command -v gtk-update-icon-cache &>/dev/null; then
  log_info "Updating icon cache..."
  gtk-update-icon-cache -f -t /usr/share/pixmaps &>/dev/null || true
fi

log_success "🎉 Cursor (version: $VERSION) has been installed successfully!"
