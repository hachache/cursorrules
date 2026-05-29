#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="${1:-$HOME/Documents}"
DRY_RUN="${DRY_RUN:-0}"
BACKUP_DIR="$HOME/.cursor/.cursorrules-backup-$(date +%Y%m%d-%H%M%S)"

log()  { printf '\033[1;34m[install]\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m[install]\033[0m %s\n' "$*" >&2; }
err()  { printf '\033[1;31m[install]\033[0m %s\n' "$*" >&2; }

usage() {
  cat <<EOF
Usage: ./install.sh [workspace_path]

Symlinks the cursorrules repo into your Cursor configuration paths:
  ~/.cursor/agents           -> $REPO_ROOT/agents
  <workspace>/.cursor/rules  -> $REPO_ROOT/rules
  <workspace>/AGENTS.md      -> $REPO_ROOT/AGENTS.md

Defaults workspace to: \$HOME/Documents
Existing files (not symlinks to this repo) are backed up to: $BACKUP_DIR

Env:
  DRY_RUN=1   print actions without modifying anything
EOF
}

[[ "${1:-}" == "-h" || "${1:-}" == "--help" ]] && { usage; exit 0; }

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '  [dry-run]'; printf ' %q' "$@"; printf '\n'
  else
    "$@"
  fi
}

link() {
  local source="$1" target="$2"

  if [[ ! -e "$source" ]]; then
    err "missing source: $source"
    return 1
  fi

  if [[ -L "$target" ]]; then
    local current
    current="$(readlink "$target")"
    if [[ "$current" == "$source" ]]; then
      log "ok        $target  (already linked)"
      return 0
    fi
    warn "relink    $target  (was -> $current)"
    run rm -f "$target"
  elif [[ -e "$target" ]]; then
    warn "backup    $target  ->  $BACKUP_DIR/$(basename "$target")"
    run mkdir -p "$BACKUP_DIR"
    run mv "$target" "$BACKUP_DIR/$(basename "$target")"
  fi

  run ln -s "$source" "$target"
  [[ "$DRY_RUN" == "1" ]] || log "linked    $target  ->  $source"
}

log "repo:      $REPO_ROOT"
log "workspace: $WORKSPACE"
[[ "$DRY_RUN" == "1" ]] && warn "dry-run mode (no changes will be applied)"

run mkdir -p "$HOME/.cursor"
run mkdir -p "$WORKSPACE/.cursor"

link "$REPO_ROOT/agents"    "$HOME/.cursor/agents"
link "$REPO_ROOT/rules"     "$WORKSPACE/.cursor/rules"
link "$REPO_ROOT/AGENTS.md" "$WORKSPACE/AGENTS.md"

cat <<EOF

Next steps in Cursor Settings:
  1. Models: enable Composer 2.5, GPT-5.5, Claude Opus 4.8, Gemini 3.1 Pro
  2. Agents: Explore + Shell subagents -> composer-2.5
  3. Restart Cursor to ensure rules are reloaded

Verify with: ./verify.sh
EOF
