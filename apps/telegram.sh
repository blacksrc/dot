#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run telegram.sh as root (e.g. with sudo)"
  exit 1
fi

TELEGRAM_URL="https://telegram.org/dl/desktop/linux"
TELEGRAM_TAR="/tmp/telegram.tar.xz"
INSTALL_DIR="/opt/Telegram"
DESKTOP_ENTRY="/usr/share/applications/telegram-desktop.desktop"
SYMLINK_PATH="/usr/bin/telegram-desktop"

log_info "📦 Downloading Telegram Desktop..."
curl -fsSL "$TELEGRAM_URL" -o "$TELEGRAM_TAR"

log_info "📂 Extracting Telegram to /opt..."
rm -rf "$INSTALL_DIR"
tar -xf "$TELEGRAM_TAR" -C /opt

if [[ ! -f "$INSTALL_DIR/Telegram" ]]; then
  log_error "Extraction failed or Telegram binary not found in $INSTALL_DIR"
  exit 1
fi

log_info "🔗 Creating symlink at $SYMLINK_PATH..."
ln -sf "$INSTALL_DIR/Telegram" "$SYMLINK_PATH"

ICON_PATH="$INSTALL_DIR/telegram.svg"
if [[ ! -f "$ICON_PATH" ]]; then
  ICON_PATH="$INSTALL_DIR/telegram.png"
fi

log_info "🖥️ Creating desktop entry at $DESKTOP_ENTRY..."
cat > "$DESKTOP_ENTRY" <<EOF
[Desktop Entry]
Name=Telegram Desktop
Comment=Official Telegram Desktop client
Exec=$SYMLINK_PATH
Icon=$ICON_PATH
Terminal=false
Type=Application
Categories=Network;InstantMessaging;
StartupWMClass=TelegramDesktop
EOF

log_info "🧹 Cleaning up temporary files..."
rm -f "$TELEGRAM_TAR"

log_success "📨 Telegram Desktop has been installed. You can launch it by typing: telegram-desktop"
