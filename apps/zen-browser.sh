#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

INSTALL_DIR="/opt/zen"
SYMLINK="/usr/bin/zen"
DESKTOP_DIR="/usr/share/applications"
DESKTOP_FILE="$DESKTOP_DIR/zen.desktop"
TMP_ARCHIVE="/tmp/zen-browser.tar.xz"

if [[ "$EUID" -ne 0 ]]; then
  log_warning "Please run zen-browser.sh as root (e.g. sudo)"
  exit 1
fi

trap 'rm -f "$TMP_ARCHIVE"' EXIT

log_info "Fetching latest Zen Browser version..."
LATEST_VERSION=$(curl -fsSL https://api.github.com/repos/zen-browser/desktop/releases/latest | jq -r '.tag_name')
if [[ -z "$LATEST_VERSION" || "$LATEST_VERSION" == "null" ]]; then
  log_error "Could not determine latest Zen Browser version."
  exit 1
fi
LATEST_URL="https://github.com/zen-browser/desktop/releases/download/${LATEST_VERSION}/zen.linux-x86_64.tar.xz"

log_info "Downloading Zen Browser ${LATEST_VERSION}..."
curl -fsSL -o "$TMP_ARCHIVE" "$LATEST_URL"
log_success "Downloaded latest release."

log_info "Installing Zen Browser to $INSTALL_DIR..."
rm -rf "$INSTALL_DIR"
mkdir -p "$INSTALL_DIR"
tar -xJf "$TMP_ARCHIVE" -C "$INSTALL_DIR"
log_success "Extracted to $INSTALL_DIR"

log_info "Creating symlink at $SYMLINK..."
ZEN_EXECUTABLE=$(find "$INSTALL_DIR" -type f -executable -name 'zen' | head -n 1)
if [[ -z "$ZEN_EXECUTABLE" ]]; then
  log_info "Could not find the Zen Browser executable inside $INSTALL_DIR"
  exit 1
fi
rm -f "$SYMLINK"
ln -s "$ZEN_EXECUTABLE" "$SYMLINK"
chmod +x "$ZEN_EXECUTABLE"
log_success "Symlink created"

log_info "Creating desktop entry..."
mkdir -p "$DESKTOP_DIR"
ICON_PATH="$INSTALL_DIR/zen/browser/chrome/icons/default/default128.png"

if [[ -f "$ICON_PATH" ]]; then
  cp "$ICON_PATH" /usr/share/pixmaps/zen.png
  ICON_NAME="zen"
else
  ICON_NAME="web-browser"
fi

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Version=1.0
Name=Zen Browser
Comment=Browse the web privately and ad-free
Exec=zen %U
Terminal=false
Type=Application
Icon=$ICON_NAME
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
StartupWMClass=zen
EOF
chmod +x "$DESKTOP_FILE"
log_success "Desktop entry created"

log_info "Cleaning up temporary files..."
rm -f "$TMP_ARCHIVE"
log_success "🎉 Zen Browser has been installed successfully!"
