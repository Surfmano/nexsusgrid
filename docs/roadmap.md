# Feuille de Route

## Étape 1 — Preuve de Concept (PoC) : Noyau du Grid 🔬
- [ ] Mettre en place un agent de partage de ressources basique (placeholder).
- [ ] Configurer un cluster **Docker Swarm** (ou K3s/MicroK8s) sur 2–3 nœuds.
- [ ] Déployer un conteneur simple (**hello-grid**) et vérifier l’exécution sur n’importe quel nœud.
- [ ] Tester un stockage distribué (GlusterFS, Ceph en mode démo).

## Étape 2 — Services de Base ⚙️
- [ ] Déployer **BunkerWeb** en edge (Ingress/WAF) pour sécuriser un service web de test.
- [ ] Déployer un service d’authentification (**Keycloak**).
- [ ] Déployer un **LLM via Ollama** et l’exposer en toute sécurité via BunkerWeb.

## Étape 3 — Intégration Avancée & Optimisation 🧠
- [ ] Script de **monitoring** : usage ressources + consommation électrique par nœud.
- [ ] Intégration des métriques dans la **planification** de l’orchestrateur.
- [ ] **Mise en veille (WoL)** pilotée par l’orchestrateur.

## Étape 4 — Production & Échelle 🌐
- [ ] Scripts d’installation **automatisés** pour l’agent NexusGrid.
- [ ] **Documentation complète** (admins/utilisateurs).
- [ ] Plan de **migration progressive** des applications existantes vers NexusGrid.
