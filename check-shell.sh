#!/usr/bin/env bash
set -euo pipefail

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

# Check for required tools
ensure_installed() {
  local tool=$1
  if ! command -v "$tool" >/dev/null 2>&1; then
    log_info "🔧 Installing $tool..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
      if command -v apt >/dev/null 2>&1; then
        sudo apt update && sudo apt install -y "$tool"
      elif command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm "$tool"
      else
        log_error "Unsupported Linux package manager. Please install $tool manually."
        exit 1
      fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
      if command -v brew >/dev/null 2>&1; then
        brew install "$tool"
      else
        log_error "Homebrew not found. Please install $tool manually."
        exit 1
      fi
    else
      log_error "Unsupported OS. Please install $tool manually."
      exit 1
    fi
  fi
}

ensure_installed shellcheck
ensure_installed shfmt

log_info "🔍 Running shellcheck..."
find . -type f -name "*.sh" -execdir shellcheck -x {} +

log_info "🎨 Checking formatting with shfmt..."
find . -type f -name "*.sh" -exec shfmt -d {} +

log_success "✅ All checks complete!"
