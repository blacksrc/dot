#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run lazydocker.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for curl
if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install curl and re-run this script."
  exit 1
fi

ARCH=$(uname -m)
case "$ARCH" in
  x86_64) ARCH="x86_64" ;;
  aarch64) ARCH="arm64" ;;
  *)
    log_error "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

log_info "Fetching latest release info from GitHub..."
LATEST_URL=$(curl -fsSL https://api.github.com/repos/jesseduffield/lazydocker/releases/latest \
  | grep "browser_download_url" \
  | grep "Linux_${ARCH}.tar.gz" \
  | cut -d '"' -f 4)

if [[ -z "$LATEST_URL" ]]; then
  log_error "Failed to find download URL for architecture: $ARCH"
  exit 1
fi

TMP_DIR="/tmp/lazydocker_install"
mkdir -p "$TMP_DIR"

log_info "Downloading lazydocker from: $LATEST_URL"
curl -fsSL "$LATEST_URL" -o "$TMP_DIR/lazydocker.tar.gz"

log_info "Extracting lazydocker..."
tar -xzf "$TMP_DIR/lazydocker.tar.gz" -C "$TMP_DIR"

log_info "Installing to /usr/local/bin..."
install -m 755 "$TMP_DIR/lazydocker" /usr/local/bin/lazydocker

log_info "Cleaning up..."
rm -rf "$TMP_DIR"

log_success "🐳 lazydocker has been installed. You can run it with: lazydocker"
