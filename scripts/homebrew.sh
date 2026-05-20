#!/usr/bin/env bash
# Install Homebrew (if missing) and run the Brewfile.
# Idempotent — re-running only installs what's missing.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "Homebrew"

if has brew; then
  ok "Homebrew already installed ($(brew --version | head -1))"
else
  info "Installing Homebrew…"
  NONINTERACTIVE=1 /bin/bash -c \
    "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make `brew` available in this shell session (path differs on Intel vs Apple Silicon).
if is_apple_si && [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

info "Updating Homebrew…"
brew update

info "Installing from Brewfile (brews + casks + VS Code extensions)…"
brew bundle --file="$REPO_ROOT/brew/Brewfile"

ok "Homebrew step complete."