#!/usr/bin/env bash
set -e

# Load utils
source "$(dirname "$0")/utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run init.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Updating OS..."
apt update && apt full-upgrade -y
log_success "OS has been updated"

log_info "Installing initial dependencies..."
apt install -y wget curl
snap install bun-js
log_success "Initial dependencies have been installed"


log_info "Creating application directory"
sudo mkdir -p /usr/local/share/applications
log_success "Application directory has been created"
