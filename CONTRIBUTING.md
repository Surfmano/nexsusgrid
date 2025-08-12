# Contribuer à NexusGrid

Merci de votre intérêt ! Ce dépôt utilise une approche simple pour démarrer.

## Pré-requis
- Docker récent (avec Docker Compose v2)
- Docker Swarm (peut être initialisé via `make swarm/init`)
- Optionnel: k3d/kubectl (Étape 3)

## Branches et commits
- Créez une branche par feature/bugfix : `feat/xxx`, `fix/yyy`
- Commits recommandés (Conventional Commits) :
  - `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`

## Lancement rapide
- `make help` pour lister les cibles.
- Swarm + Réseau + Redis :
  - `make swarm/init`
  - `make net/create`
  - Créez le secret: voir `docs/redis.md`
  - `make stack/up STACK=redis`

## Code de conduite
Soyez respectueux et précis dans les issues et PRs. Les sujets sensibles (sécurité) doivent être divulgués de manière responsable.
