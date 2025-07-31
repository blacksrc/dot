#!/usr/bin/env bash
set -e

# shellcheck source=utils.sh
source "$(dirname "$0")/utils.sh"

cat << "EOF"

██████╗  ██████╗ ████████╗
██╔══██╗██╔═══██╗╚══██╔══╝
██║  ██║██║   ██║   ██║   
██║  ██║██║   ██║   ██║   
██████╔╝╚██████╔╝   ██║   
╚═════╝  ╚═════╝    ╚═╝   
Version: 0.0.1
License: MIT
Description: This script automates the setup of a development environment
by installing essential tools and applications, including Oh My Zsh, NVM, VSCode, and more.

=============================================================================
🔔 Important Notes:
- This is a personal, non-optimized setup script tailored to my preferences.
Feel free to customize it to fit your own needs!
- This script installs various development tools and modifies your system.
- Please backup your important data before proceeding (probably nothing to backup yet).
- Recommended for fresh Ubuntu or Debian installations.
- Must be run with root privileges (e.g., via sudo).
- Review and understand the script before running it.
=============================================================================

EOF

if ! gum confirm "👉 Proceed with installation?"; then
  log_error "Installation aborted."
  exit 1
fi
