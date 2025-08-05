#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run vlc.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing VLC from official Ubuntu 24.04 repositories..."
apt update -qq
apt install -y vlc

log_success "🎬 VLC has been installed. You can launch it using: vlc"
