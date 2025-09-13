#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -eq 0 ]]; then
  log_error "Do NOT run cargo-install.sh as root. Install Cargo for your own user."
  exit 1
fi

# Check for required tools
if ! command -v curl &>/dev/null; then
  log_error "curl is not installed. Please install curl and re-run this script."
  exit 1
fi

log_info "Installing Rust and Cargo for user '$USER'..."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

log_info "Adding Cargo to your PATH..."
CARGO_ENV_SNIPPET=$(cat <<'EOF'

# Rust / Cargo environment setup
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"
EOF
)

if ! grep -q 'CARGO_HOME' "$HOME/.bashrc"; then
  echo "$CARGO_ENV_SNIPPET" >> "$HOME/.bashrc"
  log_success "Updated $HOME/.bashrc"
fi

# Load Cargo for current shell session
export CARGO_HOME="$HOME/.cargo"
export PATH="$CARGO_HOME/bin:$PATH"

log_success "Rust & Cargo installed successfully for $USER"
log_info "Run 'source ~/.bashrc' or restart your shell to start using Cargo immediately."