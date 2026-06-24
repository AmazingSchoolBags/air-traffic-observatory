# ✈️ Air Traffic Observatory - Pipeline DataOps industrialisé

## 📌 Présentation

Air Traffic Observatory est un pipeline DataOps permettant de collecter des données de trafic aérien en temps réel depuis l'API OpenSky Network, de les traiter avec n8n, puis de les stocker dans PostgreSQL afin de produire des indicateurs d'observabilité.

Le projet met en œuvre plusieurs concepts fondamentaux du DataOps :

* Collecte automatisée de données
* Orchestration avec n8n
* Validation des données
* Stockage relationnel PostgreSQL
* Calcul de métriques agrégées
* Conteneurisation Docker
* Portabilité du pipeline

---

## 🏗️ Architecture

```text
OpenSky API
     │
     ▼
Fetcher Docker (curl)
     │
     ▼
Webhook n8n
     │
     ▼
Transformation JavaScript
     │
     ▼
Validation IF
     │
     ├────────► Données invalides
     │
     ▼
PostgreSQL (positions)
     │
     ▼
Calcul des métriques
     │
     ▼
PostgreSQL (traffic_metrics)
```

---

## 🐳 Infrastructure Docker

Le projet est composé de quatre services :

### PostgreSQL

Base de données relationnelle utilisée pour :

* stocker les positions des avions
* stocker les métriques agrégées

Port :

```text
5433
```

---

### MongoDB

Préparé pour les extensions futures du projet.

Port :

```text
27018
```

---

### n8n

Outil d'orchestration du pipeline.

Port :

```text
5679
```

---

### OpenSky Fetcher

Conteneur chargé de :

* récupérer les données de l'API OpenSky
* envoyer les données vers n8n via webhook

---

## 📊 Schéma PostgreSQL

### Table positions

Stocke les données individuelles des avions.

| Colonne         | Type             |
| --------------- | ---------------- |
| id              | SERIAL           |
| icao24          | VARCHAR          |
| callsign        | VARCHAR          |
| origin_country  | VARCHAR          |
| longitude       | DOUBLE PRECISION |
| latitude        | DOUBLE PRECISION |
| altitude        | DOUBLE PRECISION |
| velocity        | DOUBLE PRECISION |
| timestamp_event | TIMESTAMP        |
| created_at      | TIMESTAMP        |

---

### Table traffic_metrics

Stocke les indicateurs agrégés.

| Colonne        | Type             |
| -------------- | ---------------- |
| id             | SERIAL           |
| total_aircraft | INTEGER          |
| avg_altitude   | DOUBLE PRECISION |
| avg_velocity   | DOUBLE PRECISION |
| metric_time    | TIMESTAMP        |

---

## ⚙️ Workflow n8n

Le workflow effectue les opérations suivantes :

### 1. Réception des données

Réception du payload OpenSky via Webhook.

### 2. Transformation

Transformation du format OpenSky vers un format métier exploitable :

* ICAO24
* Callsign
* Pays d'origine
* Latitude
* Longitude
* Altitude
* Vitesse

### 3. Validation

Vérification :

* présence des données
* structure valide
* exclusion des entrées incorrectes

### 4. Insertion PostgreSQL

Insertion des positions aériennes dans la table :

```text
positions
```

### 5. Calcul des métriques

Calcul :

* nombre total d'avions
* altitude moyenne
* vitesse moyenne

### 6. Stockage des métriques

Insertion dans :

```text
traffic_metrics
```

---

## 🚀 Lancement

### Démarrage

```bash
docker compose up -d
```

### Vérification

```bash
docker compose ps
```

### Arrêt

```bash
docker compose down
```

### Réinitialisation

```bash
./reset.sh
```

---

## 📂 Structure du projet

```text
air_traffic_observatory/
├── scripts/
│   └── fetch_opensky.sh
├── workflows/
│   └── air_traffic_pipeline.json
├── .env.example
├── .gitignore
├── docker-compose.yml
├── README.md
└── reset.sh
```

---

## 📸 Captures de validation

### Workflow n8n

Ajouter :

```text
screenshots/workflow.png
```

### Données dans PostgreSQL

Ajouter :

```text
screenshots/postgres_positions.png
```

### Métriques calculées

Ajouter :

```text
screenshots/postgres_metrics.png
```

### Conteneurs Docker

Ajouter :

```text
screenshots/docker_ps.png
```

---

## 🎯 Résultat obtenu

Le pipeline collecte automatiquement les données de trafic aérien, les transforme, les valide puis les stocke dans PostgreSQL.

Les métriques calculées permettent de suivre :

* le nombre d'avions observés
* l'altitude moyenne
* la vitesse moyenne

L'ensemble du projet est entièrement conteneurisé, portable et reproductible.
