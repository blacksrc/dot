#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run terminator.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing Terminator..."
sudo apt install terminator -y
log_success "Terminator has been installed successfully"
