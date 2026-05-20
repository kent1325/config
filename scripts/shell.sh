#!/usr/bin/env bash
# Shell setup: verify oh-my-posh + zsh plugins are present (installed by Brewfile),
# and ensure zsh is the default login shell.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "Shell (zsh + oh-my-posh)"

# ---- Verify oh-my-posh -----------------------------------------------------
if has oh-my-posh; then
  ok "oh-my-posh installed ($(oh-my-posh --version))"
else
  err "oh-my-posh not found. Did the brew step run? Try: ./install.sh brew"
  exit 1
fi

# ---- Verify zsh plugins (installed via Homebrew) ---------------------------
for pkg in zsh-autosuggestions zsh-syntax-highlighting; do
  share="$(brew --prefix)/share/$pkg/$pkg.zsh"
  if [[ -f "$share" ]]; then
    ok "$pkg present"
  else
    warn "$pkg not found at $share — Brewfile may not have run"
  fi
done

# ---- Make zsh the default login shell --------------------------------------
ZSH_PATH="$(command -v zsh)"
if [[ "${SHELL:-}" == "$ZSH_PATH" ]]; then
  ok "zsh is already your default shell"
else
  info "Setting zsh as your default login shell (you may be prompted for your password)…"
  if ! grep -qx "$ZSH_PATH" /etc/shells; then
    echo "$ZSH_PATH" | sudo tee -a /etc/shells >/dev/null
  fi
  chsh -s "$ZSH_PATH" || warn "Could not chsh automatically — run 'chsh -s $ZSH_PATH' manually."
fi

ok "Shell step complete. Open a new terminal to see the oh-my-posh prompt."