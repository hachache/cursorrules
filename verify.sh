#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="${1:-$HOME/Documents}"
EXIT_CODE=0

green() { printf '\033[1;32m%s\033[0m' "$*"; }
red()   { printf '\033[1;31m%s\033[0m' "$*"; }
gray()  { printf '\033[2m%s\033[0m' "$*"; }

check_link() {
  local target="$1" expected="$2"
  printf '  %-45s ' "$target"
  if [[ ! -L "$target" ]]; then
    red "MISSING"; printf '\n'
    EXIT_CODE=1
    return
  fi
  local current
  current="$(readlink "$target")"
  if [[ "$current" == "$expected" ]]; then
    green "OK"; gray "  -> $expected"; printf '\n'
  else
    red "WRONG"; gray " -> $current (expected $expected)"; printf '\n'
    EXIT_CODE=1
  fi
}

count_glob() {
  local pattern="$1" label="$2" expected="$3"
  shopt -s nullglob
  local found=( $pattern )
  shopt -u nullglob
  printf '  %-45s ' "$label"
  if [[ ${#found[@]} -ge $expected ]]; then
    green "OK"; gray "  (${#found[@]} files)"; printf '\n'
  else
    red "MISSING"; gray " (${#found[@]} found, expected >= $expected)"; printf '\n'
    EXIT_CODE=1
  fi
}

printf '\nSymlinks\n'
check_link "$HOME/.cursor/agents"          "$REPO_ROOT/agents"
check_link "$WORKSPACE/.cursor/rules"      "$REPO_ROOT/rules"
check_link "$WORKSPACE/AGENTS.md"          "$REPO_ROOT/AGENTS.md"

printf '\nContent\n'
count_glob "$REPO_ROOT/agents/*.md"  "agents/*.md"                       11
count_glob "$REPO_ROOT/rules/*.mdc"  "rules/*.mdc"                       18

printf '\nGit\n'
printf '  %-45s ' "remote"
if (cd "$REPO_ROOT" && git remote get-url origin >/dev/null 2>&1); then
  green "OK"; gray "  $(cd "$REPO_ROOT" && git remote get-url origin)"; printf '\n'
else
  red "MISSING"; printf '\n'; EXIT_CODE=1
fi

printf '\n'
[[ $EXIT_CODE -eq 0 ]] && green "All checks passed." || red "Some checks failed."
printf '\n'
exit $EXIT_CODE
