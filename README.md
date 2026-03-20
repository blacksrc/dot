# dot

A personal, automated setup and teardown toolkit for configuring a development environment on Ubuntu or Debian systems.
This project installs and configures essential tools and applications such as Oh My Zsh, NVM, Docker, Zen Browser, and more, using modular Bash scripts.

<img width="1061" height="835" alt="image" src="https://github.com/user-attachments/assets/578000c7-55a7-43cc-a97e-d0ac75396db5" />

---

## Table of Contents

- [Features](#features)
- [Getting Started](#getting-started)
- [Included Apps & Tools](#included-apps--tools)
- [Directory Structure](#directory-structure)
- [Customization](#customization)
- [Contributing](#contributing)
- [License](#license)

---

## Features

- **Automated Installation**: Installs development tools and apps with a single command.
- **Interactive Selection**: Pick which apps to install from a terminal menu powered by [gum](https://github.com/charmbracelet/gum).
- **Modular Scripts**: Each app has its own self-contained script in `apps/`.
- **Permission Aware**: Scripts that need root run as root; user-level scripts (Oh My Zsh, Git, Cargo) run as your normal user automatically.
- **Safe Defaults**: Prompts for confirmation before making changes.
- **Easily Extensible**: Add a script to `apps/` and register it in `apps.json`.

---

## Getting Started

### Prerequisites

- Ubuntu or Debian-based Linux system
- Root privileges (use `sudo`)
- Internet connection

### Installation

1. **Clone the repository**

   ```sh
   git clone https://github.com/siamak/dot.git
   cd dot
   ```

2. **Review the scripts**

   > **Warning**: This toolkit is tailored to the author's preferences.
   > Review and edit scripts as needed before running.

3. **Run the installer**

   ```sh
   sudo bash install.sh
   ```

   The installer will:
   - Update the system and install base dependencies (`init.sh`)
   - Show a welcome screen and ask for confirmation (`intro.sh`)
   - Present an interactive menu to select which apps to install

### Uninstallation (wip)

```sh
sudo bash uninstall.sh
```

---

## Included Apps & Tools

The installer currently supports **25 apps**. Each can be toggled on or off during installation.

| App | Description |
|-----|-------------|
| Bun | Fast JavaScript runtime |
| Cargo | Rust package manager and build system |
| Chrome | Google Chrome browser |
| Cursor | AI-powered code editor |
| DBeaver | Multi-platform database tool |
| Docker | Container platform (Engine, Compose, Buildx) |
| fzf | Command-line fuzzy finder |
| gh | GitHub CLI |
| Gimp | Image editor |
| Git Setup | Git user configuration and SSH key generation |
| Htop | Interactive process viewer |
| LazyDocker | Terminal UI for Docker |
| NordVPN | VPN client |
| NVM | Node Version Manager (with latest LTS) |
| Obsidian | Knowledge base on local Markdown files |
| Oh My Zsh | Zsh framework with plugins and themes |
| Spotify | Music streaming client |
| Steam | Gaming platform |
| Telegram | Messaging client |
| Terminator | Multi-pane terminal emulator |
| VLC | Media player |
| VSCode | Source-code editor |
| Yarn | JavaScript package manager |
| Zen Browser | Privacy-focused browser |
| ZSA Keymapp | ZSA keyboard firmware and configuration tool |

---

## Directory Structure

```
.
├── apps/                  # App-specific install scripts
│   ├── apps.json          # App registry (name, description, script, root requirement)
│   ├── bun.sh
│   ├── cargo.sh
│   ├── chrome.sh
│   ├── cursor.sh
│   ├── dbeaver.sh
│   ├── docker.sh
│   ├── fzf.sh
│   ├── gh.sh
│   ├── gimp.sh
│   ├── git-setup.sh
│   ├── htop.sh
│   ├── lazydocker.sh
│   ├── nordvpn.sh
│   ├── nvm.sh
│   ├── obsidian.sh
│   ├── omz.sh
│   ├── spotify.sh
│   ├── steam.sh
│   ├── telegram.sh
│   ├── terminator.sh
│   ├── vlc.sh
│   ├── vscode.sh
│   ├── yarn.sh
│   ├── zen-browser.sh
│   └── zsa.sh
├── check-shell.sh         # Shellcheck & shfmt validation
├── gum.sh                 # Installs gum (interactive UI dependency)
├── init.sh                # System update & base dependency install
├── install.sh             # Main entrypoint
├── intro.sh               # Welcome screen & confirmation prompt
├── uninstall.sh           # App removal (wip)
└── utils.sh               # Shared logging functions
```

---

## Customization

### Adding a new app

1. Create a script in `apps/` (e.g. `apps/myapp.sh`):

   ```bash
   #!/usr/bin/env bash
   set -e
   source "$(dirname "$0")/../utils.sh"

   # Add a root check if needed:
   # if [[ "$EUID" -ne 0 ]]; then
   #   log_error "Please run as root"
   #   exit 1
   # fi

   log_info "Installing myapp..."
   # your install commands here
   log_success "myapp installed."
   ```

2. Register it in `apps/apps.json`:

   ```json
   {
     "name": "My App",
     "description": "Short description of what it does.",
     "script": "myapp.sh",
     "asRoot": true
   }
   ```

   Set `asRoot` to `true` if the script requires root, or `false` if it should run as the normal user.

### Shell linting

Run `bash check-shell.sh` to validate all scripts with shellcheck and shfmt.

---

## Contributing

Contributions are welcome!
Feel free to submit issues or pull requests for improvements, bug fixes, or new app scripts.

---

## License

MIT License. See [LICENSE](LICENSE).
