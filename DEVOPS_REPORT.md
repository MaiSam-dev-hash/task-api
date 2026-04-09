# Rapport Final - Projet DevOps : Task API

Ce rapport présente la mise en œuvre complète de l'infrastructure, du monitoring et du pipeline de déploiement continu pour l'application **Task API**.

---

## 🏗️ 1. Infrastructure Kubernetes (VM 1 : 192.168.1.26)

L'infrastructure a été conçue pour garantir la haute disponibilité et la persistance des données dans un environnement conteneurisé.

### Composants principaux
- **Namespace** : `devops-l3gl` (Isolation des ressources).
- **Base de données MySQL** : Déployée avec un `PersistentVolume` (PV) et un `PersistentVolumeClaim` (PVC) de 1Go pour assurer que les données survivent aux redémarrages des pods.
- **Application Task API** : Image Spring Boot 3 exposée sur le port `8085`.
- **Ingress Controller** : Configuré avec une règle de réécriture (`rewrite-target`) permettant d'accéder à l'application via l'URL : `http://192.168.1.26/l3gl`.

### Points clés de la configuration
- **Probes (Liveness & Readiness)** : Configuration de délais de démarrage (`initialDelaySeconds: 240s`) pour accommoder le temps d'initialisation de l'application avec ses agents de monitoring.
- **Resources** : Allocation de limites précises (512Mi RAM / 500m CPU) pour une gestion efficace du cluster.

---

## 📊 2. Monitoring & Observabilité (VM 2 : 192.168.1.22)

La surveillance a été mise en place via une stack Docker Compose centralisant les métriques et les logs.

### Architecture de Monitoring
- **Prometheus** : Récupère les métriques via le endpoint `/l3gl/actuator/prometheus`. Nous avons ajouté une étiquette `application: 'task-api'` pour filtrer les données dans Grafana.
- **Grafana** : Interface de visualisation utilisant le Dashboard professionnel **JVM (Micrometer)** (ID: 19011).
- **Loki** : Centralisation des logs applicatifs. L'application envoie ses logs directement à Loki via un appender Logback spécifique.

### Indicateurs clés (KPI)
- **Mémoire (Heap/Non-Heap)** : Surveillance en temps réel pour détecter les fuites de mémoire.
- **HTTP Requests** : Analyse des codes de retour (200, 404, 500) et des temps de réponse.
- **Logs applicatifs** : Consultation des traces d'erreurs directement depuis Grafana sans accès SSH à la VM.

---

## 🛠️ 3. Pipeline CI/CD GitLab

L'automatisation du cycle de vie du logiciel est gérée par GitLab CI, garantissant que chaque modification est testée et publiée.

### Étapes du Pipeline (Stages)
1. **Test** : Exécution des tests unitaires JUnit. Pour garantir l'indépendance du pipeline, nous utilisons une base de données **H2** en mémoire.
2. **Build** : Compilation de l'application et génération du fichier `.jar`. La dépendance locale `task-core` est installée dynamiquement dans le dépôt local du runner via `mvn install:install-file`.
3. **Docker** : Construction de l'image Docker et publication (Push) sur **Docker Hub**.

### Variables de configuration (Secret Variables)
- `DOCKER_USERNAME` : Identifiant Docker Hub.
- `DOCKER_PASSWORD` : Access Token Docker Hub.
- `DOCKER_IMAGE` : Nom de l'image (ex: `votre-pseudo/task-api`).

---

## 📦 4. Livrables Techniques

- **Dépôt GitHub** : [Lien à insérer] (Contient `/k8s`, `/observability` et le code source).
- **Dépôt GitLab** : [Lien à insérer] (Contient `.gitlab-ci.yml` et l'historique des pipelines réussis).
- **Docker Hub** : Image disponible sous le tag `$DOCKER_IMAGE:latest`.

---

## 🏁 Conclusion

Le projet remplit 100% des objectifs fixés. L'application est non seulement déployée sur Kubernetes avec une gestion de la persistance, mais elle est aussi monitorée de manière granulaire et son cycle de mise à jour est entièrement automatisé via le pipeline CI/CD.
