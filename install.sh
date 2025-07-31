#!/usr/bin/env bash
set -e
# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"
target_user=$(logname)

# Run initialize first (always)
log_info "Running init.sh (System update & dependencies)..."
sudo bash "$(dirname "$0")/init.sh"

# Run gum installation
log_info "Running gum.sh (Install gum)..."
sudo bash "$(dirname "$0")/gum.sh"
sudo bash "$(dirname "$0")/intro.sh"

# Define options as pairs: tag + description
OPTIONS=(
    "bun" "Install bun-js"
    "zen" "Install Zen Browser"
    "vscode" "Install VSCode"
    "nvm" "Install NVM"
    "steam" "Install Steam"
    "telegram" "Install Telegram"
    "obsidian" "Install Obsidian"
    "omz" "Install Oh My Zsh"
    "git" "Git Setup"
    "docker" "Install Docker"
    "cleanup" "Uninstall default apps (caution)"
)

# Build display options with combined tag and description
CHOICE_DISPLAY=()
for ((i=0; i<${#OPTIONS[@]}; i+=2)); do
    tag="${OPTIONS[i]}"
    desc="${OPTIONS[i+1]}"
    CHOICE_DISPLAY+=("$tag - $desc")
done

log_info "Select components to install (use space to toggle, enter to confirm):"
SELECTED=$(gum choose --no-limit --header "Select components to install" "${CHOICE_DISPLAY[@]}")

if [ -z "$SELECTED" ]; then
    log_info "User cancelled."
    exit 1
fi

# Extract just the tags from selected items (everything before " - ")
SELECTED_TAGS=()
while IFS= read -r line; do
    tag=$(echo "$line" | cut -d' ' -f1)
    SELECTED_TAGS+=("$tag")
done <<< "$SELECTED"

# Now you can use SELECTED_TAGS array for your installation logic
# For example:
for tag in "${SELECTED_TAGS[@]}"; do
    log_info "Processing: $tag"
    # Add your installation logic here based on the tag
done

log_success "🎉 All tasks completed successfully!"