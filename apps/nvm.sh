#!/usr/bin/env bash
set -e

# Load utils
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run nvm.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing dependencies for NVM..."
apt install -y curl ca-certificates
log_success "Dependencies installed"

log_info "Installing latest version of NVM globally..."
export NVM_DIR="/usr/local/nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Prepare NVM setup snippet to add to user bashrc files
nvm_setup=$(cat <<'EOF'

# NVM environment setup
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
)

log_info "Updating all existing users' .bashrc files..."

for userhome in /home/*; do
  bashrc="$userhome/.bashrc"
  if [[ -f "$bashrc" ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' "$bashrc"; then
    echo "$nvm_setup" >> "$bashrc"
    log_success "Updated $bashrc"
  fi
done

# Also update root's bashrc
if [[ -f /root/.bashrc ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' /root/.bashrc; then
  echo "$nvm_setup" >> /root/.bashrc
  log_success "Updated /root/.bashrc"
fi

# Update /etc/skel/.bashrc for future users
if [[ -f /etc/skel/.bashrc ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' /etc/skel/.bashrc; then
  echo "$nvm_setup" >> /etc/skel/.bashrc
  log_success "Updated /etc/skel/.bashrc"
fi

# Load nvm for current shell
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

log_success "NVM (latest) has been installed globally"

log_info "Installing latest LTS version of Node.js..."
nvm install --lts
nvm alias default 'lts/*'
log_success "Latest LTS version of Node.js installed and set as default"

log_info "Verifying npm installation..."
if ! command -v npm >/dev/null 2>&1; then
  log_warning "npm not found, attempting reinstallation..."
  nvm install-latest-npm
  log_success "npm has been installed"
else
  log_success "npm is already installed"
fi
