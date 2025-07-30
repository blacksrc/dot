#!/usr/bin/env bash
set -e

# Load logger
source "$(dirname "$0")/../utils.sh"

if [[ "$EUID" -eq 0 ]]; then
  log_error "Please do NOT run omz.sh as root. Run it as your normal user."
  exit 1
fi

# Install Zsh if missing
if ! command -v zsh &>/dev/null; then
  log_info "Zsh not found. Installing Zsh..."
  sudo apt update
  sudo apt install -y zsh
  log_success "Zsh installed"
else
  log_info "Zsh is already installed"
fi

# Install Oh My Zsh if missing
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  log_warning "Oh My Zsh already installed"
else
  log_info "Installing Oh My Zsh..."
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  log_success "Oh My Zsh installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install zsh-autosuggestions
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]]; then
  log_info "Installing zsh-autosuggestions plugin..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
  log_success "zsh-autosuggestions installed"
else
  log_info "zsh-autosuggestions already installed"
fi

# Install zsh-syntax-highlighting
if [[ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]]; then
  log_info "Installing zsh-syntax-highlighting plugin..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
  log_success "zsh-syntax-highlighting installed"
else
  log_info "zsh-syntax-highlighting already installed"
fi

# Install autojump if missing
if ! command -v autojump &>/dev/null; then
  log_info "Installing autojump (directory jumper)..."
  sudo apt update
  sudo apt install -y autojump
  log_success "autojump installed"
else
  log_info "autojump already installed"
fi

# Remove any old 'source $HOME/.local/bin/j.sh' lines from .zshrc (cleanup)
if grep -q 'source $HOME/.local/bin/j.sh' "$HOME/.zshrc" 2>/dev/null; then
  sed -i '/source \$HOME\/.local\/bin\/j.sh/d' "$HOME/.zshrc"
  log_info "Removed old j.sh source line from .zshrc"
fi

# Enable autojump in .zshrc if not already present
if ! grep -q '/usr/share/autojump/autojump.sh' "$HOME/.zshrc" 2>/dev/null; then
  echo '[ -f /usr/share/autojump/autojump.sh ] && source /usr/share/autojump/autojump.sh' >> "$HOME/.zshrc"
  log_success "Enabled autojump in .zshrc"
fi

# Ensure ~/.local/bin is in PATH in .zshrc
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc" 2>/dev/null; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  log_success "Added ~/.local/bin to PATH in .zshrc"
fi

# Define plugins to enable in .zshrc (exclude z, include others)
plugins=(
  git
  zsh-autosuggestions
  zsh-syntax-highlighting
  alias-finder
  extract
  sudo
  history
  common-aliases
)

plugins_line="plugins=(${plugins[*]})"

# Update or add plugins line in .zshrc
if grep -q "^plugins=" "$HOME/.zshrc" 2>/dev/null; then
  sed -i "s/^plugins=.*/$plugins_line/" "$HOME/.zshrc"
else
  echo "$plugins_line" >> "$HOME/.zshrc"
fi
log_success "Updated plugins in .zshrc"

# Set default shell to zsh if not already
current_shell="$(getent passwd "$USER" | cut -d: -f7)"
zsh_path="$(command -v zsh)"

if [[ "$current_shell" != "$zsh_path" ]]; then
  log_info "Changing default shell to Zsh..."
  chsh -s "$zsh_path"
  log_success "Default shell set to Zsh"
else
  log_info "Zsh is already the default shell"
fi

log_success "Oh My Zsh and plugins setup complete 🎉"
log_info "Please restart your terminal or run 'exec zsh' to start using Zsh with Oh My Zsh."
