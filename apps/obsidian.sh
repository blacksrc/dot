#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run obsidian.sh as root (e.g. with sudo)"
  exit 1
fi

OBSIDIAN_URL="https://api.github.com/repos/obsidianmd/obsidian-releases/releases/latest"
TEMP_DEB="/tmp/obsidian-latest.deb"
trap 'rm -f "$TEMP_DEB"' EXIT

log_info "📦 Fetching latest Obsidian release info..."
DOWNLOAD_URL=$(curl -s "$OBSIDIAN_URL" | grep "browser_download_url" | grep "amd64.deb" | cut -d '"' -f 4)

if [[ -z "$DOWNLOAD_URL" ]]; then
  log_error "Could not find Obsidian .deb download URL"
  exit 1
fi

log_info "⬇️ Downloading Obsidian from $DOWNLOAD_URL..."
curl -L "$DOWNLOAD_URL" -o "$TEMP_DEB"

log_info "⚙️ Installing Obsidian..."
dpkg -i "$TEMP_DEB" || apt install -f -y

log_info "🧹 Cleaning up temporary files..."
rm -f "$TEMP_DEB"

log_success "📝 Obsidian has been installed. You can launch it by typing: obsidian"
