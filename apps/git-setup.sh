#!/usr/bin/env bash
set -e

# Load utils
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -eq 0 ]]; then
  log_error "Please do NOT run git-setup.sh as root. Run it as your normal user."
  exit 1
fi

# Ask for Git config
read -rp "👉 Enter your Git name: " git_name
read -rp "👉 Enter your Git email: " git_email

log_info "Setting Git global configuration..."
git config --global user.name "$git_name"
git config --global user.email "$git_email"
git config --global init.defaultBranch main
log_success "Git username and email configured"

# Generate SSH key if not exists
ssh_key="$HOME/.ssh/id_ed25519"

if [[ -f "$ssh_key" ]]; then
  log_warning "SSH key already exists: $ssh_key"
else
  log_info "Generating new SSH key..."
  read -rp "🔐 Do you want to protect your SSH key with a passphrase? (y/n): " use_passphrase

  if [[ "$use_passphrase" == "y" || "$use_passphrase" == "Y" ]]; then
    ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key"
  else
    ssh-keygen -t ed25519 -C "$git_email" -f "$ssh_key" -N ""
  fi

  log_success "SSH key generated at $ssh_key"
fi

# Ensure ssh-agent is running and add key
eval "$(ssh-agent -s)" >/dev/null

log_info "Adding SSH key to ssh-agent..."
ssh-add "$ssh_key"
log_success "SSH key added to ssh-agent"

# Output public key for user to add to GitHub/GitLab
log_info "Here is your public SSH key. Add it to your Git provider:"
echo "--------------------------------------"
cat "$ssh_key.pub"
echo "--------------------------------------"

log_success "Git configuration complete 🎉"
