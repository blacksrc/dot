#!/usr/bin/env bash
set -e

# shellcheck source=../utils.sh
source "$(dirname "$0")/../utils.sh"

# Check if running as root
if [[ "$EUID" -ne 0 ]]; then
  SUDO_CMD="sudo"
else
  SUDO_CMD=""
fi

# For non-root user info
CURRENT_USER=$(logname 2>/dev/null || echo "$USER")

log_info "🗝️ Adding Docker's official GPG key..."
$SUDO_CMD mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg | $SUDO_CMD gpg --dearmor -o /etc/apt/keyrings/docker.gpg

log_info "📋 Setting up Docker repository..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) stable" | $SUDO_CMD tee /etc/apt/sources.list.d/docker.list > /dev/null

log_info "🔄 Updating package info after adding Docker repo..."
$SUDO_CMD apt update -y


log_info "🐳 Installing Docker Engine, CLI, containerd, and Docker Compose plugin..."
$SUDO_CMD apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

log_info "👥 Adding user '$CURRENT_USER' to the docker group to run docker without sudo..."
$SUDO_CMD usermod -aG docker "$CURRENT_USER"


log_info "🚀 Launching new terminal with updated group (docker)... Close the terminal manually if it's not closed"
gnome-terminal --title="Docker Shell" -- bash -c 'newgrp docker; sleep 2; exec bash'

log_info "🔌 Installing Docker Buildx plugin (usually bundled but let's ensure)..."
mkdir -p ~/.docker/cli-plugins
BUILDX_VERSION=$(curl -s https://api.github.com/repos/docker/buildx/releases/latest | grep tag_name | cut -d '"' -f 4)
BUILDX_BIN="$HOME/.docker/cli-plugins/docker-buildx"
curl -L "https://github.com/docker/buildx/releases/download/$BUILDX_VERSION/buildx-$BUILDX_VERSION.linux-amd64" -o "$BUILDX_BIN"
chmod +x "$BUILDX_BIN"

log_success "✅ Docker, Docker Compose, and plugins installed successfully!"