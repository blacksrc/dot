#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run spotify.sh as root (e.g. with sudo)"
  exit 1
fi

# Ensure required tools are available
for cmd in curl gpg tee apt; do
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Please install $cmd and re-run this script."
    exit 1
  fi
done

# Add the latest Spotify GPG key (updated key path)
log_info "Importing updated Spotify GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.spotify.com/debian/pubkey_C85668DF69375001.gpg \
  | gpg --dearmor --yes -o /etc/apt/keyrings/spotify.gpg

# Configure the repository with the signed-by directive
log_info "Adding Spotify APT repository..."
echo "deb [signed-by=/etc/apt/keyrings/spotify.gpg] http://repository.spotify.com stable non-free" \
  > /etc/apt/sources.list.d/spotify.list

# Update and install
log_info "Updating package list..."
apt update -qq

log_info "Installing Spotify client..."
apt install -y spotify-client

log_success "🎵 Spotify has been installed. You can launch it with: spotify"
