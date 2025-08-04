#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run gimp.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Adding the official GIMP PPA to ensure the latest version..."
add-apt-repository -y ppa:ubuntuhandbook1/gimp

log_info "Updating package lists..."
apt update -qq

log_info "Installing GIMP..."
apt install -y gimp

log_success "🖌️ GIMP has been installed. You can launch it using: gimp"
