#!/usr/bin/env bash
set -e

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

target_user=$(logname)

log_info "Running init.sh (System update & dependencies)..."
sudo bash "$(dirname "$0")/init.sh"

log_info "Running gum.sh (Install gum)..."
sudo bash "$(dirname "$0")/gum.sh"
sudo bash "$(dirname "$0")/intro.sh"

APP_JSON="$(dirname "$0")/apps/apps.json"
if [ ! -f "$APP_JSON" ]; then
  log_error "apps.json not found!"
  exit 1
fi

CHOICE_DISPLAY=()

declare -A MAP_TAG_TO_SCRIPT
declare -A MAP_TAG_TO_ASROOT

while IFS= read -r row; do
  name=$(jq -r '.name' <<< "$row")
  desc=$(jq -r '.description' <<< "$row")
  script=$(jq -r '.script' <<< "$row")
  as_root=$(jq -r '.asRoot' <<< "$row")

  CHOICE_DISPLAY+=("$name - $desc")

  MAP_TAG_TO_SCRIPT["$name"]="$script"
  MAP_TAG_TO_ASROOT["$name"]="$as_root"
done < <(jq -c '.[]' "$APP_JSON")

log_info "Select components to install (use space to toggle, enter to confirm):"
SELECTED=$(gum choose --no-limit --header "Select components to install" "${CHOICE_DISPLAY[@]}")

if [ -z "$SELECTED" ]; then
  log_info "User cancelled."
  exit 1
fi

SELECTED_TAGS=()
while IFS= read -r line; do
  tag="${line%% - *}"
  SELECTED_TAGS+=("$tag")
done <<< "$SELECTED"

for tag in "${SELECTED_TAGS[@]}"; do
  script="${MAP_TAG_TO_SCRIPT["$tag"]}"
  as_root="${MAP_TAG_TO_ASROOT["$tag"]}"

  if [ ! -f "$(dirname "$0")/apps/$script" ]; then
    log_warning "Script not found: $script"
    continue
  fi

  log_info "🔧 Running $tag ($script)..."
  if [[ "$as_root" == "true" ]]; then
    sudo bash "$(dirname "$0")/apps/$script"
  else
    bash "$(dirname "$0")/apps/$script"
  fi

  sleep 1
done

log_success "🎉 All selected tasks completed!"
