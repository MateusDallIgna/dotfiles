#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"
ZSH_SCRIPT="$HOME/.local/share/scripts/zsh.sh"
GPG_WRAPPER=""

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${CYAN}[i]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

cleanup() {
    [[ -n "$GPG_WRAPPER" && -f "$GPG_WRAPPER" ]] && rm -f "$GPG_WRAPPER"
}
trap cleanup EXIT

info "Starting automated installation..."
echo ""

# ---------------------------------------------------------------------------
# 1. Yay - AUR helper
# ---------------------------------------------------------------------------
install_yay() {
    if command -v yay &>/dev/null; then
        log "yay already installed"
        return
    fi

    info "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    log "yay installed"
}
install_yay

# ---------------------------------------------------------------------------
# 2. Install packages
# ---------------------------------------------------------------------------
if [ ! -f "$PACKAGES_FILE" ]; then
    err "Package list not found at $PACKAGES_FILE"
    exit 1
fi

package_count=$(wc -l < "$PACKAGES_FILE")
info "Installing $package_count packages..."

# Create a GPG wrapper that skips --recv-keys.
# Some AUR packages require PGP keys that aren't available on public keyservers.
# PGP verification is handled separately via --mflags "--skippgpcheck" in makepkg.
GPG_WRAPPER=$(mktemp)
cat > "$GPG_WRAPPER" << 'WRAPPER'
#!/bin/bash
[[ "$*" == *--recv-keys* ]] && exit 0
exec /usr/bin/gpg "$@"
WRAPPER
chmod +x "$GPG_WRAPPER"

yay -S --needed --noconfirm \
    --answerdiff None \
    --answerclean None \
    --answeredit None \
    --answerupgrade None \
    --mflags "--skippgpcheck" \
    --gpg "$GPG_WRAPPER" \
    - < "$PACKAGES_FILE"
log "Packages installed"

# ---------------------------------------------------------------------------
# 3. Flatpak
# ---------------------------------------------------------------------------
if command -v flatpak &>/dev/null; then
    info "Configuring Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    log "Flatpak configured"
fi

# ---------------------------------------------------------------------------
# 4. Enable system services
# ---------------------------------------------------------------------------
info "Enabling system services..."

enable_service() {
    local svc="$1"
    if systemctl list-unit-files "$svc" &>/dev/null; then
        if sudo systemctl enable --now "$svc" 2>/dev/null; then
            log "$svc enabled"
        else
            warn "Failed to enable $svc"
        fi
    else
        warn "Service $svc not found, skipping"
    fi
}

enable_user_service() {
    local svc="$1"
    if systemctl --user list-unit-files "$svc" &>/dev/null; then
        if systemctl --user enable --now "$svc" 2>/dev/null; then
            log "$svc enabled"
        else
            warn "Failed to enable $svc"
        fi
    else
        warn "Service $svc not found, skipping"
    fi
}

SYSTEM_SERVICES=(
    "NetworkManager.service"
    "bluetooth.service"
    "sshd.service"
    "sddm.service"
    "firewalld.service"
    "reflector.timer"
    "pkgfile-update.timer"
)

for svc in "${SYSTEM_SERVICES[@]}"; do
    enable_service "$svc"
done

USER_SERVICES=(
    "pipewire.service"
    "pipewire-pulse.socket"
    "wireplumber.service"
)

for svc in "${USER_SERVICES[@]}"; do
    enable_user_service "$svc"
done

log "Services configured"

# ---------------------------------------------------------------------------
# 5. v4l2loopback - auto-load at boot with exclusive_caps for Chromium
# ---------------------------------------------------------------------------
info "Configuring v4l2loopback..."

V4L2LOOPBACK_CONF="/etc/modprobe.d/v4l2loopback.conf"
if [ ! -f "$V4L2LOOPBACK_CONF" ]; then
    echo 'options v4l2loopback exclusive_caps=1 devices=1 video_nr=0 card_label="OBS Virtual Camera" max_buffers=2' | \
        sudo tee "$V4L2LOOPBACK_CONF" > /dev/null
    log "Created $V4L2LOOPBACK_CONF"
fi

V4L2LOOPBACK_LOAD="/etc/modules-load.d/v4l2loopback.conf"
if [ ! -f "$V4L2LOOPBACK_LOAD" ]; then
    echo "v4l2loopback" | sudo tee "$V4L2LOOPBACK_LOAD" > /dev/null
    log "Created $V4L2LOOPBACK_LOAD"
fi

if ! lsmod | grep -q v4l2loopback; then
    sudo modprobe v4l2loopback
    log "Loaded v4l2loopback module"
fi

log "v4l2loopback configured"

# ---------------------------------------------------------------------------
# 6. SDDM login theme
# ---------------------------------------------------------------------------
if [ -d "$SDDM_THEME_DIR" ]; then
    info "Configuring SDDM..."

    sudo mkdir -p "$SDDM_THEME_DIR/Themes"

    if [ -f "$DOTFILES_DIR/sddm/custom.conf" ]; then
        sudo cp "$DOTFILES_DIR/sddm/custom.conf" "$SDDM_THEME_DIR/Themes/custom.conf"
        sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/custom.conf|' "$SDDM_THEME_DIR/metadata.desktop"
    fi

    CURRENT_SDDM=$(grep -oP 'Current=\K.*' /etc/sddm.conf 2>/dev/null || echo "")
    if [ "$CURRENT_SDDM" != "sddm-astronaut-theme" ]; then
        echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf >/dev/null
    fi

    log "SDDM configured with sddm-astronaut-theme"
else
    warn "sddm-astronaut-theme not found, skipping SDDM configuration"
fi

# ---------------------------------------------------------------------------
# 7. Stow - dotfile symlinks
# ---------------------------------------------------------------------------
if ! command -v stow &>/dev/null; then
    info "Installing stow..."
    yay -S --noconfirm stow
fi

info "Running stow..."
cd "$DOTFILES_DIR"

STOW_DIRS=()
for dir in */; do
    dir="${dir%/}"
    case "$dir" in
        .git|sddm) continue ;;
    esac
    STOW_DIRS+=("$dir")
done

for dir in "${STOW_DIRS[@]}"; do
    if stow --restow "$dir" 2>/dev/null; then
        log "stow: $dir"
    else
        warn "stow: $dir failed"
    fi
done

for f in .gitignore install.sh packages.txt; do
    if [ -f "$DOTFILES_DIR/$f" ]; then
        target="$HOME/$f"
        if [ ! -L "$target" ] && [ ! -e "$target" ]; then
            ln -sf "$DOTFILES_DIR/$f" "$target" 2>/dev/null || true
        fi
    fi
done

log "Stow complete"

# ---------------------------------------------------------------------------
# 8. Zsh setup (oh-my-zsh, plugins, shell change)
# ---------------------------------------------------------------------------
if [ -x "$ZSH_SCRIPT" ]; then
    info "Configuring Zsh..."
    bash "$ZSH_SCRIPT"
    log "Zsh configured"
elif [ -f "$ZSH_SCRIPT" ]; then
    warn "Zsh setup script at $ZSH_SCRIPT is not executable, skipping"
else
    warn "Zsh setup script not found at $ZSH_SCRIPT, skipping"
fi

# ---------------------------------------------------------------------------
# 9. Final setup
# ---------------------------------------------------------------------------
if [ -f "$HOME/.config/hypr/hyprland.lua" ]; then
    info "Removing default Hyprland Lua config..."
    rm "$HOME/.config/hypr/hyprland.lua"
    log "Removed hyprland.lua"
fi

info "Updating XDG user directories..."
xdg-user-dirs-update
log "XDG user directories updated"

# ---------------------------------------------------------------------------
# 10. Summary
# ---------------------------------------------------------------------------
echo ""
log "============================================"
log "  Installation complete!"
log "============================================"
echo -e "  ${CYAN}Packages:${NC} $package_count"
echo -e "  ${CYAN}SDDM:${NC} sddm-astronaut-theme"
echo -e "  ${CYAN}Note:${NC} Reboot to apply the login theme"
echo ""
