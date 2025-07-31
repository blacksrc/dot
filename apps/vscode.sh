#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run vscode.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Adding Microsoft GPG key and repository for VS Code..."
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > /etc/apt/trusted.gpg.d/microsoft.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/trusted.gpg.d/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list
log_success "Repository for VS Code has been added"

log_info "Updating package list..."
apt update
log_success "Package list updated"

log_info "Installing Visual Studio Code..."
apt install -y code
log_success "Visual Studio Code has been installed"
