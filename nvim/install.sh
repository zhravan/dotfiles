#!/usr/bin/env bash
set -euo pipefail

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

echo "Done. Launch Neovim to install plugins automatically."


