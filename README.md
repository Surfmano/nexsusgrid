# NexusGrid

NexusGrid vise à transformer l’infrastructure d’entreprise en **cloud privé unifié et décentralisé**, en agrégeant les ressources CPU/RAM/stockage des machines pour offrir **résilience**, **sécurité** et **souveraineté** (IA locale incluse).

## Structure du dépôt

```
.
├─ apps/
│  └─ hello-grid/            # sera rempli à l’étape 2
├─ agents/
│  └─ nexus-agent/           # placeholder pour plus tard
├─ infra/
│  └─ k3d/                   # fichiers de cluster local (étape 3)
├─ k8s/
│  └─ hello-grid/            # manifests k8s (étape 3)
├─ stack/                    # stacks Docker Compose/Swarm (ex: redis)
├─ docs/
├─ secrets/                  # ignoré git
├─ Makefile
├─ .gitignore
├─ .editorconfig
├─ LICENSE (MIT)
├─ README.md
└─ CONTRIBUTING.md
```

## Documentation

- Vision: [docs/vision.md](docs/vision.md)
- Objectifs: [docs/objectifs.md](docs/objectifs.md)
- Architecture (4 couches): [docs/architecture.md](docs/architecture.md)
- Roadmap (Étapes 1 → 4): [docs/roadmap.md](docs/roadmap.md)
- Technologies: [docs/technologies.md](docs/technologies.md)
- Redis (stack + secrets): [docs/redis.md](docs/redis.md)

## Roadmap de démarrage

- Étape 1 — PoC du noyau du Grid (Swarm/K3s basique, hello-grid)
- Étape 2 — Services de base (BunkerWeb, Keycloak, LLM via Ollama)
- Étape 3 — Intégration avancée & optimisation (monitoring, planification, WoL)

## Démarrage rapide (Docker Swarm)

Sur le nœud manager :

```bash
# Afficher l'aide
make help

# Initialiser Swarm (idempotent)
make swarm/init

# (Optionnel) obtenir les tokens de jointure
make swarm/token/worker    # affiche le token pour joindre des workers
make swarm/token/manager   # affiche le token pour joindre d'autres managers
```

Sur chaque nœud supplémentaire (exécuté sur le nœud à joindre) : remplacer <MANAGER_IP> et <TOKEN> par les valeurs obtenues depuis le manager :

```bash
# Exemple (sur le nœud à joindre)
docker swarm join --token <TOKEN> <MANAGER_IP>:2377
```

Créer les réseaux overlay attachables (une seule fois depuis le manager) :

```bash
make net/create
```

Déployer une stack (ex : redis) depuis le répertoire `stack` :

```bash
make stack/up STACK=redis
# ou pour une autre stack
make stack/up STACK=hello-grid
```

Pour supprimer une stack :

```bash
make stack/down STACK=redis
```

Vérifier que les réseaux `grid` et `edge` existent et sont de type `overlay` avec `Attachable: true` :

```bash
# Liste rapide
docker network ls | grep -E 'grid|edge'

# Vérification détaillée (doit contenir "Driver": "overlay" et "Attachable": true)
docker network inspect grid
docker network inspect edge
```

Critères rapides :
- Les cibles Make (swarm/init, swarm/token/*, net/create, stack/up, stack/down, swarm/leave) permettent d'automatiser les opérations décrites.
- Les réseaux `grid` et `edge` doivent apparaître dans `docker network ls` et `docker network inspect` doit indiquer `Driver: overlay` et `Attachable: true`.

Licence: MIT — voir [LICENSE](LICENSE).

## Tester hello‑grid en local

Build et lance le service hello‑grid en local (Docker Compose) :

```bash
# Build et démarrer en arrière-plan
make dev/up

# Arrêter et supprimer les ressources (volumes inclus)
make dev/down
```

Vérifier rapidement via curl :

```bash
# Root endpoint
curl -sS http://localhost:8080/

# Metrics
curl -sS http://localhost:8080/metrics
```

Détails importants :
- L'image est construite depuis `apps/hello-grid` et taggée `hello-grid:dev`.
- Le service écoute sur le port 8000 dans le conteneur et est mappé sur le port 8080 de la machine hôte.
- Le container est exécuté en tant qu'utilisateur non‑root et expose un `HEALTHCHECK` sur `/`.
- Tests unitaires disponibles dans `apps/hello-grid/tests/` (exécuter `pytest apps/hello-grid/tests`).
