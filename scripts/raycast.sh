#!/usr/bin/env bash
# Import the most recent Raycast config export.
# Raycast doesn't support a "settings file at fixed path" model — its config
# is stored internally — so we just hand the .rayconfig file to Raycast and
# let the user confirm the merge prompt. Idempotent in the sense that
# re-running just re-opens the prompt; nothing is duplicated.

set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib.sh"
require_macos

step "Raycast"

if [[ ! -d "/Applications/Raycast.app" ]]; then
  warn "Raycast.app not found. The Brewfile will install it — run this step after."
  exit 0
fi

# Pick the newest .rayconfig in the repo's raycast/ folder.
shopt -s nullglob
configs=("$REPO_ROOT/raycast/"*.rayconfig)
shopt -u nullglob

if [[ ${#configs[@]} -eq 0 ]]; then
  warn "No .rayconfig file found in $REPO_ROOT/raycast — nothing to import."
  exit 0
fi

# Sort by mtime so newest wins when there are several.
latest="$(printf '%s\n' "${configs[@]}" | xargs -I{} stat -f '%m %N' {} | sort -nr | head -1 | cut -d' ' -f2-)"

info "Opening: $(basename "$latest")"
open -a Raycast "$latest"
ok "Raycast launched. Confirm the import in the Raycast prompt that just appeared."