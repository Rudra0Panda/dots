#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installation & Symlinking Script
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

echo "==> Installing dotfiles from: $DOTFILES_DIR"

# Ensure target directories exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/share/color-schemes"
mkdir -p "$HOME/.local/share/themes"

backup_and_link() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$(readlink -f "$dest" 2>/dev/null)" = "$src" ]; then
            echo "  [OK] Already linked: $dest"
            return
        fi
        echo "  [BACKUP] Backing up existing $dest -> $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dest")"
    ln -sf "$src" "$dest"
    echo "  [LINK] $dest -> $src"
}

# Link .config directories
CONFIG_DIRS=(
    "labwc"
    "eww"
    "swaync"
    "Kvantum"
    "qt6ct"
    "qt5ct"
    "gtk-3.0"
    "gtk-4.0"
    "wofi"
    "waypaper"
    "xsettingsd"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        backup_and_link "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
    fi
done

# Link standalone files in .config
if [ -f "$DOTFILES_DIR/.config/kdeglobals" ]; then
    backup_and_link "$DOTFILES_DIR/.config/kdeglobals" "$HOME/.config/kdeglobals"
fi
if [ -f "$DOTFILES_DIR/.config/dolphinrc" ]; then
    backup_and_link "$DOTFILES_DIR/.config/dolphinrc" "$HOME/.config/dolphinrc"
fi

# Link root dotfiles
if [ -f "$DOTFILES_DIR/.gtkrc-2.0" ]; then
    backup_and_link "$DOTFILES_DIR/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
fi

# Link .local/share assets
if [ -f "$DOTFILES_DIR/.local/share/color-schemes/Monochrome.colors" ]; then
    backup_and_link "$DOTFILES_DIR/.local/share/color-schemes/Monochrome.colors" "$HOME/.local/share/color-schemes/Monochrome.colors"
fi

if [ -d "$DOTFILES_DIR/.local/share/themes/Monochrome" ]; then
    backup_and_link "$DOTFILES_DIR/.local/share/themes/Monochrome" "$HOME/.local/share/themes/Monochrome"
fi

# Reload active daemons if running
echo "==> Reloading environments..."
if command -v labwc >/dev/null 2>&1 && pidof labwc >/dev/null 2>&1; then
    labwc -r 2>/dev/null || true
fi

if command -v swaync-client >/dev/null 2>&1 && pidof swaync >/dev/null 2>&1; then
    swaync-client -rs 2>/dev/null || true
fi

if command -v eww >/dev/null 2>&1 && pidof eww >/dev/null 2>&1; then
    eww reload 2>/dev/null || true
fi

if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
    plasma-apply-colorscheme Monochrome 2>/dev/null || true
fi

if command -v kvantummanager >/dev/null 2>&1; then
    kvantummanager --set MonochromeSolid 2>/dev/null || true
fi

echo "==> Dotfiles setup complete!"
