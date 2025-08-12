# Redis — Persistance des Sessions

## Objectif
Fournir un **Redis centralisé** pour la persistance de sessions et de petits états applicatifs.

## Déploiement (Docker Swarm)

Créer le secret :
\`\`\`bash
printf "<motdepassefort>" | docker secret create redis_password -
\`\`\`

Fichier \`stack/redis.yml\` :
\`\`\`yaml
version: "3.9"

services:
  redis:
    image: redis:7
    command:
      - sh
      - -c
      - >
        redis-server --appendonly yes
        --protected-mode yes
        --requirepass "$$(cat /run/secrets/redis_password)"
    volumes:
      - redis-data:/data
    secrets:
      - redis_password
    networks:
      - grid
    deploy:
      mode: replicated
      replicas: 1
      placement:
        constraints:
          - node.role == manager
      restart_policy:
        condition: any
        delay: 5s
        max_attempts: 10
        window: 30s
      update_config:
        parallelism: 1
        order: start-first
    healthcheck:
      test: ["CMD-SHELL", "redis-cli -a \"$$(cat /run/secrets/redis_password)\" ping | grep PONG || exit 1"]
      interval: 10s
      timeout: 3s
      retries: 5
      start_period: 5s

volumes:
  redis-data:

secrets:
  redis_password:
    external: true

networks:
  grid:
    external: true
\`\`\`

Déployer :
\`\`\`bash
docker stack deploy -c stack/redis.yml nexusgrid
docker service ls
docker service ps nexusgrid_redis
\`\`\`

## Consommation par les services

Deux approches (préférer secrets à des variables d’environnement) :

Montage du secret dans le service consommateur :
\`\`\`yaml
services:
  hello-grid:
    # ...
    secrets:
      - source: redis_password
        target: redis_password

secrets:
  redis_password:
    external: true
\`\`\`
L’app lit le mot de passe depuis \`/run/secrets/redis_password\`.

Var d’environnement (moins sûre) :
\`\`\`yaml
environment:
  REDIS_HOST: redis
  REDIS_PASSWORD: ${REDIS_PASSWORD?set_me_safely}
\`\`\`
Toujours utiliser \`REDIS_HOST=redis\` (même stack/réseau grid).
Exemple de test côté app : PING avec redis-py ou redis-cli.

## Bonnes pratiques Sécurité
- Générer un mot de passe fort (>= 32 chars).
- Ne jamais commiter de secrets ; utiliser Docker secrets.
- Restreindre l’accès réseau à Redis (service interne, pas d’exposition publique).
- Activer TLS côté proxy/edge si exposition nécessaire (éviter exposition Redis en direct).
- Sauvegardes : dump AOF sur volume \`redis-data\` + snapshots réguliers.

## Sauvegarde/Restore (exemples)

Sauvegarde du volume :
\`\`\`bash
docker run --rm -v nexusgrid_redis-data:/data -v $(pwd):/backup alpine \
  sh -c "cd /data && tar czf /backup/redis-data-$(date +%F).tgz ."
\`\`\`

Restore :
\`\`\`bash
docker run --rm -v nexusgrid_redis-data:/data -v $(pwd):/backup alpine \
  sh -c "cd /data && tar xzf /backup/redis-data-YYYY-MM-DD.tgz"
\`\`\`
