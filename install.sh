#!/usr/bin/env bash
# ==============================================================================
#  Zafirre Arch Customization - 1-Click Auto Installer
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOME_DIR="$HOME"

echo "=========================================================="
echo " 🌌 Deploying Zafirre Arch Customization Setup"
echo "=========================================================="

# 1. Install packages from pkglist.txt if pacman is present
if command -v pacman &>/dev/null; then
    echo "==> [1/5] Installing core packages from pkglist.txt..."
    sudo pacman -S --needed --noconfirm - < "$DOTFILES_DIR/pkglist.txt" || echo "Some packages skipped."
fi

# 2. Copy .config directories
echo "==> [2/5] Deploying .config files..."
mkdir -p "$HOME_DIR/.config"
for dir in "$DOTFILES_DIR/.config"/*; do
    if [ -d "$dir" ] || [ -f "$dir" ]; then
        base="$(basename "$dir")"
        echo " -> Restoring .config/$base"
        cp -rf "$dir" "$HOME_DIR/.config/"
    fi
done

# 3. Copy .local/bin scripts
echo "==> [3/5] Deploying custom helper scripts to ~/.local/bin..."
mkdir -p "$HOME_DIR/.local/bin"
if [ -d "$DOTFILES_DIR/.local/bin" ]; then
    cp -rf "$DOTFILES_DIR/.local/bin"/* "$HOME_DIR/.local/bin/"
    chmod +x "$HOME_DIR/.local/bin"/* 2>/dev/null || true
fi

# 4. Copy Wallpapers
echo "==> [4/5] Restoring Wallpapers to ~/Downloads/Wallpaper..."
mkdir -p "$HOME_DIR/Downloads/Wallpaper"
if [ -d "$DOTFILES_DIR/wallpapers" ]; then
    cp -rf "$DOTFILES_DIR/wallpapers"/* "$HOME_DIR/Downloads/Wallpaper/"
fi

# 5. Refresh Shell
echo "==> [5/5] Refreshing Fish shell functions & permissions..."
if command -v fish &>/dev/null; then
    fish -c "source ~/.config/fish/config.fish" 2>/dev/null || true
fi

echo "=========================================================="
echo " SUCCESS! Zafirre Arch Customization fully deployed!"
echo " Restart your session or run 'hyprctl reload' to enjoy."
echo "=========================================================="
