#!/usr/bin/env bash
set -e

# Import utils
source "$(dirname "$0")/utils.sh"

# Must run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run as root (e.g. sudo ./uninstall.sh)"
  exit 1
fi

read -p "Do you want to run the uninstall script? (y/n): " answer

if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
  # List of applications to uninstall
  APPS=(
    "firefox"
    # Add more app names here
  )

  log_info "Uninstalling applications: ${APPS[*]}"

  for app in "${APPS[@]}"; do
    # Try APT uninstall
    if dpkg -l | grep -qw "$app"; then
      log_info "Removing $app (APT)..."
      apt remove -y "$app"
      apt purge -y "$app"
      log_success "$app has been removed via APT"
    # Try Snap uninstall
    elif snap list | grep -qw "$app"; then
      log_info "Removing $app (Snap)..."
      snap remove "$app"
      log_success "$app has been removed via Snap"
    else
      log_warning "$app is not installed via APT or Snap"
    fi
  done

  log_info "Running autoremove and autoclean..."
  apt autoremove -y
  apt autoclean -y
  log_success "Cleanup complete"

  log_success "🎉 All selected applications have been uninstalled"
else
  log_info "Skipping uninstall script."
fi
