#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run htop.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing Htop..."
sudo apt install htop -y
log_success "Htop has been installed"
