# Architecture Conceptuelle

L’architecture NexusGrid comprend **4 couches** inter-dépendantes.

## Couche 1 — Grid de Ressources P2P 🔗
- Agent léger sur chaque machine → transforme la machine en **nœud du Grid**.
- **Partage CPU/RAM** mutualisé.
- **Stockage distribué** façon "RAID P2P" : données fragmentées, chiffrées, répliquées entre nœuds pour disponibilité/persistance.

## Couche 2 — Orchestration par Conteneurs 📦
- **Docker** pour la containerisation.
- **Orchestrateur** (Docker Swarm ou K8s) : déploiement, scaling, redémarrage, placement intelligent des workloads.

## Couche 3 — Services Unifiés 🧩
- **IA locale** : Ollama pour héberger et servir des LLM on-prem.
- **Authentification centralisée** : Keycloak/FreeIPA, gestion des identités, IAM et SSO.
- Services métiers conteneurisés, **hautement disponibles**.

## Couche 4 — Sécurité en Périphérie 🛡️
- **Reverse proxy de sécurité / WAF** (ex. BunkerWeb) en edge, en Ingress.
- Filtrage OWASP Top 10, anti-bots, TLS/SSL fort, routage vers services internes.
