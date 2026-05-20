#!/usr/bin/env bash
# Shared helpers for install scripts. Source this from each step.

set -euo pipefail

# ---- Colors / logging -------------------------------------------------------
if [[ -t 1 ]]; then
  readonly C_RESET=$'\033[0m'
  readonly C_BOLD=$'\033[1m'
  readonly C_DIM=$'\033[2m'
  readonly C_RED=$'\033[31m'
  readonly C_GREEN=$'\033[32m'
  readonly C_YELLOW=$'\033[33m'
  readonly C_BLUE=$'\033[34m'
  readonly C_CYAN=$'\033[36m'
else
  readonly C_RESET="" C_BOLD="" C_DIM="" C_RED="" C_GREEN="" C_YELLOW="" C_BLUE="" C_CYAN=""
fi

log()   { printf "%s\n" "${C_DIM}$*${C_RESET}"; }
info()  { printf "%s\n" "${C_BLUE}ℹ${C_RESET}  $*"; }
ok()    { printf "%s\n" "${C_GREEN}✓${C_RESET}  $*"; }
warn()  { printf "%s\n" "${C_YELLOW}⚠${C_RESET}  $*"; }
err()   { printf "%s\n" "${C_RED}✗${C_RESET}  $*" >&2; }
step()  { printf "\n%s\n" "${C_BOLD}${C_CYAN}▸ $*${C_RESET}"; }

# ---- Paths ------------------------------------------------------------------
# REPO_ROOT is the absolute path to the config repo (one level above scripts/).
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
export REPO_ROOT

BACKUP_DIR="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
export BACKUP_DIR

# ---- Capability checks ------------------------------------------------------
has()         { command -v "$1" >/dev/null 2>&1; }
is_macos()    { [[ "$(uname -s)" == "Darwin" ]]; }
is_apple_si() { [[ "$(uname -m)" == "arm64" ]]; }

require_macos() {
  if ! is_macos; then
    err "This script only supports macOS."
    exit 1
  fi
}

# ---- Symlink with backup ----------------------------------------------------
# Usage: link_file <source-in-repo> <destination-in-home>
# - If destination is already the correct symlink, no-ops.
# - If destination exists as anything else, moves it to $BACKUP_DIR before linking.
link_file() {
  local src="$1" dst="$2"

  if [[ ! -e "$src" ]]; then
    err "Source does not exist: $src"
    return 1
  fi

  mkdir -p "$(dirname "$dst")"

  if [[ -L "$dst" ]]; then
    local current
    current="$(readlink "$dst")"
    if [[ "$current" == "$src" ]]; then
      ok "Already linked: ${dst/#$HOME/~}"
      return 0
    fi
    warn "Replacing symlink: ${dst/#$HOME/~} (was → $current)"
    rm "$dst"
  elif [[ -e "$dst" ]]; then
    mkdir -p "$BACKUP_DIR"
    local backup_path="$BACKUP_DIR/$(basename "$dst")"
    warn "Backing up existing ${dst/#$HOME/~} → ${backup_path/#$HOME/~}"
    mv "$dst" "$backup_path"
  fi

  ln -s "$src" "$dst"
  ok "Linked: ${dst/#$HOME/~} → ${src/#$HOME/~}"
}