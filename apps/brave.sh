#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run brave.sh as root (e.g. with sudo)"
  exit 1
fi

if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install curl and re-run this script."
  exit 1
fi

log_info "Installing Brave Browser via official installer..."
curl -fsS https://dl.brave.com/install.sh | sh

log_success "🦁 Brave Browser has been installed. You can launch it using: brave-browser"
