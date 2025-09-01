### Neovim setup

This directory contains a complete Neovim configuration.

Quick start:

1. Run the installer:
   - macOS/Linux:
     - `./install.sh`
     - `NVIM_APPNAME=nvim nvim --headless "+Lazy! sync" +qa`

What the installer does:

- Removes any existing Neovim config/cache/data folders
- Symlinks this folder to `~/.config/nvim`
- On first launch, plugins install automatically
