# Monochrome Dotfiles (Labwc + Eww + SwayNC + Kvantum)

A minimal, high-contrast monochrome desktop setup for Wayland built around **Labwc**, **Eww**, **SwayNC**, and **Kvantum**.

---

## 🎨 Theme Overview

- **Window Manager**: Labwc (Wayland stacking compositor)
- **Status Bar**: Eww (ElKowar's Wacky Widgets)
- **Notification Daemon**: SwayNC (solid dark cards `#121212`, 0 opacity)
- **Application Launcher**: Wofi (Monochrome)
- **Qt Styling**: Kvantum (`MonochromeSolid` with `#ffffff` text contrast) managed by `qt6ct`
- **GTK Styling**: GTK 3 & GTK 4 dark headerbars with custom 10x10 colored square control buttons:
  - 🔴 Close: `#ea6962`
  - 🟡 Minimize / Iconify: `#d8a657`
  - 🟢 Maximize: `#a9b665`
- **Clipboard**: `cliphist` integration with interactive status pill on Eww bar
- **Screenshots**: `grim` + `slurp` bound to `Print` and `Shift+Print` (`W-S-s`)

---

## 📂 Repository Structure

```
dotfiles/
├── .config/
│   ├── eww/              # Top status bar, widgets & clipboard counter
│   ├── fish/             # Fish shell configuration
│   ├── gtk-3.0/          # GTK 3 theme & square window control assets
│   ├── gtk-4.0/          # GTK 4 theme & square window control assets
│   ├── kdeglobals        # KDE / KF6 global color scheme (Monochrome)
│   ├── Kvantum/          # Kvantum MonochromeSolid theme files
│   ├── labwc/            # Labwc compositor config, keybinds, square button theme & scripts
│   ├── qt5ct/            # Qt 5 configuration & color scheme
│   ├── qt6ct/            # Qt 6 configuration & color scheme
│   ├── swaync/           # Notification center layout & CSS
│   ├── waypaper/         # Wallpaper selector configuration
│   ├── wofi/             # Application launcher theme & config
│   └── xsettingsd/       # XSettings daemon config
├── .local/
│   └── share/
│       ├── color-schemes/ # Monochrome.colors (KDE color scheme)
│       └── themes/        # Monochrome window theme (Labwc & Openbox)
├── .bashrc               # Bash configuration
├── .gtkrc-2.0            # Legacy GTK 2 settings
├── install-packages.sh   # Automated package & dependency installer
├── install.sh            # Automated installation & symlink script
└── README.md
```

---

## 🚀 Installation

### 1. Install Essential Packages & Dependencies
To install all required packages (Labwc, Qt/KDE integration, Yay, Code, Xournal++, OpenTabletDriver, fonts, utilities):

```bash
chmod +x install-packages.sh
./install-packages.sh
```

### 2. Link Dotfiles & Themes
To link configurations to your `$HOME` directory:

```bash
chmod +x install.sh
./install.sh
```
*(Or run `./install.sh --packages` to run both in sequence)*

The install script automatically:
1. Backs up any existing configuration files to a timestamped backup directory (`~/.dotfiles_backup_<timestamp>`).
2. Creates symlinks from `~/.config/` and `~/.local/` to the dotfiles directory.
3. Reloads active daemons (`labwc`, `swaync`, `eww`, and `kvantum`).

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
