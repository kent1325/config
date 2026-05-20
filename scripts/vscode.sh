#!/usr/bin/env bash
# Symlink VS Code user settings + keybindings.
# Extensions are installed by the Brewfile (`vscode "…"` entries), so no work needed here.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "VS Code settings"

VSCODE_USER_DIR="$HOME/Library/Application Support/Code/User"

if [[ ! -d "$HOME/Library/Application Support/Code" ]]; then
  warn "VS Code support directory not found. Launch VS Code once, then re-run this step."
  warn "Skipping."
  exit 0
fi

mkdir -p "$VSCODE_USER_DIR"

link_file "$REPO_ROOT/vscode/settings.json"           "$VSCODE_USER_DIR/settings.json"
link_file "$REPO_ROOT/vscode/keybindings(mac).json"   "$VSCODE_USER_DIR/keybindings.json"

ok "VS Code step complete."