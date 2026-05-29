# Standards de Développement

Instructions globales Cursor — source canonique : [hachache/cursorrules](https://github.com/hachache/cursorrules).

## Langue & Communication

- Répondre en **français** sauf si code/commentaires en anglais
- Messages de commit en **anglais** (Conventional Commits)
- Documentation technique : suivre la langue du projet

## Comportement obligatoire

1. **Lire avant modifier** : toujours lire le fichier existant
2. **Respecter les patterns** : identifier et suivre le style en place
3. **Proposer des refactorings** si le code viole les standards
4. **Jamais de secrets** hardcodés (utiliser env vars, vault, secrets manager)

## Structure (après `./install.sh`)

```
~/cursorrules/                    # clone git — source unique
├── AGENTS.md                     # ce fichier
├── install.sh
├── rules/                        # → symlink ~/.cursor/... ou project/.cursor/rules
│   ├── global-standards.mdc
│   ├── subagent-routing.mdc      # alwaysApply — mapping modèles Task tool
│   └── …
└── agents/                       # → symlink ~/.cursor/agents/
    ├── shell-specialist.md
    ├── ansible-specialist.md
    └── …

~/.cursor/agents/                 # user-level, tous projets
<workspace>/.cursor/rules/        # project-level rules
<workspace>/AGENTS.md             # symlink vers ~/cursorrules/AGENTS.md
```

## Subagents disponibles

| Subagent | Modèle | Usage |
|----------|--------|-------|
| `shell-specialist` | `composer-2.5` | Bash/Zsh/POSIX, ShellCheck, idempotence |
| `docker-specialist` | `composer-2.5` | Dockerfile, compose, hadolint, Trivy |
| `ansible-specialist` | `claude-opus-4-8-thinking-xhigh` | Playbooks, Vault, ansible-lint |
| `terraform-specialist` | `claude-opus-4-8-thinking-xhigh` | Modules, state, tfsec/checkov |
| `aws-specialist` | `claude-opus-4-8-thinking-xhigh` | IAM, VPC, Well-Architected |
| `security-auditor` | `claude-opus-4-8-thinking-xhigh` | OWASP, secret scanning, SAST |
| `python-specialist` | `gpt-5.5` | Python 3.11+, FastAPI, pytest, ruff/mypy |
| `react-specialist` | `gpt-5.5` | React 18+/19, hooks, RSC, a11y |
| `vite-specialist` | `gpt-5.5` | vite.config.ts, plugins, build |
| `tailwind-specialist` | `gpt-5.5` | Tailwind v3/v4, design tokens |
| `design-specialist` | `gemini-3.1-pro` | DA, motion, UX/UI, audit visuel |

Invocation : `@<nom-subagent>` ou demande explicite.

La règle Task tool est aussi dans `rules/subagent-routing.mdc` (`alwaysApply: true`).

## Sécurité — rappels critiques

```
❌ JAMAIS                          ✅ TOUJOURS
API_KEY = "sk-xxx"                 process.env.API_KEY
password: "secret"                 vault_password (Ansible)
aws_access_key = "AKIA..."         data.aws_secretsmanager
```

## Qualité du code

- Noms explicites, fonctions courtes, early returns
- Erreurs contextuelles — jamais silencieuses
