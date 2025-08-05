# dot

A personal, automated setup and teardown toolkit for configuring a development environment on Ubuntu or Debian systems.  
This project installs and configures essential tools and applications such as Oh My Zsh, NVM, Docker, Zen Browser, and more, using modular Bash scripts.

<img width="1061" height="835" alt="image" src="https://github.com/user-attachments/assets/578000c7-55a7-43cc-a97e-d0ac75396db5" />

---

## Table of Contents

- [dot](#dot)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Directory Structure](#directory-structure)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Uninstallation](#uninstallation)
  - [Included Apps \& Tools](#included-apps--tools)
  - [Logging](#logging)
  - [Customization](#customization)
  - [Contributing](#contributing)
  - [License](#license)
  - [TODO](#todo)

---

## Features

- **Automated Installation**: Installs development tools and apps with a single command.
- **Modular Scripts**: Each app or tool has its own script in `apps/`.
- **Uninstall Support**: Cleanly remove installed applications.
- **User-Friendly Logging**: Informative, emoji-enhanced log output.
- **Safe Defaults**: Prompts for confirmation before making changes.
- **Easily Extensible**: Add or remove apps by editing the `apps/` directory.

---

## Directory Structure

```
.
├── apps/                  # App-specific install scripts
│   ├── apps.json          # List of apps to install
│   ├── git-setup.sh
│   ├── bun.sh
│   ├── nvm.sh
│   ├── omz.sh
│   ├── docker.sh
│   ├── zen-browser.sh
│   └── ...                # Add your own scripts here
├── init.sh                # System update & dependency install
├── install.sh             # Main install entrypoint
├── intro.sh               # Welcome and info prompt
├── LICENSE
├── README.md
├── uninstall.sh           # Uninstall selected applications
├── utils.sh               # Utility functions
└── ...
```

---

## Getting Started

### Prerequisites

- Ubuntu or Debian-based Linux system
- Root privileges (use `sudo`)
- Internet connection

### Installation

1. **Review the Scripts**

   > ⚠️ This toolkit is tailored to the author's preferences.  
   > **Review and edit scripts as needed before running.**

2. **Run the Installer**

   ```sh
   sudo bash install.sh
   ```

   - You will see an introduction and be prompted to confirm.
   - The script will run `init.sh` (system update), then install apps via scripts in `apps/`.

### Uninstallation

To remove installed applications:

```sh
sudo bash uninstall.sh
```

You will be prompted before any removal.

---

## Included Apps & Tools
Check the `apps/` directory for individual scripts.

---

## Logging

All scripts use the logging functions in `utils.sh`:

- `log_info`, `log_success`, `log_warning`, `log_error`

These provide clear, color-coded, and emoji-enhanced output for better readability.

---

## Customization

- **Add/Remove Apps:**  
  Place your install/uninstall scripts in the `apps/` directory. Each script should be executable and follow the existing conventions.
- **Control Uninstallation:**  
  Edit the `APPS` array in `uninstall.sh` to control what gets uninstalled.
- **Register your app:**  
  Add your app to `apps/apps.json` to include it in the installation process.

---

## Contributing

Contributions are welcome!  
Feel free to submit issues or pull requests for improvements, bug fixes, or new app scripts.

---

## License

MIT License. See [LICENSE](LICENSE).

---

## TODO

- [x] Make installation script dynamic
- [ ] Add lazygit support
- [x] Add lazydocker support
- [ ] Add dependency management for apps
    <br /> E.g., check if Docker is installed before installing lazydocker
- [ ] Accumulate logs to show at the end of the installation process
    <br /> E.g., docker needs a gnome-session restart to work properly
