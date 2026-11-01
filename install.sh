#!/usr/bin/env bash
# ==============================================================================
# Dotfiles Installation & Setup Script
# Copies real files directly into user directories (No symlinks) for portability
# ==============================================================================
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"

# Optional package installation
if [[ "${1:-}" == "--packages" ]] || [[ "${1:-}" == "-p" ]]; then
    echo "==> Running package installer..."
    "$DOTFILES_DIR/install-packages.sh"
    echo ""
fi

echo "==> Installing dotfiles directly to system from: $DOTFILES_DIR"

# Ensure target directories exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/color-schemes"
mkdir -p "$HOME/.local/share/themes"

backup_and_copy() {
    local src="$1"
    local dest="$2"

    # If destination is a symlink, remove the link so real files can be stored
    if [ -L "$dest" ]; then
        echo "  [UNLINK] Removing existing symlink: $dest"
        rm -f "$dest"
    elif [ -e "$dest" ]; then
        # Check if contents are already identical
        if [ -f "$src" ] && [ -f "$dest" ] && cmp -s "$src" "$dest"; then
            echo "  [OK] Up to date: $dest"
            return
        elif [ -d "$src" ] && [ -d "$dest" ] && diff -rq "$src" "$dest" >/dev/null 2>&1; then
            echo "  [OK] Up to date: $dest"
            return
        fi

        echo "  [BACKUP] Backing up existing $dest -> $BACKUP_DIR"
        mkdir -p "$BACKUP_DIR"
        mv "$dest" "$BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dest")"
    cp -a "$src" "$dest"
    echo "  [COPY] $dest <- $src"
}

# 1. Install .config directories
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
    "OpenTabletDriver"
    "xournalpp"
    "fish"
)

for dir in "${CONFIG_DIRS[@]}"; do
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        backup_and_copy "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
    fi
done

# 2. Install standalone files in .config
if [ -f "$DOTFILES_DIR/.config/kdeglobals" ]; then
    backup_and_copy "$DOTFILES_DIR/.config/kdeglobals" "$HOME/.config/kdeglobals"
fi
if [ -f "$DOTFILES_DIR/.config/dolphinrc" ]; then
    backup_and_copy "$DOTFILES_DIR/.config/dolphinrc" "$HOME/.config/dolphinrc"
fi

# 3. Install .local/bin wrappers and tools
if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    for bin_file in "$DOTFILES_DIR/.local/bin"/*; do
        if [ -f "$bin_file" ]; then
            dest_file="$HOME/.local/bin/$(basename "$bin_file")"
            backup_and_copy "$bin_file" "$dest_file"
            chmod +x "$dest_file"
        fi
    done
fi

# 4. Install .local/share assets & desktop entries
if [ -f "$DOTFILES_DIR/.local/share/color-schemes/Monochrome.colors" ]; then
    backup_and_copy "$DOTFILES_DIR/.local/share/color-schemes/Monochrome.colors" "$HOME/.local/share/color-schemes/Monochrome.colors"
fi

if [ -d "$DOTFILES_DIR/.local/share/themes/Monochrome" ]; then
    backup_and_copy "$DOTFILES_DIR/.local/share/themes/Monochrome" "$HOME/.local/share/themes/Monochrome"
fi

if [ -d "$DOTFILES_DIR/.local/share/applications" ]; then
    for app_file in "$DOTFILES_DIR/.local/share/applications"/*; do
        if [ -f "$app_file" ]; then
            backup_and_copy "$app_file" "$HOME/.local/share/applications/$(basename "$app_file")"
        fi
    done
fi

# 5. Install root dotfiles
if [ -f "$DOTFILES_DIR/.bashrc" ]; then
    backup_and_copy "$DOTFILES_DIR/.bashrc" "$HOME/.bashrc"
fi
if [ -f "$DOTFILES_DIR/.gtkrc-2.0" ]; then
    backup_and_copy "$DOTFILES_DIR/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
fi

# 6. Adapt user home paths for portability across different systems/usernames
echo "==> Adapting configuration paths to $HOME..."
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/qt5ct/qt5ct.conf" 2>/dev/null || true
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/qt6ct/qt6ct.conf" 2>/dev/null || true
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/waypaper/config.ini" 2>/dev/null || true
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/labwc/environment" 2>/dev/null || true
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/gtk-3.0/bookmarks" 2>/dev/null || true
sed -i "s|/home/[^/]*|$HOME|g" "$HOME/.config/xournalpp/settings.xml" 2>/dev/null || true

# 7. Reload active daemons if running
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

echo "==> Dotfiles installation complete! All files copied directly."
