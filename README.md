# cursorrules

Configuration Cursor portable : **rules**, **subagents**, **AGENTS.md** — une source, n'importe quelle machine.

Repo : [github.com/hachache/cursorrules](https://github.com/hachache/cursorrules)

## Structure

```
cursorrules/
├── AGENTS.md                 # Instructions agent (workspace)
├── install.sh                # Symlinks agents + rules + AGENTS.md
├── README.md
├── rules/                    # → <workspace>/.cursor/rules/
│   ├── global-standards.mdc       (alwaysApply)
│   ├── security-standards.mdc     (alwaysApply)
│   ├── gitignore-protection.mdc   (alwaysApply)
│   ├── subagent-routing.mdc       (alwaysApply — mapping modèles Task tool)
│   └── …                          (standards par techno, globs)
└── agents/                   # → ~/.cursor/agents/ (user-level)
    ├── shell-specialist.md
    ├── ansible-specialist.md
    ├── design-specialist.md
    └── …
```

## Installation (nouvelle machine)

```bash
git clone git@github.com:hachache/cursorrules.git ~/cursorrules
cd ~/cursorrules
chmod +x install.sh verify.sh uninstall.sh
./install.sh                    # défaut : ~/Documents
./install.sh ~/projects/mon-app # autre workspace
DRY_RUN=1 ./install.sh          # dry-run sans rien modifier
```

Le script crée des symlinks :

| Cible | Source |
|-------|--------|
| `~/.cursor/agents/` | `~/cursorrules/agents/` |
| `<workspace>/.cursor/rules/` | `~/cursorrules/rules/` |
| `<workspace>/AGENTS.md` | `~/cursorrules/AGENTS.md` |

Tout fichier existant non-symlink à la cible est sauvegardé dans `~/.cursor/.cursorrules-backup-<timestamp>/`. Idempotent : relancer le script ne casse rien.

## Vérification

```bash
./verify.sh                     # par défaut ~/Documents
./verify.sh ~/projects/mon-app
```

Sortie attendue : `All checks passed.`

## Désinstallation

```bash
./uninstall.sh                  # retire uniquement les symlinks pointant vers ce repo
```

## Mise à jour

```bash
cd ~/cursorrules && git pull
```

Les symlinks pointent vers le repo — un `git pull` suffit. Redémarrer Cursor pour recharger les rules.

## Subagents & modèles

| Catégorie | Modèle Task tool | Subagents |
|-----------|------------------|-----------|
| Shell, Docker, explore | `composer-2.5-fast` | shell, docker, explore |
| Infra, sécu | `claude-opus-4-7-thinking-xhigh` | ansible, terraform, aws, security-auditor |
| Code (Python, React, Vite, Tailwind) | `gpt-5.5-medium` | python, react, vite, tailwind |
| DA / UX / UI | `gemini-3.1-pro` | design-specialist |

Frontmatter `@subagent` : voir `model:` dans chaque fichier `agents/*.md`.

Règle Task tool (always-on) : `rules/subagent-routing.mdc`.

## Rules — alwaysApply

Ces rules sont injectées à **chaque** session Cursor (mécanisme fiable) :

- `global-standards.mdc` — qualité, SOLID, early returns
- `security-standards.mdc` — OWASP, secrets, validation
- `gitignore-protection.mdc` — ne jamais committer `.env`, artefacts IA
- `subagent-routing.mdc` — mapping modèles + Task tool

Les autres rules s'activent via `globs` (ex. `**/*.py` → python-standards).

## AGENTS.md vs rules

| Fichier | Rôle | Fiabilité injection |
|---------|------|---------------------|
| `rules/*.mdc` avec `alwaysApply: true` | Standards code, routing subagents | **Garanti** |
| `AGENTS.md` | Vue d'ensemble, doc humaine + agent | Variable selon version Cursor |

Si `AGENTS.md` n'est pas injecté : `@AGENTS.md` en début de chat, ou s'appuyer sur `subagent-routing.mdc`.

## Ajouter une rule

```bash
# Dans ~/cursorrules/rules/
cat > ma-rule.mdc <<'EOF'
---
description: Ma règle
globs: "**/*.go"
alwaysApply: false
---
# Contenu…
EOF
git add rules/ma-rule.mdc && git commit -m "feat(rules): add Go standards" && git push
```

## Ajouter un subagent

Créer `~/cursorrules/agents/mon-specialist.md` :

```markdown
---
name: mon-specialist
model: gpt-5.5
description: Expert … Use proactively for …
---

# Prompt système…
```

Valeurs valides pour `model:` :
- `composer-2.5` (CLI, terminal, exploration)
- `gpt-5.5` (code applicatif)
- `claude-opus-4-7-thinking-xhigh` (infra, sécu, raisonnement)
- `gemini-3.1-pro` (DA, UX, multimodal)
- `inherit` (modèle du parent)

Puis : `git add agents/mon-specialist.md && git commit -m "feat(agents): add mon-specialist" && git push`.

## Troubleshooting

| Symptôme | Solution |
|----------|----------|
| `AGENTS.md` pas injecté dans le chat | Démarrer le chat avec `@AGENTS.md` ou s'appuyer sur `subagent-routing.mdc` (alwaysApply) |
| Subagent ignore son `model:` (via Task tool) | Normal — passer `model="…"` explicite dans l'appel Task |
| Symlinks cassés après déplacement du repo | Relancer `./install.sh` (idempotent) |
| Vérifier les rules actives en session | Demander à l'agent : « liste tous les `always_applied_workspace_rule` par nom » |

## Licence

MIT — voir [LICENSE](./LICENSE).
