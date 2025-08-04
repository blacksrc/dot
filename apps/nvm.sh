#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run nvm.sh as root (e.g. with sudo)"
  exit 1
fi

log_info "Installing latest version of NVM globally to /usr/local/nvm..."
export NVM_DIR="/usr/local/nvm"
mkdir -p "$NVM_DIR"
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

# Prepare NVM setup snippet
nvm_setup=$(cat <<'EOF'

# NVM environment setup
export NVM_DIR="/usr/local/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
EOF
)

# Update all users' .bashrc and .zshrc
log_info "Updating all users' .bashrc and .zshrc files..."

for userhome in /home/*; do
  for rc in ".bashrc" ".zshrc"; do
    rc_path="$userhome/$rc"
    if [[ -f "$rc_path" ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' "$rc_path"; then
      echo "$nvm_setup" >> "$rc_path"
      log_success "Updated $rc_path"
    fi
  done
done

# Update root's shell configs
for rc in /root/.bashrc /root/.zshrc; do
  if [[ -f "$rc" ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' "$rc"; then
    echo "$nvm_setup" >> "$rc"
    log_success "Updated $rc"
  fi
done

# Update skel for future users
for rc in /etc/skel/.bashrc /etc/skel/.zshrc; do
  if [[ -f "$rc" ]] && ! grep -q 'export NVM_DIR="/usr/local/nvm"' "$rc"; then
    echo "$nvm_setup" >> "$rc"
    log_success "Updated $rc"
  fi
done

# Load NVM for current shell
export NVM_DIR="/usr/local/nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

log_success "NVM has been installed globally in /usr/local/nvm"

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

log_info "⚠️  Restart your shell or run the following to load NVM now:"
echo "export NVM_DIR=\"/usr/local/nvm\" && [ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\""
