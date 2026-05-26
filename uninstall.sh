#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="${1:-$HOME/Documents}"

log() { printf '\033[1;34m[uninstall]\033[0m %s\n' "$*"; }
warn(){ printf '\033[1;33m[uninstall]\033[0m %s\n' "$*" >&2; }

remove_if_links_here() {
  local target="$1" expected="$2"
  if [[ -L "$target" ]] && [[ "$(readlink "$target")" == "$expected" ]]; then
    log "remove    $target"
    rm -f "$target"
  else
    warn "skip      $target (not a symlink to this repo)"
  fi
}

remove_if_links_here "$HOME/.cursor/agents"     "$REPO_ROOT/agents"
remove_if_links_here "$WORKSPACE/.cursor/rules" "$REPO_ROOT/rules"
remove_if_links_here "$WORKSPACE/AGENTS.md"     "$REPO_ROOT/AGENTS.md"

log "done. Backups created by install.sh remain in ~/.cursor/.cursorrules-backup-*"
