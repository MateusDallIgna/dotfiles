#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
PACKAGES_FILE="$DOTFILES_DIR/packages.txt"
SDDM_THEME_DIR="/usr/share/sddm/themes/sddm-astronaut-theme"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()  { echo -e "${GREEN}[✓]${NC} $1"; }
warn() { echo -e "${YELLOW}[!]${NC} $1"; }
info() { echo -e "${CYAN}[i]${NC} $1"; }
err()  { echo -e "${RED}[✗]${NC} $1"; }

info "Iniciando instalacao automatica..."
echo ""

# ---------------------------------------------------------------------------
# 1. Yay (AUR helper)
# ---------------------------------------------------------------------------
if ! command -v yay &>/dev/null; then
    info "Instalando yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd "$DOTFILES_DIR"
    log "yay instalado"
else
    log "yay ja instalado"
fi

# ---------------------------------------------------------------------------
# 2. Instalar todos os pacotes
# ---------------------------------------------------------------------------
if [ ! -f "$PACKAGES_FILE" ]; then
    err "Arquivo $PACKAGES_FILE nao encontrado"
    exit 1
fi

info "Instalando pacotes ($(wc -l < "$PACKAGES_FILE") packages)..."
yay -S --needed --noconfirm - < "$PACKAGES_FILE"
log "Pacotes instalados"

# ---------------------------------------------------------------------------
# 3. Flatpak (Flathub)
# ---------------------------------------------------------------------------
if command -v flatpak &>/dev/null; then
    info "Configurando Flatpak..."
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    log "Flatpak configurado"
fi

# ---------------------------------------------------------------------------
# 4. Servicos do sistema
# ---------------------------------------------------------------------------
info "Habilitando servicos do sistema..."

SERVICES_SYSTEM=(
    "NetworkManager.service"
    "bluetooth.service"
    "sshd.service"
    "sddm.service"
    "firewalld.service"
    "reflector.timer"
    "pkgfile-update.timer"
)

for svc in "${SERVICES_SYSTEM[@]}"; do
    if systemctl list-unit-files "$svc" &>/dev/null; then
        sudo systemctl enable --now "$svc" 2>/dev/null && log "$svc ativado" || warn "$svc falhou"
    else
        warn "$svc nao encontrado, pulando"
    fi
done

SERVICES_USER=(
    "pipewire.service"
    "pipewire-pulse.socket"
    "wireplumber.service"
)

for svc in "${SERVICES_USER[@]}"; do
    if systemctl --user list-unit-files "$svc" &>/dev/null; then
        systemctl --user enable --now "$svc" 2>/dev/null && log "$svc ativado" || warn "$svc falhou"
    else
        warn "$svc nao encontrado, pulando"
    fi
done

log "Servicos configurados"

# ---------------------------------------------------------------------------
# 5. SDDM - Tela de login
# ---------------------------------------------------------------------------
if [ -d "$SDDM_THEME_DIR" ]; then
    info "Configurando SDDM..."

    sudo mkdir -p "$SDDM_THEME_DIR/Themes"

    # Copia config customizada
    if [ -f "$DOTFILES_DIR/sddm/custom.conf" ]; then
        sudo cp "$DOTFILES_DIR/sddm/custom.conf" "$SDDM_THEME_DIR/Themes/custom.conf"
        sudo sed -i 's|^ConfigFile=.*|ConfigFile=Themes/custom.conf|' "$SDDM_THEME_DIR/metadata.desktop"
    fi

    # Garante /etc/sddm.conf
    CURRENT_SDDM=$(grep -oP 'Current=\K.*' /etc/sddm.conf 2>/dev/null || echo "")
    if [ "$CURRENT_SDDM" != "sddm-astronaut-theme" ]; then
        echo -e "[Theme]\nCurrent=sddm-astronaut-theme" | sudo tee /etc/sddm.conf >/dev/null
    fi

    log "SDDM configurado com sddm-astronaut-theme"
else
    warn "sddm-astronaut-theme nao encontrado, pulando configuracao SDDM"
fi

# ---------------------------------------------------------------------------
# 6. Stow - dotfiles
# ---------------------------------------------------------------------------
if ! command -v stow &>/dev/null; then
    info "Instalando stow..."
    yay -S --noconfirm stow
fi

info "Rodando stow..."
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
    stow --restow "$dir" 2>/dev/null && log "stow: $dir" || warn "stow: $dir falhou"
done

# stow arquivos na raiz (ex: .gitignore, install.sh, packages.txt)
for f in .gitignore install.sh packages.txt; do
    if [ -f "$DOTFILES_DIR/$f" ]; then
        target="$HOME/$f"
        if [ ! -L "$target" ] && [ ! -e "$target" ]; then
            ln -sf "$DOTFILES_DIR/$f" "$target" 2>/dev/null || true
        fi
    fi
done

log "Stow concluido"

# ---------------------------------------------------------------------------
# 7. Final
# ---------------------------------------------------------------------------
echo ""
log "============================================"
log "  Instalacao concluida!"
log "============================================"
echo -e "  ${CYAN}Pacotes:${NC} $(wc -l < "$PACKAGES_FILE")"
echo -e "  ${CYAN}SDDM:${NC} sddm-astronaut-theme"
echo -e "  ${CYAN}Dica:${NC} Reboot para aplicar a tela de login"
echo ""
