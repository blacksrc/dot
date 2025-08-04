#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run chrome.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for required tools
for cmd in curl dpkg; do
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Please install $cmd and re-run this script."
    exit 1
  fi
done

CHROME_DEB_URL="https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
CHROME_DEB_FILE="/tmp/google-chrome.deb"

log_info "Downloading Google Chrome from $CHROME_DEB_URL..."
curl -fsSL "$CHROME_DEB_URL" -o "$CHROME_DEB_FILE"

log_info "Installing Google Chrome (using .deb package)..."
dpkg -i "$CHROME_DEB_FILE" || true  # Allow errors for missing dependencies

log_info "Fixing missing dependencies..."
apt update -qq
apt install -f -y

log_info "Cleaning up temporary files..."
rm -f "$CHROME_DEB_FILE"

log_success "🌐 Google Chrome has been installed. You can launch it using: google-chrome"
