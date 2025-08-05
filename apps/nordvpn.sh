#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run nordvpn.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for wget
if ! command -v wget &>/dev/null; then
  log_error "wget is not installed. Please install wget and re-run this script."
  exit 1
fi

INSTALLER_URL="https://downloads.nordcdn.com/apps/linux/install.sh"

log_info "Downloading and running the NordVPN installer from: $INSTALLER_URL"
sh <(wget -qO - "$INSTALLER_URL") -p nordvpn-gui

log_info "Ensuring nordvpn group exists..."
groupadd -f nordvpn

log_info "Adding users to nordvpn group..."

# Add all users in /home to nordvpn group
for dir in /home/*; do
  user=$(basename "$dir")
  if id "$user" &>/dev/null; then
    usermod -aG nordvpn "$user"
    log_success "Added user '$user' to nordvpn group"
  fi
done

# Also add root
usermod -aG nordvpn root
log_success "Added user 'root' to nordvpn group"

log_success "🛡️ NordVPN (GUI) has been installed."

log_warning "Please reboot your system or log out and back in to apply group changes before using NordVPN."
log_info "You can then login using: nordvpn login"
