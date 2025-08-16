#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run jq.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing jq..."
sudo apt install jq -y
log_success "jq has been installed"
