#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run steam.sh as root (e.g. with sudo)"
  exit 1
fi

STEAM_DEB_URL="https://cdn.cloudflare.steamstatic.com/client/installer/steam.deb"
STEAM_DEB_FILE="/tmp/steam.deb"

log_info "Downloading Steam package from $STEAM_DEB_URL..."
curl -fsSL "$STEAM_DEB_URL" -o "$STEAM_DEB_FILE"

log_info "Installing Steam (using .deb package)..."
dpkg -i "$STEAM_DEB_FILE" || true  # Allow errors for missing dependencies

log_info "Fixing missing dependencies..."
apt-get update -qq
apt-get install -f -y

log_info "Cleaning up temporary files..."
rm -f "$STEAM_DEB_FILE"

log_success "🎮 Steam has been installed. You can launch it using: steam"