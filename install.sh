#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKSPACE="${1:-$HOME/Documents}"

mkdir -p "$HOME/.cursor"
mkdir -p "$WORKSPACE/.cursor"

ln -sfn "$REPO_ROOT/agents" "$HOME/.cursor/agents"
ln -sfn "$REPO_ROOT/rules" "$WORKSPACE/.cursor/rules"
ln -sfn "$REPO_ROOT/AGENTS.md" "$WORKSPACE/AGENTS.md"

cat <<EOF
Cursor setup installed from: $REPO_ROOT

  ~/.cursor/agents          -> agents/
  $WORKSPACE/.cursor/rules  -> rules/
  $WORKSPACE/AGENTS.md      -> AGENTS.md

Next steps in Cursor Settings:
  1. Models: enable Composer 2.5, GPT-5.5, Claude Opus 4.7, Gemini 3.1 Pro
  2. Agents: Explore + Shell subagents -> composer-2.5
  3. New machine: git clone git@github.com:hachache/cursorrules.git ~/cursorrules && ./install.sh

Other workspace: ./install.sh /path/to/your/project
EOF
