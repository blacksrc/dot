#!/usr/bin/env bash
set -e

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

GUM_VERSION="0.16.2"
TARFILE="gum_${GUM_VERSION}_Linux_x86_64.tar.gz"
URL="https://github.com/charmbracelet/gum/releases/download/v${GUM_VERSION}/${TARFILE}"

log_info "📦 Installing gum v$GUM_VERSION"

# Download
log_info "⬇️ Downloading $TARFILE ..."
curl -LO "$URL"

# Extract
log_info "📦 Extracting gum..."
tar -xzf "$TARFILE"

# Move binary from extracted directory
EXTRACTED_DIR="gum_${GUM_VERSION}_Linux_x86_64"
sudo mv "$EXTRACTED_DIR/gum" /usr/local/bin/
sudo chmod +x /usr/local/bin/gum

# Clean up
rm -rf "$TARFILE" "$EXTRACTED_DIR"

# Verify
if command -v gum &>/dev/null; then
  log_success "✅ gum installed successfully!"
  gum --version
else
  log_error "❌ gum installation failed."
  exit 1
fi