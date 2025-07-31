#!/usr/bin/env bash
set -e

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

target_user=$(logname)

sudo bash "$(dirname "$0")/intro.sh"

log_info "Running init.sh (System update & dependencies)..."
sudo bash "$(dirname "$0")/init.sh"

# log_info "Running bun.sh (Install bun-js)..."
# sudo bash "$(dirname "$0")/apps/bun.sh"

# log_info "Running zen-browser.sh (Zen installation)..."
# sudo bash "$(dirname "$0")/apps/zen-browser.sh"

# log_info "Running vscode.sh (VSCode installation)..."
# sudo bash "$(dirname "$0")/apps/vscode.sh"

# log_info "Running nvm.sh (NVM installation)..."
# sudo bash "$(dirname "$0")/apps/nvm.sh"

# log_info "Running steam.sh (Steam installation)..."
# sudo bash "$(dirname "$0")/apps/steam.sh"

# log_info "Running telegram.sh (Telegram installation)..."
# sudo bash "$(dirname "$0")/apps/telegram.sh"

# log_info "Running obsidian.sh (Obsidian installation)..."
# sudo bash "$(dirname "$0")/apps/obsidian.sh"

# log_info "Running omz.sh (Oh My Zsh installation)..."
# sudo -u "$target_user" bash "$(dirname "$0")/apps/omz.sh"

# log_info "Running git-setup.sh (Git setup)..."
# sudo -u "$target_user" bash "$(dirname "$0")/apps/git-setup.sh"

# log_info "Running docker.sh (Docker installation)..."
# sudo -u "$target_user" bash "$(dirname "$0")/apps/docker.sh"

log_success "🎉 All tasks completed successfully!"

# log_info "Cleaning up..."
# sudo bash "$(dirname "$0")/uninstall.sh"