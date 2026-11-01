#!/usr/bin/env bash
# ==============================================================================
# Essential & Development Packages Installer for Labwc + Qt Environment
# Optimized for Arch Linux with Qt/KDE integration (No unneeded GTK bloat)
# ==============================================================================
set -euo pipefail

# Visual output helpers
BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

log_info()    { echo -e "${BLUE}${BOLD}==>${NC} ${BOLD}$*${NC}"; }
log_step()    { echo -e "  ${BLUE}->${NC} $*"; }
log_success() { echo -e "  ${GREEN}[OK]${NC} $*"; }
log_warn()    { echo -e "  ${YELLOW}[WARN]${NC} $*"; }
log_error()   { echo -e "  ${RED}[ERROR]${NC} $*"; }

# ------------------------------------------------------------------------------
# 1. Environment & Sanity Checks
# ------------------------------------------------------------------------------
if [ "${EUID}" -eq 0 ]; then
    log_error "Do not run this script as root or with sudo."
    log_error "The script will invoke sudo when root privileges are required."
    exit 1
fi

if ! command -v pacman >/dev/null 2>&1; then
    log_error "pacman not detected. This installer is designed for Arch Linux."
    exit 1
fi

MODE="all"
while [[ $# -gt 0 ]]; do
    case "$1" in
        --core|--core-only)
            MODE="core"
            shift
            ;;
        --dev|--dev-only)
            MODE="dev"
            shift
            ;;
        --all)
            MODE="all"
            shift
            ;;
        -h|--help)
            echo "Usage: ./install-packages.sh [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  --all         Install Core Desktop, Development, and Productivity tools (Default)"
            echo "  --core        Install only Labwc + Qt core desktop environment"
            echo "  --dev         Install only Development tools (Embedded, KiCad, CLion, Media)"
            echo "  -h, --help    Show this help message"
            exit 0
            ;;
        *)
            log_warn "Unknown option '$1'. Defaulting to full installation (--all)."
            shift
            ;;
    esac
done

log_info "Initializing package installation (Mode: $MODE)..."

# ------------------------------------------------------------------------------
# 2. Bootstrap Build Essentials & AUR Helper (yay)
# ------------------------------------------------------------------------------
log_info "Checking core build tools and AUR helper..."

sudo pacman -S --needed --noconfirm base-devel git

if ! command -v yay >/dev/null 2>&1; then
    log_step "yay not found. Bootstrapping yay from AUR..."
    YAY_BUILD_DIR="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay-bin.git "$YAY_BUILD_DIR/yay-bin" || \
    git clone https://aur.archlinux.org/yay.git "$YAY_BUILD_DIR/yay"
    (
        cd "$YAY_BUILD_DIR"/*
        makepkg -si --noconfirm
    )
    rm -rf "$YAY_BUILD_DIR"
    log_success "yay installed successfully."
else
    log_success "yay is already installed: $(yay --version | head -n 1)"
fi

# ------------------------------------------------------------------------------
# 3. Package Definitions (Official Repositories)
# ------------------------------------------------------------------------------

# --- Core Desktop & Utilities ---
CORE_BUILD_TOOLS=(
    "base-devel"
    "git"
    "cmake"
    "rust"
    "clang"
)

CORE_USER_APPS=(
    "code"             # Visual Studio Code (OSS)
    "xournalpp"        # Handwriting / PDF annotation tool (modern xournal)
)

QT_FILE_MANAGEMENT=(
    "dolphin"                 # Qt file manager
    "ffmpegthumbs"            # Video thumbnail generator for Dolphin/KIO
    "kdegraphics-thumbnailers"# Image/PDF thumbnailers
    "kio-extras"              # Additional KIO protocols & thumbnail support
)

COMPOSITOR_AND_DM=(
    "labwc"                   # Wayland stacking compositor
    "sddm"                    # Qt-based display manager
)

QT_WAYLAND_THEMING=(
    "qt5-wayland"
    "qt6-wayland"
    "qt6ct"                   # Qt6 configuration tool
    "qt5ct"                   # Qt5 configuration tool
    "kvantum"                 # SVG-based style engine for MonochromeSolid theme
    "polkit-kde-agent"        # Qt Polkit authentication agent
    "polkit-qt6"
    "xdg-desktop-portal"
    "xdg-desktop-portal-kde"  # Qt/KDE desktop portal for Wayland dialogs
    "xdg-desktop-portal-wlr"  # wlroots portal backend for screen capture
    "kdeconnect"              # KDE Connect device integration
    "kwalletmanager"          # Qt wallet manager
)

SHELL_UTILS=(
    "swaybg"                  # Wallpaper utility
    "swaync"                  # Notification daemon
    "wofi"                    # Application & session launcher
    "grim"                    # Wayland screenshot tool
    "slurp"                   # Wayland screen region selector
    "wl-clipboard"            # Wayland clipboard utilities (wl-copy / wl-paste)
    "cliphist"                # Clipboard history daemon
    "wtype"                   # Wayland virtual keystroke tool (workspace switching)
    "playerctl"               # Media control CLI
    "alacritty"               # Terminal emulator
    "libnotify"               # Desktop notification sender (notify-send)
)

FONTS=(
    "ttf-jetbrains-mono-nerd"
    "ttf-firacode-nerd"
    "ttf-material-icons"
    "noto-fonts"
    "noto-fonts-emoji"
    "noto-fonts-extra"
    "ttf-dejavu"
)

HARDWARE_AND_AUDIO=(
    "pipewire"
    "wireplumber"
    "pipewire-pulse"
    "pipewire-alsa"
    "networkmanager"
    "bluez"
    "bluez-utils"
)

# --- Development & Embedded Ecosystem ---
EMBEDDED_DEV_TOOLS=(
    "arm-none-eabi-gcc"       # Cross-compiler for ARM Cortex-M/R bare metal
    "arm-none-eabi-binutils"  # Linker and assembler for ARM EABI
    "arm-none-eabi-gdb"       # GDB debugger for ARM
    "arm-none-eabi-newlib"    # C library for bare-metal ARM systems
    "stlink"                  # STM32 programming & debug toolset (st-flash, st-util)
    "openocd"                 # Open On-Chip Debugger (JTAG/SWD)
    "dfu-util"                # Device Firmware Upgrade (USB flashing)
    "platformio-core"         # PlatformIO IoT/embedded ecosystem CLI
)

EDA_AND_HARDWARE=(
    "kicad"                   # Schematic and PCB design suite
    "kicad-library"           # Symbols, footprints, and template libraries
    "kicad-library-3d"        # 3D models for components
)

PRODUCTIVITY_AND_MEDIA=(
    "okular"                  # KDE / Qt document and PDF viewer
    "libreoffice-fresh"       # LibreOffice productivity suite
    "gwenview"                # KDE / Qt image viewer
    "vlc"                     # Multimedia player
)

# ------------------------------------------------------------------------------
# 4. Install Selected Official Packages (Pacman)
# ------------------------------------------------------------------------------
PACMAN_INSTALL_LIST=()

if [[ "$MODE" == "core" || "$MODE" == "all" ]]; then
    PACMAN_INSTALL_LIST+=(
        "${CORE_BUILD_TOOLS[@]}"
        "${CORE_USER_APPS[@]}"
        "${QT_FILE_MANAGEMENT[@]}"
        "${COMPOSITOR_AND_DM[@]}"
        "${QT_WAYLAND_THEMING[@]}"
        "${SHELL_UTILS[@]}"
        "${FONTS[@]}"
        "${HARDWARE_AND_AUDIO[@]}"
    )
fi

if [[ "$MODE" == "dev" || "$MODE" == "all" ]]; then
    PACMAN_INSTALL_LIST+=(
        "${EMBEDDED_DEV_TOOLS[@]}"
        "${EDA_AND_HARDWARE[@]}"
        "${PRODUCTIVITY_AND_MEDIA[@]}"
    )
fi

log_info "Installing official packages via pacman..."
sudo pacman -S --needed --noconfirm "${PACMAN_INSTALL_LIST[@]}"
log_success "Official repository packages installed."

# ------------------------------------------------------------------------------
# 5. AUR Packages & JetBrains Integration
# ------------------------------------------------------------------------------
log_info "Installing AUR packages and configuring developer tools..."

AUR_INSTALL_LIST=()

if [[ "$MODE" == "core" || "$MODE" == "all" ]]; then
    AUR_INSTALL_LIST+=(
        "code-marketplace"        # Enable official VS Code Marketplace in code
        "opentabletdriver"        # Open-source tablet driver
        "waypaper"                # GUI wallpaper manager
        "labwc-menu-generator-git"# Dynamic desktop menu generator for labwc
        "labwc-tweaks-git"        # GUI configuration tool for labwc
    )
fi

# CLion setup (Toolbox check with AUR fallback)
TOOLBOX_CLION="$HOME/.local/share/JetBrains/Toolbox/apps/clion/bin/clion"
if [ -f "$TOOLBOX_CLION" ]; then
    log_step "Found JetBrains Toolbox CLion at $TOOLBOX_CLION"
    mkdir -p "$HOME/.local/bin"
    ln -sf "$TOOLBOX_CLION" "$HOME/.local/bin/clion"
    log_success "Linked CLion binary to ~/.local/bin/clion"
elif command -v clion >/dev/null 2>&1; then
    log_success "CLion is already installed: $(command -v clion)"
elif [[ "$MODE" == "dev" || "$MODE" == "all" ]]; then
    log_step "Adding CLion to AUR installation list..."
    AUR_INSTALL_LIST+=("clion" "clion-jre")
fi

if [ ${#AUR_INSTALL_LIST[@]} -gt 0 ]; then
    yay -S --needed --noconfirm "${AUR_INSTALL_LIST[@]}"
    log_success "AUR packages installed."
fi

# ------------------------------------------------------------------------------
# 6. Service Configuration
# ------------------------------------------------------------------------------
log_info "Configuring essential services..."

# OpenTabletDriver systemd user daemon
if systemctl --user list-unit-files opentabletdriver.service >/dev/null 2>&1; then
    systemctl --user enable opentabletdriver.service 2>/dev/null || true
    log_success "OpenTabletDriver user service enabled."
fi

# NetworkManager & Bluetooth
sudo systemctl enable NetworkManager.service 2>/dev/null || true
sudo systemctl enable bluetooth.service 2>/dev/null || true
log_success "NetworkManager and Bluetooth system services enabled."

# SDDM Display Manager
if ! systemctl is-enabled sddm.service >/dev/null 2>&1; then
    read -rp "Do you want to enable SDDM as your display manager? [y/N]: " enable_sddm
    if [[ "$enable_sddm" =~ ^[Yy]$ ]]; then
        sudo systemctl enable sddm.service
        log_success "SDDM display manager enabled."
    fi
fi

# ------------------------------------------------------------------------------
# 7. Eww (ElKowar's Wacky Widgets) Status Check
# ------------------------------------------------------------------------------
log_info "Checking Eww status bar..."
if command -v eww >/dev/null 2>&1; then
    log_success "Eww is installed: $(command -v eww)"
else
    log_warn "Eww binary not found in PATH."
    log_step "To build Eww with Wayland support:"
    log_step "  sudo pacman -S --needed gtk-layer-shell rust"
    log_step "  git clone https://github.com/elkowar/eww && cd eww"
    log_step "  cargo build --release --no-default-features --features=wayland"
    log_step "  install -Dm755 target/release/eww ~/.local/bin/eww"
fi

# ------------------------------------------------------------------------------
# 8. Completed
# ------------------------------------------------------------------------------
echo ""
log_info "Installation process complete!"
log_step "Note: Redundant GTK suites (gdm, gtklock, greetd, nwg-look, gnome-control-center) were excluded."
log_step "Next step: Run './install.sh' to link and configure your dotfiles."
