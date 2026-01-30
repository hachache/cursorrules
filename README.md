# 🎯 Cursor Rules

Collection de règles pour [Cursor IDE](https://cursor.sh) - l'éditeur de code augmenté par IA.

Ces règles permettent à l'IA de Cursor de suivre automatiquement vos standards de développement, conventions de code, et bonnes pratiques.

## 📁 Structure

```
.cursor/
└── rules/
    ├── global-standards.mdc      # Standards généraux (toujours actif)
    ├── git-commits.mdc           # Conventional Commits + GitFlow
    ├── typescript-standards.mdc
    ├── python-standards.mdc
    ├── react-standards.mdc
    ├── vue3-standards.mdc
    ├── nextjs-standards.mdc
    ├── nodejs-standards.mdc
    ├── fastapi-standards.mdc
    ├── testing-standards.mdc
    ├── database-standards.mdc
    ├── shell-standards.mdc
    ├── ansible-standards.mdc
    ├── infrastructure-standards.mdc
    ├── security-standards.mdc
    ├── api-standards.mdc
    └── tailwind-standards.mdc
```

## 🚀 Installation

### Option 1 : Clone dans votre projet

```bash
# À la racine de votre projet
git clone git@github.com:hachache/cursorrules.git .cursor/rules
```

### Option 2 : Clone global + symlink

```bash
# Cloner une fois
git clone git@github.com:hachache/cursorrules.git ~/cursorrules

# Symlink dans chaque projet
ln -s ~/cursorrules .cursor/rules
```

### Option 3 : Copie sélective

```bash
git clone git@github.com:hachache/cursorrules.git
cp cursorrules/*.mdc votre-projet/.cursor/rules/
```

## 📖 Comment ça marche

### Format des fichiers (.mdc)

Chaque règle utilise un frontmatter YAML :

```markdown
---
description: Description courte de la règle
globs: "**/*.ts,**/*.tsx"
alwaysApply: false
---

# Titre de la règle

Contenu markdown avec vos standards...
```

### Paramètres du frontmatter

| Paramètre | Description |
|-----------|-------------|
| `description` | Description affichée dans Cursor |
| `globs` | Patterns de fichiers qui activent la règle |
| `alwaysApply` | `true` = toujours actif, `false` = selon globs |

### Exemples de globs

```yaml
# TypeScript/JavaScript
globs: "**/*.ts,**/*.tsx,**/*.js,**/*.jsx"

# Python
globs: "**/*.py"

# Infrastructure
globs: "**/*.tf,**/ansible/**/*.yml"

# Tests
globs: "**/*.test.*,**/*.spec.*,**/tests/**/*"

# Tout (toujours actif)
alwaysApply: true
```

### Quand les règles s'activent

```
Vous éditez: src/components/Button.tsx

Règles chargées automatiquement:
✅ global-standards.mdc     (alwaysApply: true)
✅ git-commits.mdc          (alwaysApply: true)
✅ typescript-standards.mdc (globs: **/*.tsx)
✅ react-standards.mdc      (globs: **/*.tsx)
❌ python-standards.mdc     (globs: **/*.py - pas de match)
```

## 🎯 Règles incluses

### Développement

| Fichier | Globs | Description |
|---------|-------|-------------|
| `global-standards.mdc` | `alwaysApply` | SOLID, early returns, error handling |
| `typescript-standards.mdc` | `**/*.ts,**/*.tsx` | Strict mode, generics, utility types |
| `python-standards.mdc` | `**/*.py` | Pydantic, async, type hints, DI |
| `react-standards.mdc` | `**/*.tsx,**/*.jsx` | Hooks, React Query, composition |
| `vue3-standards.mdc` | `**/*.vue` | Composition API, Pinia, composables |
| `nextjs-standards.mdc` | `**/app/**/*.tsx` | App Router, Server Components |
| `nodejs-standards.mdc` | `**/server/**/*.ts` | Express, middleware, Zod |
| `fastapi-standards.mdc` | `**/api/**/*.py` | Schemas, DI, async endpoints |

### Tests & Qualité

| Fichier | Globs | Description |
|---------|-------|-------------|
| `testing-standards.mdc` | `**/*.test.*,**/*.spec.*` | Jest, Playwright, pytest |
| `security-standards.mdc` | `**/auth/**,**/api/**` | OWASP Top 10, validation |
| `api-standards.mdc` | `**/api/**/*` | REST design, pagination, errors |

### Infrastructure

| Fichier | Globs | Description |
|---------|-------|-------------|
| `database-standards.mdc` | `**/*.prisma,**/models/**` | Prisma, SQLAlchemy, migrations |
| `shell-standards.mdc` | `**/*.sh,**/*.bash` | Bash strict mode, logging |
| `ansible-standards.mdc` | `**/ansible/**/*.yml` | FQCN, Vault, idempotence |
| `infrastructure-standards.mdc` | `**/*.tf` | Terraform modules, state |

### Git & Style

| Fichier | Globs | Description |
|---------|-------|-------------|
| `git-commits.mdc` | `alwaysApply` | Conventional Commits, GitFlow |
| `tailwind-standards.mdc` | `**/*.tsx,**/*.vue` | cn() utility, responsive |

## 💡 Créer une nouvelle règle

1. Créer un fichier `.mdc` dans `.cursor/rules/` :

```markdown
---
description: Standards Kubernetes - manifests et Helm charts
globs: "**/k8s/**/*.yaml,**/kubernetes/**/*.yaml,**/helm/**/*.yaml"
alwaysApply: false
---

# Standards Kubernetes

## Ressources

- Toujours définir `requests` ET `limits`
- Labels obligatoires : `app`, `env`, `version`

## Exemple

\`\`\`yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
    env: production
    version: "1.0.0"
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: app
          resources:
            requests:
              memory: "128Mi"
              cpu: "100m"
            limits:
              memory: "256Mi"
              cpu: "200m"
\`\`\`
```

2. La règle s'active automatiquement sur les fichiers K8s.

## 🔄 Synchronisation avec Claude Code

Ces règles ont un équivalent pour Claude Code dans [clauderules](https://github.com/hachache/clauderules).

**Différences de format** :

| Cursor (.mdc) | Claude Code (.md) |
|---------------|-------------------|
| `globs: "**/*.ts"` | `paths: ["**/*.ts"]` |
| `alwaysApply: true` | Fichier dans CLAUDE.md |
| `.cursor/rules/` | `.claude/rules/` |

## 🔗 Liens utiles

- [Documentation Cursor Rules](https://docs.cursor.com/context/rules-for-ai)
- [Glob Patterns](https://github.com/isaacs/node-glob#glob-primer)
- [Awesome Cursor Rules](https://github.com/PatrickJS/awesome-cursorrules)

## 📝 License

MIT - Utilisez et adaptez librement ces règles pour vos projets.
