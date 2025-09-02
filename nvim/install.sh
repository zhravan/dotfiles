#!/usr/bin/env bash
set -euo pipefail

# Cross-platform bootstrap for Neovim and basic tooling
# - macOS: Homebrew
# - Linux: apt (Debian/Ubuntu), dnf (Fedora/RHEL), pacman (Arch), zypper (openSUSE)

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_linux_pm() {
  if command_exists apt-get; then echo apt; return; fi
  if command_exists dnf; then echo dnf; return; fi
  if command_exists pacman; then echo pacman; return; fi
  if command_exists zypper; then echo zypper; return; fi
  echo unknown
}

install_mac() {
  if ! command_exists brew; then
    echo "Installing Homebrew..."
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -d "/opt/homebrew/bin" ]]; then
      eval "$('/opt/homebrew/bin/brew' shellenv)"
    elif [[ -d "/usr/local/bin" ]]; then
      eval "$('/usr/local/bin/brew' shellenv)"
    fi
  fi
  echo "Installing Neovim and basics via Homebrew..."
  brew update
  brew install neovim git ripgrep fd fzf
}

install_linux() {
  local pm
  pm=$(detect_linux_pm)
  case "$pm" in
    apt)
      sudo apt-get update
      sudo apt-get install -y neovim git ripgrep fd-find fzf curl
      if command_exists fdfind && ! command_exists fd; then
        sudo ln -sf "$(command -v fdfind)" /usr/local/bin/fd || true
      fi
      ;;
    dnf)
      sudo dnf install -y neovim git ripgrep fd-find fzf curl
      ;;
    pacman)
      sudo pacman -Sy --noconfirm neovim git ripgrep fd fzf curl
      ;;
    zypper)
      sudo zypper refresh
      sudo zypper install -y neovim git ripgrep fd fzf curl
      ;;
    *)
      echo "Unsupported or unknown Linux package manager. Please install Neovim manually and re-run."
      exit 1
      ;;
  esac
}

main() {
  local uname_s
  uname_s=$(uname -s)

  case "$uname_s" in
    Darwin)
      install_mac
      ;;
    Linux)
      install_linux
      ;;
    *)
      echo "Unsupported OS: $uname_s"
      exit 1
      ;;
  esac

  echo "Linking Neovim config..."
  CONFIG_SRC="$(cd "$(dirname "$0")" && pwd)"
  NVIM_CONFIG_DIR="$HOME/.config/nvim"
  NVIM_DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
  NVIM_STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
  NVIM_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

  echo "Removing existing Neovim configuration and caches..."
  rm -rf "$NVIM_CONFIG_DIR" "$NVIM_DATA_DIR" "$NVIM_STATE_DIR" "$NVIM_CACHE_DIR"

  mkdir -p "$HOME/.config"

  echo "Linking $CONFIG_SRC to $NVIM_CONFIG_DIR"
  ln -snf "$CONFIG_SRC" "$NVIM_CONFIG_DIR"

  echo "Bootstrapping plugins headlessly..."
  NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa || true

  echo "All set! Launch nvim to finish setup."
}

main "$@"


