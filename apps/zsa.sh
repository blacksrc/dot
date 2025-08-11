#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -ne 0 ]]; then
  log_error "Please run zsa-udev.sh as root (e.g. with sudo)"
  exit 1
fi

# Check for required tools
for cmd in apt curl tee; do
  if ! command -v "$cmd" &>/dev/null; then
    log_error "$cmd is not installed. Please install $cmd and re-run this script."
    exit 1
  fi
done

log_info "Installing dependencies for flashing tools..."
apt update -qq
apt install -y libusb-1.0-0 libwebkit2gtk-4.1-0 libgtk-3-0

log_info "Creating udev rules for ZSA keyboards..."
cat > /etc/udev/rules.d/50-zsa.rules << 'EOF'
# Rules for Oryx web flashing and live training
KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

# Legacy live training rules (USB WebUSB)
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="1307", GROUP="plugdev"
SUBSYSTEM=="usb", ATTR{idVendor}=="feed", ATTR{idProduct}=="6060", GROUP="plugdev"

# Wally flashing rules for the Ergodox EZ
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", ENV{ID_MM_DEVICE_IGNORE}="1"
ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789A]?", ENV{MTP_NO_PROBE}="1"
SUBSYSTEMS=="usb", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789ABCD]?", MODE:="0666"
KERNEL=="ttyACM*", ATTRS{idVendor}=="16c0", ATTRS{idProduct}=="04[789B]?", MODE:="0666"

# Wally flashing rules for the Moonlander and Planck EZ
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"

# Keymapp flashing rule for the Voyager
SUBSYSTEMS=="usb", ATTRS{idVendor}=="3297", MODE:="0666", SYMLINK+="ignition_dfu"
EOF

log_success "Udev rules created at /etc/udev/rules.d/50-zsa.rules"

log_info "Adding users to 'plugdev' group to allow hardware access..."
groupadd -f plugdev

for userHome in /home/*; do
  user=$(basename "$userHome")
  if id "$user" &>/dev/null; then
    usermod -aG plugdev "$user"
    log_success "Added user '$user' to group plugdev"
  fi
done

usermod -aG plugdev root
log_success "Added 'root' to plugdev group"

log_info "Reloading udev rules..."
udevadm control --reload-rules
udevadm trigger

# Download and install the latest Keymapp
log_info "Downloading and installing Keymapp (latest)..."
TMP_TAR="/tmp/keymapp-latest.tar.gz"
wget -qO "$TMP_TAR" "https://oryx.nyc3.cdn.digitaloceanspaces.com/keymapp/keymapp-latest.tar.gz" || {
  log_error "Failed to download Keymapp archive."
  exit 1
}

mkdir -p /tmp/keymapp_extracted
tar -xzf "$TMP_TAR" -C /tmp/keymapp_extracted
chmod +x /tmp/keymapp_extracted/keymapp
mv /tmp/keymapp_extracted/keymapp /usr/local/bin/keymapp
rm -rf /tmp/keymapp_extracted "$TMP_TAR"
log_success "Installed Keymapp to /usr/local/bin/keymapp"

log_info "Creating Keymapp desktop entry..."
cat > /usr/share/applications/keymapp.desktop << 'EOF'
[Desktop Entry]
Name=Keymapp
Comment=ZSA Keyboard Keymapping Tool
Exec=/usr/local/bin/keymapp
Icon=keymapp
Terminal=false
Type=Application
Categories=Utility;
EOF

# Install icon if available in tarball
if [[ -f /tmp/keymapp_extracted/keymapp.png ]]; then
  cp /tmp/keymapp_extracted/keymapp.png /usr/share/icons/hicolor/256x256/apps/keymapp.png
  log_success "Installed Keymapp icon."
else
  log_warning "No icon found in package. You can add one later at /usr/share/icons/hicolor/256x256/apps/keymapp.png"
fi

# Refresh desktop database
if command -v update-desktop-database &>/dev/null; then
  update-desktop-database /usr/share/applications
fi

log_success "Your system is now configured for flashing ZSA keyboards using Oryx, Keymapp, or Wally."
log_info "Run 'keymapp' to launch the application."
log_info "To activate device permissions without reboot, run:"
echo "  newgrp plugdev"
