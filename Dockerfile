# Leichtgewichtiges Python-Image
FROM python:3.12-slim

# Arbeitsverzeichnis im Container
WORKDIR /app

# Requirements zuerst kopieren (besseres Caching)
COPY requirements.txt .

# Abhängigkeiten installieren
RUN pip install --no-cache-dir -r requirements.txt

# App-Code kopieren
COPY . .

# Port im Container
EXPOSE 5000

# Startkommando
CMD ["python", "app.py"]