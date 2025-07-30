#!/usr/bin/env bash
set -e

# Load utils
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run bun.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing bun-js..."
snap install bun-js
log_success "Bun has been installed"
