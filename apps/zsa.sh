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

log_success "Your system is now configured for flashing ZSA keyboards using Oryx, Keymapp, or Wally."
log_info "You may need to log out and back in—or run 'newgrp plugdev' in your session—to apply group changes."
