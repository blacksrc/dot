#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run yarn.sh as root (e.g. with sudo)"
  exit 1
fi

# Load NVM if installed
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Check for Node.js
if ! command -v node &>/dev/null; then
  log_error "Node.js is not installed. Please install Node.js (>=16.10) and re-run this script."
  exit 1
fi

# Check for corepack
if ! command -v corepack &>/dev/null; then
  log_error "corepack is not available. Please upgrade Node.js to a version that includes it (>=16.10)."
  exit 1
fi

log_info "Enabling and preparing latest Yarn via corepack..."
corepack enable
corepack prepare yarn@stable --activate

log_info "Verifying Yarn installation..."
if ! command -v yarn &>/dev/null; then
  log_error "Yarn installation failed."
  exit 1
fi

YARN_VERSION=$(yarn --version)
log_success "📦 Yarn $YARN_VERSION has been installed. You can use it with: yarn"
