#!/usr/bin/env bash
# ==============================================================================
#  Zafirre Arch Customization - 1-Click Complete System & Hyprland Auto Installer
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "=========================================================="
echo " 🌌 Deploying Zafirre Arch Customization & Hyprland Environment"
echo "=========================================================="

# 1. Check & Install Core System Dependencies + Hyprland via Pacman
if command -v pacman &>/dev/null; then
    echo "==> [1/6] Installing Hyprland & official Arch packages from pkglist.txt..."
    sudo pacman -S --needed --noconfirm base-devel git hyprland waybar kitty fish rofi swaync fastfetch polkit-kde-agent xdg-desktop-portal-hyprland pipewire wireplumber papirus-icon-theme || true
    
    if [ -f "$DOTFILES_DIR/pkglist.txt" ]; then
        echo " -> Installing full native package list..."
        sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist.txt" 2>/dev/null || echo "Some optional native packages skipped."
    fi
fi

# 2. Check & Install yay (AUR Helper) if not present
echo "==> [2/6] Checking AUR Helper (yay)..."
if ! command -v yay &>/dev/null; then
    echo " -> Installing yay from AUR..."
    tmp_yay="/tmp/yay-installer"
    rm -rf "$tmp_yay"
    git clone https://aur.archlinux.org/yay.git "$tmp_yay"
    (cd "$tmp_yay" && makepkg -si --noconfirm)
    rm -rf "$tmp_yay"
fi

# 3. Install AUR Packages
if [ -f "$DOTFILES_DIR/aurpkglist.txt" ]; then
    echo "==> [3/6] Installing AUR packages (waypaper, wlogout, animfetch-bin, etc)..."
    yay -S --needed --noconfirm - < "$DOTFILES_DIR/aurpkglist.txt" 2>/dev/null || echo "Some optional AUR packages skipped."
fi

# 4. Copy .config directories
echo "==> [4/6] Restoring .config files (Hyprland, Waybar, Kitty, Fish, SwayNC, etc)..."
mkdir -p "$HOME_DIR/.config"
for dir in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$dir" ] || [ -f "$dir" ]; then
        base="$(basename "$dir")"
        echo " -> Restoring .config/$base"
        cp -rf "$dir" "$HOME_DIR/.config/"
    fi
done

# 5. Copy .local/bin scripts & Wallpapers
echo "==> [5/6] Restoring custom scripts (~/.local/bin) & Wallpapers (~/Downloads/Wallpaper)..."
mkdir -p "$HOME_DIR/.local/bin"
if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    cp -rf "$DOTFILES_DIR/.local/bin"/* "$HOME_DIR/.local/bin/"
    chmod +x "$HOME_DIR/.local/bin"/* 2>/dev/null || true
fi

mkdir -p "$HOME_DIR/Downloads/Wallpaper"
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
    cp -rf "$DOTFILES_DIR/wallpapers"/* "$HOME_DIR/Downloads/Wallpaper/"
fi

# 6. Shell & System Services Setup
echo "==> [6/6] Setting up default shell & permissions..."
if command -v fish &>/dev/null; then
    echo " -> Setting Fish as default shell..."
    chsh -s "$(which fish)" "$USER" 2>/dev/null || true
    fish -c "source ~/.config/fish/config.fish" 2>/dev/null || true
fi

echo "=========================================================="
echo " 🎉 SUCCESS! Hyprland & Zafirre Arch Customization fully deployed!"
echo " Log out and choose 'Hyprland' from your display manager."
echo "=========================================================="
