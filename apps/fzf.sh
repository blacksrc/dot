#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run fzf.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for git
if ! command -v git &>/dev/null; then
  log_error "git is not installed. Please install git and re-run this script."
  exit 1
fi

FZF_DIR="/opt/fzf"

if [[ -d "$FZF_DIR" ]]; then
  log_info "Removing existing fzf installation at $FZF_DIR..."
  rm -rf "$FZF_DIR"
fi

log_info "Cloning the latest fzf from GitHub..."
git clone --depth 1 https://github.com/junegunn/fzf.git "$FZF_DIR"

log_info "Installing fzf system-wide..."
"$FZF_DIR/install" --bin

log_info "Linking fzf binary to /usr/local/bin..."
ln -sf "$FZF_DIR/bin/fzf" /usr/local/bin/fzf

log_success "🔍 fzf has been installed. You can use it by running: fzf"
