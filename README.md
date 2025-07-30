# dot

A personal, automated setup and teardown toolkit for configuring a development environment on Ubuntu or Debian systems.  
This project installs and configures essential tools and applications such as Oh My Zsh, NVM, VSCode, Zen Browser, and more, using modular Bash scripts.

<img width="1093" height="585" alt="image" src="https://github.com/user-attachments/assets/b8b62b29-bb0f-4bd8-89c2-dfcedd8570d0" />

---

## Features

- **Automated Installation**: Installs development tools and apps with a single command.
- **Modular Scripts**: Each app or tool has its own script in `apps/`.
- **Uninstall Support**: Cleanly remove installed applications.
- **User-Friendly Logging**: Informative, emoji-enhanced log output.
- **Safe Defaults**: Prompts for confirmation before making changes.

---

## Directory Structure

```
.
├── apps/                  # App-specific install scripts
│   ├── git-setup.sh
│   ├── bun.sh
│   ├── nvm.sh
│   ├── omz.sh
│   ├── vscode.sh
│   └── zen-browser.sh
├── init.sh                # System update & dependency install
├── install.sh             # Main install entrypoint
├── intro.sh               # Welcome and info prompt
├── LICENSE
├── README.md
├── uninstall.sh           # Uninstall selected applications
└── utils.sh               # Logging functions
```

---

## Usage

### 1. Review the Scripts

**Important:**  
This toolkit is tailored to the author's preferences.  
**Review and edit scripts as needed before running.**

### 2. Installation

Run the following as root (e.g., with `sudo`):

```sh
sudo bash install.sh
```

- You will see an introduction and be prompted to confirm.
- The script will run `init.sh` (system update), then install apps via scripts in `apps/`.

### 3. Uninstallation

To remove installed applications:

```sh
sudo bash uninstall.sh
```

You will be prompted before any removal.

---

## Included Apps & Tools

- **Oh My Zsh** (`apps/omz.sh`): Installs Zsh, Oh My Zsh, plugins, and configures `.zshrc`.
- **NVM & Node.js** (`apps/nvm.sh`): Installs NVM globally and latest LTS Node.js for all users.
- **VSCode** (`apps/vscode.sh`): Adds Microsoft repo and installs VSCode.
- **Zen Browser** (`apps/zen-browser.sh`): Downloads and installs Zen Browser.
- **Git Setup** (`apps/git-setup.sh`): Configures Git user info and SSH keys.

---

## Logging

All scripts use the logging functions in `utils.sh`:

- `log_info`, `log_success`, `log_warning`, `log_error`

---

## Customization

- Add or remove apps in `apps/`.
- Edit the `APPS` array in `uninstall.sh` to control what gets uninstalled.
- Adjust install steps in `install.sh` as needed.

---
