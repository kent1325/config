#!/usr/bin/env bash
# Symlink Neovim config and create supporting directories.
# Plugins are managed by Neovim's built-in `vim.pack` (introduced in 0.12),
# so there's no plugin manager to bootstrap here — `nvim` will fetch plugins
# itself on first launch.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "Neovim"

# ---- Verify nvim is installed (Brewfile pulls it in) -----------------------
if ! has nvim; then
  err "nvim not found. Did the brew step run? Try: ./install.sh brew"
  exit 1
fi

# vim.pack requires Neovim ≥ 0.12. Bail early with a clear message if not.
if ! nvim --headless -c 'lua if vim.fn.has("nvim-0.12") ~= 1 then vim.cmd("cq") end' -c quit 2>/dev/null; then
  err "Neovim ≥ 0.12 is required (found: $(nvim --version | head -1))."
  err "Update with: brew upgrade neovim"
  exit 1
fi
ok "nvim $(nvim --version | head -1 | awk '{print $2}') (vim.pack supported)"

# ---- Symlink the config ----------------------------------------------------
link_file "$REPO_ROOT/neovim/init.lua"  "$HOME/.config/nvim/init.lua"

# ---- Supporting directories ------------------------------------------------
# init.lua sets `undofile = true` with undodir at ~/.vim/undodir — make sure
# that path exists so the very first edit doesn't error out.
UNDODIR="$HOME/.vim/undodir"
if [[ -d "$UNDODIR" ]]; then
  ok "Undo dir exists: ${UNDODIR/#$HOME/~}"
else
  mkdir -p "$UNDODIR"
  ok "Created undo dir: ${UNDODIR/#$HOME/~}"
fi

if [[ -d "${BACKUP_DIR:-}" ]]; then
  info "Originals backed up to: ${BACKUP_DIR/#$HOME/~}"
fi

ok "Neovim step complete. Run 'nvim' — plugins install on first launch."
