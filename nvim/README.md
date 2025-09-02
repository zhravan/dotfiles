### Neovim setup

This directory contains a complete Neovim configuration.

Quick start:

1. Install prerequisites and set up Neovim config (macOS & Linux):
   - From the repo root: `./nvim/install.sh`
   - Or inside this folder: `./install.sh`
   - This installs Neovim and common tools, links the config, and bootstraps plugins headlessly.

What the installer does:

- Installs Neovim and basic CLI tools (git, ripgrep, fd, fzf) using Homebrew (macOS) or your Linux distro's package manager (apt/dnf/pacman/zypper)
- Removes any existing Neovim config/cache/data folders
- Symlinks this folder to `~/.config/nvim`
- Bootstraps plugins headlessly so your first interactive launch is ready
