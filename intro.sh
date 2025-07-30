#!/usr/bin/env bash
set -e

# Load utils
source "$(dirname "$0")/utils.sh"

cat << "EOF"

██████╗ ██╗      █████╗  ██████╗██╗  ██╗██████╗  ██████╗ ████████╗
██╔══██╗██║     ██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔═══██╗╚══██╔══╝
██████╔╝██║     ███████║██║     █████╔╝ ██║  ██║██║   ██║   ██║   
██╔══██╗██║     ██╔══██║██║     ██╔═██╗ ██║  ██║██║   ██║   ██║   
██████╔╝███████╗██║  ██║╚██████╗██║  ██╗██████╔╝╚██████╔╝   ██║   
╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═════╝  ╚═════╝    ╚═╝   

🚀 Version: 0.0.1
📄 License: MIT
👤 Author: Siamak Motlagh

📝 Description:
This script automates the setup of a development environment by installing essential tools and applications,
including Oh My Zsh, NVM, VSCode, and more.

=============================================================================
🔔 Important Notes:
- This is a personal, non-optimized setup script tailored to my preferences.
Feel free to customize it to fit your own needs!
- This script installs various development tools and modifies your system.
- Please backup your important data before proceeding.
- Recommended for fresh Ubuntu or Debian installations.
- Must be run with root privileges (e.g., via sudo).
- Review and understand the script before running it.
=============================================================================

EOF

read -rp "👉 Proceed with installation? (y/N): " confirm
confirm=${confirm,,}

if [[ "$confirm" != "y" && "$confirm" != "yes" ]]; then
  log_error "Installation aborted."
  exit 1
fi
