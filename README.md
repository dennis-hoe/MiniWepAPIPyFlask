# Mini Web API mit Python Flask

Eine einfache REST API für Notizverwaltung, gebaut mit Flask und deploybar auf Kubernetes (Minikube).

## 📋 Funktionen

- ✅ CRUD-Operationen für Notizen (Create, Read, Update, Delete)
- ✅ In-Memory Datenspeicherung
- ✅ JSON-Fehlerbehandlung
- ✅ RESTful API Design
- ✅ Docker-Support
- ✅ Kubernetes-Deployment (Minikube)
- ✅ Automatisches Test-Script

## 🛠️ Technologien

- **Python 3.12** - Programmiersprache
- **Flask** - Web-Framework
- **Docker** - Containerisierung
- **Docker Compose** - Lokale Entwicklung
- **Kubernetes** - Orchestrierung
- **Minikube** - Lokales Kubernetes

## 📦 Voraussetzungen

- Python 3.7+
- Docker
- Docker Compose (optional)
- Minikube
- kubectl

## 🚀 Schnellstart

### Lokale Entwicklung (ohne Docker)

1. **Repository klonen:**
```bash
cd /home/dennis/Projekte/MiniWepAPIPyFlask
```

2. **Abhängigkeiten installieren:**
```bash
pip install -r requirements.txt
```

3. **Server starten:**
```bash
python app.py
```

Server läuft auf: `http://localhost:5000`

### Mit Docker Compose

```bash
docker-compose up
```

Server läuft auf: `http://localhost:5000`

## 🐳 Docker Deployment

### Image bauen

```bash
docker build -t flask-notes-api:latest .
```

### Container starten

```bash
docker run -d -p 5000:5000 --name notes-api flask-notes-api:latest
```

## ☸️ Kubernetes Deployment mit Minikube

### 1. Minikube starten

```bash
minikube start
```

### 2. Docker-Image für Minikube bauen

```bash
# Minikube Docker-Umgebung nutzen
eval $(minikube docker-env)

# Image bauen
docker build -t flask-notes-api:latest .

# Überprüfen
docker images | grep flask-notes-api
```

### 3. Deployment erstellen

```bash
kubectl apply -f deployment.yaml
```

### 4. Service erstellen

```bash
kubectl apply -f service.yaml
```

### 5. Status überprüfen

```bash
# Pods anzeigen
kubectl get pods

# Service anzeigen
kubectl get services

# Minikube IP anzeigen
minikube ip
```

### 6. API testen

Die API ist erreichbar über:
```
http://<minikube-ip>:30000
```

Minikube IP herausfinden:
```bash
minikube ip
# Beispiel: 192.168.49.2
```

### 7. Test-Script ausführen

```bash
chmod +x test.sh
./test.sh
```

**Hinweis:** Passe die `BASE_URL` in `test.sh` an deine Minikube-IP an.

### Nützliche Kubernetes-Befehle

```bash
# Logs eines Pods anzeigen
kubectl logs <pod-name>

# In einen Pod einsteigen
kubectl exec -it <pod-name> -- /bin/bash

# Deployment skalieren
kubectl scale deployment notes-api --replicas=3

# Service löschen
kubectl delete service notes-api-service

# Deployment löschen
kubectl delete deployment notes-api

# Alles löschen
kubectl delete -f deployment.yaml -f service.yaml
```

## 📡 API Endpoints

### 1. Alle Notizen abrufen
```http
GET /notes
```

**Antwort:**
```json
[
  {
    "id": 1,
    "title": "Meine erste Notiz",
    "content": "Das ist der Inhalt"
  }
]
```

### 2. Eine einzelne Notiz abrufen
```http
GET /notes/{id}
```

**Beispiel:**
```bash
curl http://192.168.49.2:30000/notes/1
```

### 3. Neue Notiz erstellen
```http
POST /notes
Content-Type: application/json

{
  "title": "Neue Notiz",
  "content": "Notizinhalt"
}
```

**Beispiel:**
```bash
curl -X POST http://192.168.49.2:30000/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","content":"Das ist ein Test"}'
```

**Antwort (201 Created):**
```json
{
  "id": 1,
  "title": "Neue Notiz",
  "content": "Notizinhalt"
}
```

### 4. Notiz aktualisieren
```http
PUT /notes/{id}
Content-Type: application/json

{
  "title": "Aktualisierter Titel",
  "content": "Aktualisierter Inhalt"
}
```

**Beispiel:**
```bash
curl -X PUT http://192.168.49.2:30000/notes/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Geändert","content":"Neuer Inhalt"}'
```

### 5. Notiz löschen
```http
DELETE /notes/{id}
```

**Beispiel:**
```bash
curl -X DELETE http://192.168.49.2:30000/notes/1
```

**Antwort:** `204 No Content`

## ❌ Fehlerbehandlung

### 404 - Not Found
```json
{
  "error": 404,
  "description": "Note not found"
}
```

### 400 - Bad Request
```json
{
  "error": 400,
  "description": "Missing 'title' or 'content'"
}
```

## 📁 Projekt-Struktur

```
MiniWepAPIPyFlask/
├── app.py                 # Flask Hauptanwendung
├── requirements.txt       # Python-Abhängigkeiten
├── Dockerfile            # Docker-Image-Definition
├── docker-compose.yml    # Docker Compose Konfiguration
├── deployment.yaml       # Kubernetes Deployment
├── service.yaml          # Kubernetes Service (NodePort)
├── test.sh              # Test-Script für die API
└── README.md            # Diese Datei
```

## 🔧 Konfiguration

### Kubernetes Deployment

- **Replicas:** 4 Instanzen
- **Resources:**
  - Memory: 64Mi (Request) / 128Mi (Limit)
  - CPU: 250m (Request) / 500m (Limit)
- **Image Pull Policy:** Never (lokales Image)

### Kubernetes Service

- **Type:** NodePort
- **Port:** 5000 (intern)
- **NodePort:** 30000 (extern)
- **Target Port:** 5000

### Docker

- **Base Image:** python:3.12-slim
- **Working Directory:** /app
- **Exposed Port:** 5000

## 🧪 Testen

### Automatisches Testen mit test.sh

```bash
./test.sh
```

Das Script testet:
- ✅ POST: Notizen erstellen
- ✅ GET: Alle Notizen abrufen
- ✅ GET: Einzelne Notiz abrufen
- ✅ PUT: Notiz aktualisieren
- ✅ DELETE: Notiz löschen
- ✅ 404-Fehler bei nicht vorhandener Notiz
- ✅ 400-Fehler bei fehlenden Feldern

### Manuelle Tests

```bash
# Notiz erstellen
curl -X POST http://192.168.49.2:30000/notes \
  -H "Content-Type: application/json" \
  -d '{"title":"Test","content":"Inhalt"}'

# Alle Notizen
curl http://192.168.49.2:30000/notes

# Notiz aktualisieren
curl -X PUT http://192.168.49.2:30000/notes/1 \
  -H "Content-Type: application/json" \
  -d '{"title":"Neu","content":"Geändert"}'

# Notiz löschen
curl -X DELETE http://192.168.49.2:30000/notes/1
```

## ⚠️ Wichtige Hinweise

- **In-Memory-Speicherung:** Alle Daten gehen bei Neustart verloren
- **Debug-Modus:** Für Produktion `debug=False` setzen
- **NodePort Range:** 30000-32767 (Kubernetes Standard)
- **Minikube IP:** Kann sich nach Neustart ändern
- **Image Pull Policy:** `Never` bedeutet, Image muss lokal gebaut werden

## 🐛 Troubleshooting

### Pod startet nicht

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Image nicht gefunden

```bash
# Docker-Umgebung prüfen
eval $(minikube docker-env)
docker images

# Image neu bauen
docker build -t flask-notes-api:latest .
```

### Service nicht erreichbar

```bash
# Minikube IP prüfen
minikube ip

# Service-Status prüfen
kubectl get services
kubectl describe service notes-api-service

# Port-Forward als Alternative
kubectl port-forward service/notes-api-service 5000:5000
```

### Minikube zurücksetzen

```bash
minikube stop
minikube delete
minikube start
```

## 📚 Weiterführende Dokumentation

- [Flask Documentation](https://flask.palletsprojects.com/)
- [Docker Documentation](https://docs.docker.com/)
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Minikube Documentation](https://minikube.sigs.k8s.io/docs/)

## 📝 Lizenz

Dieses Projekt ist für Lern- und Demonstrationszwecke erstellt.

## 👤 Autor

Dennis

---

**Viel Erfolg mit deiner Flask Notes API! 🚀**
