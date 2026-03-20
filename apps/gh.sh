#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Only run as root
if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run gh.sh as root (e.g. with sudo)"
  exit 1
fi

# Ensure required tools are available
for cmd in curl gpg tee apt; do
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Please install $cmd and re-run this script."
    exit 1
  fi
done

log_info "Importing GitHub CLI GPG key..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
  | gpg --dearmor --yes -o /etc/apt/keyrings/github-cli.gpg

log_info "Adding GitHub CLI APT repository..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/github-cli.gpg] https://cli.github.com/packages stable main" \
  > /etc/apt/sources.list.d/github-cli.list

log_info "Updating package list..."
apt update -qq

log_info "Installing GitHub CLI..."
apt install -y gh

log_success "GitHub CLI has been installed. You can run it with: gh"
