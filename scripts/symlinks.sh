#!/usr/bin/env bash
# Symlink dotfiles from the repo into $HOME (with timestamped backups).
# Idempotent — re-running skips already-correct links and backs up anything else.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "Symlinking dotfiles"

# zsh
link_file "$REPO_ROOT/zsh/.zshrc"               "$HOME/.zshrc"
link_file "$REPO_ROOT/starship/starship.toml"   "$HOME/.config/starship.toml"

# Optional previous oh-my-posh theme config — uncomment to switch back.
# link_file "$REPO_ROOT/zsh/.ZSHThemes.json"    "$HOME/.ZSHThemes.json"

# git
link_file "$REPO_ROOT/git/.gitconfig"      "$HOME/.gitconfig"

# ghostty (XDG config location)
link_file "$REPO_ROOT/ghostty/config"      "$HOME/.config/ghostty/config"

# Add more dotfiles here as you grow the repo. Examples:
# link_file "$REPO_ROOT/tmux/.tmux.conf"   "$HOME/.tmux.conf"

if [[ -d "${BACKUP_DIR:-}" ]]; then
  info "Originals backed up to: ${BACKUP_DIR/#$HOME/~}"
fi

ok "Symlinks step complete."