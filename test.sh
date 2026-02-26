#!/bin/bash

BASE_URL="http://192.168.49.2:30000"

echo "=== POST: Notiz anlegen ==="
curl -s -X POST $BASE_URL/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "Erste Notiz", "content": "Hallo Welt!"}' | python3 -m json.tool

echo ""
echo "=== POST: Zweite Notiz anlegen ==="
curl -s -X POST $BASE_URL/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "Zweite Notiz", "content": "Noch eine Notiz!"}' | python3 -m json.tool

echo ""
echo "=== GET: Alle Notizen ==="
curl -s $BASE_URL/notes | python3 -m json.tool

echo ""
echo "=== GET: Notiz 1 ==="
curl -s $BASE_URL/notes/1 | python3 -m json.tool

echo ""
echo "=== PUT: Notiz 1 aktualisieren ==="
curl -s -X PUT $BASE_URL/notes/1 \
  -H "Content-Type: application/json" \
  -d '{"title": "Aktualisiert", "content": "Neuer Inhalt!"}' | python3 -m json.tool

echo ""
echo "=== DELETE: Notiz 1 löschen ==="
curl -s -X DELETE $BASE_URL/notes/1
echo "Notiz 1 gelöscht! (HTTP 204)"

echo ""
echo "=== GET: Alle Notizen nach dem Löschen ==="
curl -s $BASE_URL/notes | python3 -m json.tool

echo ""
echo "=== GET: Nicht vorhandene Notiz (404) ==="
curl -s $BASE_URL/notes/999 | python3 -m json.tool

echo ""
echo "=== POST: Fehlende Felder (400) ==="
curl -s -X POST $BASE_URL/notes \
  -H "Content-Type: application/json" \
  -d '{"title": "Nur Titel"}' | python3 -m json.tool
