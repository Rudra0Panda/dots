
## 🚀 Installation

### 1. Install Essential & Development Packages
To install required packages (Labwc, Qt/KDE integration, Yay, Code, CLion, KiCad, ST-Link, OpenOCD, PlatformIO, Okular, LibreOffice, Gwenview, VLC, Xournal++, OpenTabletDriver, fonts, utilities):

```bash
chmod +x install-packages.sh

# Install everything (Core Desktop + Development & Embedded tools)
./install-packages.sh

# Or selectively install:
./install-packages.sh --core    # Labwc + Qt environment only
./install-packages.sh --dev     # Development, Embedded, KiCad & Media only
```

### 2. Install Dotfiles & Themes (Direct Portable Copy)
To install the configurations directly into your `$HOME` directory:

```bash
chmod +x install.sh
./install.sh
```
*(Or run `./install.sh --packages` to run both package installation and dotfile setup in sequence)*

The install script automatically:
1. Backs up any existing configuration files to a timestamped backup directory (`~/.dotfiles_backup_<timestamp>`).
2. Copies all configuration files and assets directly into `~/.config/`, `~/.local/bin/`, and `~/.local/share/` (avoiding fragile symlinks so it can be replicated onto any system).
3. Adapts internal paths dynamically to the target system's `$HOME`.
4. Reloads active daemons (`labwc`, `swaync`, `eww`, and `kvantum`).

---

## ⌨️ Keybindings

| Shortcut | Action |
| :--- | :--- |
| `Super + Return` | Launch Terminal |
| `Super + d` / `Super + Space` | Launch Wofi Application Menu |
| `Print` | Fullscreen Screenshot (copied to clipboard & saved to `~/Pictures/Screenshots`) |
| `Shift + Print` / `Super + Shift + S` | Area Selection Screenshot |
| `Super + Shift + c` | Close active window |
| `Super + m` | Toggle Maximize |
| `Super + Shift + r` | Reload Labwc configuration |
