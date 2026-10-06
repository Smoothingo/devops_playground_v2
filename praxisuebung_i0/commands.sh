#!/bin/bash
# ==============================================================================
# Praxisübung I0: Docker installieren, erstes Image bauen und starten
# Klasse: 5BHWII | CCID | TGM
# ==============================================================================
# Vor dem Ausführen: Ersetze "DEIN_NAME" durch deinen tatsächlichen Vornamen!
# ==============================================================================

MEIN_NAME="Max" # <-- HIER DEINEN VORNAMEN EINTRAGEN

echo "=== TEIL A: Gegenprobe ==="
docker version
echo ""
echo "Führe jetzt hello-world aus..."
docker run hello-world
echo "--> HIER SCREENSHOT 1 MACHEN! (Ausgabe von docker run hello-world)"
read -p "Drücke ENTER zum Fortfahren..."

echo "=== TEIL B: Image vorbereiten und bauen ==="
mkdir -p ~/erstes-image
cd ~/erstes-image

# Statische HTML-Seite anlegen
echo "<h1>Hallo von ${MEIN_NAME}, 5BHWII</h1>" > index.html
cat index.html

# Dockerfile anlegen
cat << 'EOF' > Dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
EOF

echo ""
echo "Erstellte Dateien im Ordner:"
ls -la

echo ""
echo "Image bauen..."
docker build -t erstes-image:1.0 .

echo ""
echo "Überprüfe Images..."
docker images
echo "--> HIER SCREENSHOT 2 MACHEN! (Ausgabe von docker images mit erstes-image)"
read -p "Drücke ENTER zum Fortfahren..."

echo "=== TEIL C: Container starten und testen ==="
docker run -d --name web1 -p 8081:80 erstes-image:1.0
docker ps
echo ""
echo "--> Öffne im Browser: http://localhost:8081"
echo "--> HIER SCREENSHOT 3 MACHEN! (Browser mit deiner Seite nebeneinander mit docker ps)"
read -p "Drücke ENTER zum Fortfahren..."

echo "=== Container untersuchen ==="
docker logs web1
docker exec web1 cat /usr/share/nginx/html/index.html

echo "=== Seite ändern und Version 1.1 bauen ==="
echo "<h1>Hallo von ${MEIN_NAME}, Version 2</h1>" > index.html
echo "Index.html geändert. Im Browser aktualisieren (F5) zeigt noch Version 1!"
read -p "Drücke ENTER um Image 1.1 zu bauen..."

docker build -t erstes-image:1.1 .
docker images

echo "=== Neuen Container mit Version 1.1 starten ==="
docker rm -f web1
docker run -d --name web1 -p 8081:80 erstes-image:1.1
echo "Container mit Version 1.1 gestartet. Prüfe http://localhost:8081"
read -p "Drücke ENTER zum Aufräumen..."

docker rm -f web1
docker ps -a
docker images

echo "=== OPTIONAL / ZUSATZ (Für Motivierte) ==="
docker image history erstes-image:1.1
echo "Fertig! Alle Schritte erfolgreich durchlaufen."
