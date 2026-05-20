#!/usr/bin/env bash
# Bootstrap a new Mac from this config repo.
#
# Usage:
#   ./install.sh                   # run everything in order
#   ./install.sh brew              # run one step
#   ./install.sh symlinks vscode   # run several specific steps
#   ./install.sh --list            # show all steps
#   ./install.sh --help            # this message
#
# Every step is idempotent — safe to re-run any time.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/scripts/lib.sh"

# ---- Step registry (name → script) -----------------------------------------
declare -a STEP_ORDER=(brew shell symlinks neovim vscode raycast)
declare -A STEP_SCRIPTS=(
  [brew]="homebrew.sh"
  [shell]="shell.sh"
  [symlinks]="symlinks.sh"
  [neovim]="neovim.sh"
  [vscode]="vscode.sh"
  [raycast]="raycast.sh"
)

# ---- Usage / list ----------------------------------------------------------
usage() {
  sed -n '2,12p' "$0" | sed 's/^# \{0,1\}//'
}

list_steps() {
  printf "%s\n" "${C_BOLD}Available steps (run in this order with no args):${C_RESET}"
  for name in "${STEP_ORDER[@]}"; do
    printf "  ${C_CYAN}%-10s${C_RESET}  %s\n" "$name" "scripts/${STEP_SCRIPTS[$name]}"
  done
}

case "${1:-}" in
  -h|--help)  usage; exit 0 ;;
  -l|--list)  list_steps; exit 0 ;;
esac

require_macos

# ---- Determine which steps to run ------------------------------------------
if [[ $# -eq 0 ]]; then
  steps_to_run=("${STEP_ORDER[@]}")
else
  steps_to_run=("$@")
  for s in "${steps_to_run[@]}"; do
    if [[ -z "${STEP_SCRIPTS[$s]:-}" ]]; then
      err "Unknown step: $s"
      list_steps
      exit 1
    fi
  done
fi

# ---- Banner ----------------------------------------------------------------
cat <<BANNER

${C_BOLD}${C_CYAN}╭──────────────────────────────────────────╮
│  Mac config bootstrap                    │
│  $(printf '%-40s' "Steps: ${steps_to_run[*]}")│
╰──────────────────────────────────────────╯${C_RESET}

BANNER

# ---- Run each requested step -----------------------------------------------
for name in "${steps_to_run[@]}"; do
  bash "$SCRIPT_DIR/scripts/${STEP_SCRIPTS[$name]}"
done

printf "\n%s\n" "${C_BOLD}${C_GREEN}All done!${C_RESET}"
printf "%s\n" "Open a new terminal window so shell changes take effect."
printf "%s\n" "If apps were just installed by brew, launch them once, then re-run:"
printf "%s\n" "  ${C_DIM}./install.sh vscode raycast${C_RESET}"