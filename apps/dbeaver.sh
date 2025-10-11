#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run dbeaver.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for required tools
for cmd in curl dpkg; do
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Please install $cmd and re-run this script."
    exit 1
  fi
done

DBEAVER_DEB_URL="https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
DBEAVER_DEB_FILE="/tmp/dbeaver.deb"

log_info "Downloading DBeaver from $DBEAVER_DEB_URL..."
curl -fsSL "$DBEAVER_DEB_URL" -o "$DBEAVER_DEB_FILE"

log_info "Installing DBeaver (using .deb package)..."
dpkg -i "$DBEAVER_DEB_FILE" || true  # Allow errors for missing dependencies

log_info "Fixing missing dependencies..."
apt update -qq
apt install -f -y

log_info "Cleaning up temporary files..."
rm -f "$DBEAVER_DEB_FILE"

log_success "💻 DBeaver has been installed. You can launch it using: dbeaver-ce"
