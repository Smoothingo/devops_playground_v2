# Übungsprotokoll: Praxisübung I0 – Docker installieren, erstes Image bauen und starten

**Schule:** Technologisches Gewerbemuseum (TGM) – Die Schule der Technik  
**Klasse:** 5BHWII  
**Fach / Modul:** Cloud Computing & Infrastructure (CCID) – Modul 0  
**Lehrkraft:** Ing. Dionis Ramadani, BSc MSc LL.M.  
**Schuljahr:** 2026/27  
**Name des Schülers:** [HIER DEINEN VORNAMEN UND NACHNAMEN EINTRAGEN]  
**Datum der Durchführung:** [DATUM, z. B. 11. September 2026]  

---

## 1. Ziel der Praxisübung

Ziel dieser Übung ist der (Wieder-)Einstieg in die Container-Virtualisierung mittels Docker:
1. Verifikation der lauffähigen Docker-Umgebung (Docker Desktop mit WSL2 Ubuntu Backend unter Windows).
2. Erstellung eines minimalistischen Dockerfiles mit zwei Anweisungen (`FROM`, `COPY`).
3. Bauen eines eigenen Docker-Images (`erstes-image:1.0`).
4. Starten und Ausführen eines Containers im Hintergrund (`detached mode`) mit Port-Mapping auf Port `8081`.
5. Überprüfung des ausgelieferten Inhalts im Browser sowie Analyse des Container-Lebenszyklus bei Änderungen.
6. Fundierte Beantwortung der fünf didaktischen Verständnisfragen.

---

## 2. Teil A: Docker Installation & Gegenprobe

### 2.1 Durchgeführte Schritte
- Überprüfung der WSL2-Installation (`wsl -l -v`) und der Docker Desktop-Integration für Ubuntu.
- Prüfung der Docker-Version über die CLI:
  ```bash
  docker version
  ```
- Ausführen des Test-Containers zur Funktionsprüfung:
  ```bash
  docker run hello-world
  ```

### 2.2 Screenshot 1: Ausgabe von `docker run hello-world`
*(Füge hier deinen Screenshot der Terminal-Ausgabe ein)*

```
+------------------------------------------------------------------------------------+
|                                                                                    |
|                      [ BILD 1 HIER EINFÜGEN: TERMINAL MIT                          |
|                       AUSGABE VON "docker run hello-world" ]                       |
|                                                                                    |
+------------------------------------------------------------------------------------+
```
*(Hinweis: Der Screenshot sollte den Text "Hello from Docker!" sowie die Schritte 1 bis 4 des Daemons zeigen).*

---

### 2.3 Verständnisfrage 1
**Frage:** *Was hat docker bei „docker run hello-world“ gemacht? Schau den Log an und beschreibe in eigenen Worten, was hier passiert ist.*

**Antwort:**
Beim Aufruf von `docker run hello-world` laufen im Hintergrund folgende Schritte ab:
1. **Kommunikation:** Der Docker-Client (das CLI-Tool im Terminal) kontaktiert den Docker-Daemon (den Hintergrunddienst).
2. **Lokale Suche:** Der Daemon prüft, ob das Image `hello-world` mit dem Tag `latest` bereits im lokalen Image-Speicher des Rechners vorhanden ist. Da dies beim ersten Aufruf nicht der Fall ist (`Unable to find image 'hello-world:latest' locally`), greift der Daemon auf das Netzwerk zu.
3. **Download (Pull):** Der Daemon lädt (pullt) das fertige Image automatisch aus der offiziellen zentralen Image-Registry (Docker Hub) herunter.
4. **Container-Erstellung & Start:** Aus diesem heruntergeladenen Image instanziiert der Daemon einen neuen Container und führt die darin definierte Binärdatei aus.
5. **Ausgabeumleitung:** Das Programm innerhalb des Containers gibt die Meldung („Hello from Docker!“) auf dem Standard-Output aus. Der Daemon leitet diese Textausgabe an das Terminal des Clients weiter.
6. **Beendigung:** Sobald das Programm seinen Text ausgegeben hat, beendet sich der Container selbstständig (Status `Exited (0)`).

---

## 3. Teil B: Ein Dockerfile mit zwei Zeilen

### 3.1 Ordnerstruktur und Erstellung der statischen Seite
Es wurde ein Arbeitsverzeichnis angelegt und eine HTML-Startseite erstellt:
```bash
mkdir -p ~/erstes-image && cd ~/erstes-image
echo '<h1>Hallo von [DEIN-NAME], 5BHWII</h1>' > index.html
cat index.html
```

### 3.2 Erstellung des Dockerfiles
Im Verzeichnis `~/erstes-image` wurde die Datei `Dockerfile` mit folgendem Inhalt erstellt:
```dockerfile
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
```

---

### 3.3 Verständnisfrage 2
**Frage:** *Was ist ein Basisimage, und warum musst du nginx nicht selbst im Container installieren?*

**Antwort:**
Ein **Basisimage** (Base Image, deklariert über die Direktive `FROM`) bildet das Fundament, auf dem ein eigenes Image Schicht für Schicht (Layer) aufbaut. 

In diesem Fall basiert das Image auf `nginx:alpine`. Dieses offizielle Image enthält bereits ein vollständig lauffähiges, hochoptimiertes Minimal-Betriebssystem (Alpine Linux) sowie einen fertig installierten und vorkonfigurierten Nginx-Webserver samt dessen Startskripten. 

Man muss Nginx nicht selbst über einen Paketmanager (wie `apk add nginx`) installieren oder mühsam von Grund auf konfigurieren, weil die Entwickler des Basisimages diese Schritte bereits erledigt haben. Als Anwender muss man lediglich auf diesem fertigen Baustein aufsetzen und per `COPY` die eigene Datei (`index.html`) an die Stelle kopieren, an der Nginx statische Webseiten erwartet (`/usr/share/nginx/html/`). Das spart Entwicklungszeit, minimiert Fehlerquellen und hält das Image extrem schlank.

---

### 3.4 Image bauen und verifizieren
Der Bau des Images erfolgte mit:
```bash
docker build -t erstes-image:1.0 .
docker images
```

### 3.5 Screenshot 2: Ausgabe von `docker images`
*(Füge hier deinen Screenshot ein, der die Zeile mit `erstes-image` zeigt)*

```
+------------------------------------------------------------------------------------+
|                                                                                    |
|                      [ BILD 2 HIER EINFÜGEN: TERMINAL MIT                          |
|                  AUSGABE VON "docker images" ZEIGT erstes-image:1.0 ]              |
|                                                                                    |
+------------------------------------------------------------------------------------+
```
*(Hinweis: Auf dem Screenshot ist die Tabelle mit REPOSITORY `erstes-image`, TAG `1.0`, IMAGE ID, CREATED und SIZE im Bereich von ~20-50 MB gut erkennbar).*

---

### 3.6 Verständnisfrage 3
**Frage:** *Warum steht am Ende von docker build ein Punkt, und was passiert, wenn du den Befehl aus einem anderen Ordner startest? (statt Punkt ein anderer Directory/Pfad)*

**Antwort:**
Der Punkt (`.`) am Ende von `docker build` legt den sogenannten **Build-Kontext** (Build Context) fest. Er signalisiert dem Docker-Daemon: „Verwende das aktuelle Arbeitsverzeichnis als Wurzelverzeichnis für den Build-Vorgang“. In diesem Ordner sucht Docker standardmäßig nach dem `Dockerfile` und allen Dateien, die per `COPY` oder `ADD` ins Image übertragen werden sollen (hier: `index.html`).

- **Start aus einem anderen Ordner:** Führt man den Befehl aus einem übergeordneten oder anderen Verzeichnis aus, muss man statt des Punkts den relativen oder absoluten Pfad zum Verzeichnis angeben, in dem die Dateien liegen (z. B. `docker build -t erstes-image:1.0 ~/erstes-image`). Docker nutzt dann diesen Pfad als Kontext.
- **Weglassen des Pfads:** Lässt man das Pfad-Argument ganz weg, bricht der Befehl mit einem Syntaxfehler ab (`"docker build" requires exactly 1 argument`).
- **Falscher Pfad:** Gibt man einen Ordner an, in dem kein `Dockerfile` existiert oder die im Dockerfile referenzierte `index.html` fehlt, bricht der Build mit einem Fehler ab (`failed to read dockerfile` bzw. `COPY failed: file not found`).

---

## 4. Teil C: Container-Betrieb & Lebenszyklus

### 4.1 Container starten & überprüfen
Der Container wurde im Hintergrund gestartet und an den Host-Port 8081 gebunden:
```bash
docker run -d --name web1 -p 8081:80 erstes-image:1.0
docker ps
```

### 4.2 Screenshot 3: Browser mit Webseite und daneben `docker ps`
*(Füge hier deinen Screenshot ein: links der Browser mit http://localhost:8081, rechts das Terminal mit docker ps)*

```
+------------------------------------------------------------------------------------+
|                                                                                    |
|                      [ BILD 3 HIER EINFÜGEN: COMBINED SCREENSHOT ]                 |
|            Browser: http://localhost:8081 ("Hallo von [DEIN-NAME], 5BHWII")        |
|                                     und                                            |
|            Terminal daneben mit Ausgabe von "docker ps" (web1, Up, 8081->80/tcp)   |
|                                                                                    |
+------------------------------------------------------------------------------------+
```

---

### 4.3 Verständnisfrage 4
**Frage:** *Welche der beiden Zahlen in -p 8081:80 gehört zu deinem Laptop, welche zum Container?*

**Antwort:**
Das Flag `-p` (Port Forwarding / Mapping) folgt der Syntax `-p <Host-Port>:<Container-Port>`:
- **`8081` gehört zum Laptop (Host-System):** Das ist der externe Port des Host-Betriebssystems, auf dem der Laptop lauscht. Ruft man im Browser `http://localhost:8081` auf, empfängt der Host die Anfrage auf diesem Port.
- **`80` gehört zum Container:** Das ist der interne Standard-HTTP-Port, auf dem der Nginx-Webserver innerhalb des isolierten Container-Netzwerks lauscht.

Docker verknüpft diese Ports miteinander und leitet ankommenden Netzwerkverkehr von Port 8081 des Laptops direkt an Port 80 des Containers weiter.

---

### 4.4 Hineinschauen in den laufenden Container
Überprüfung der Zugriffslogs und Inspektion der Datei im Dateisystem des Containers:
```bash
docker logs web1
docker exec web1 cat /usr/share/nginx/html/index.html
```
- `docker logs web1` zeigt die Zugriffe (HTTP `GET /` mit Statuscode `200`).
- `docker exec` führt einen Befehl direkt im Namensraum des Containers aus und gibt den Inhalt der dort hinterlegten `index.html` aus.

---

### 4.5 Seite ändern und neue Version bauen
Aktualisierung des lokalen Inhalts:
```bash
echo '<h1>Hallo von [DEIN-NAME], Version 2</h1>' > index.html
```
Beim Neuladen der Seite im Browser (`F5`) wird weiterhin die alte Version 1 angezeigt!

Bauen der Version 1.1:
```bash
docker build -t erstes-image:1.1 .
```

---

### 4.6 Verständnisfrage 5
**Frage:** *Du hast index.html geändert, der Browser zeigt trotzdem die alte Seite. Erkläre kurz warum, nutze die Wörter Image und Container.*

**Antwort:**
Ein Docker-**Image** ist eine statische, unveränderliche (immutable) Vorlage. Beim ursprünglichen Bauen (`docker build`) wurde die damalige `index.html` fest in das **Image** `erstes-image:1.0` hineinkopiert.

Der laufende **Container** `web1` ist eine isolierte Instanz, die zur Laufzeit exakt auf diesem unveränderten **Image** basiert. Seine Dateien wurden bei der Erstellung des Containers aus dem Image initialisiert.

Wenn man nun die lokale Datei `index.html` auf dem Host-Dateisystem editiert, hat diese Modifikation keinerlei Verbindung zum Inneren des bereits laufenden **Containers** oder zum bestehenden **Image**. Erst wenn man aus der geänderten Datei ein neues **Image** (`erstes-image:1.1`) baut, den alten **Container** stoppt/löscht und einen neuen **Container** auf Basis des neuen **Images** instanziiert, wird die neue Version der Webseite ausgeliefert.

---

### 4.7 Neue Version ausführen und Aufräumen
```bash
# Alten Container entfernen
docker rm -f web1

# Neuen Container aus Version 1.1 starten
docker run -d --name web1 -p 8081:80 erstes-image:1.1

# Nach erfolgreicher Verifikation aufräumen
docker rm -f web1

# Gegenprobe
docker ps -a
docker images
```
Ergebnis: `docker ps -a` liefert eine leere Liste (alle Container aufgeräumt), während `docker images` weiterhin beide erstellten Versionen (`1.0` und `1.1`) aufbewahrt.

---

## 5. Zusatzaufgabe / Vertiefung (Für die Motivierten)

### 5.1 Layer-Analyse mit `docker image history`
Befehl:
```bash
docker image history erstes-image:1.1
```
**Erkenntnis:**  
Ein Docker-Image besteht aus aufeinander aufbauenden Schichten (Layers). Jeder Befehl im Dockerfile erzeugt eine neue Schicht:
- Die unteren Schichten stammen unverändert aus dem Basisimage `nginx:alpine` (OS-Dateien, Nginx-Binaries, Standard-Konfigurationen).
- Die oberste Schicht repräsentiert exakt den Befehl `COPY index.html /usr/share/nginx/html/index.html` und enthält nur das Delta (die wenigen Bytes unserer HTML-Datei).

### 5.2 Minimales Linux untersuchen (Alpine)
Befehl:
```bash
docker run -it --rm alpine sh
```
Im interaktiven Container:
```sh
/ # ls /
bin  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
/ # cat /etc/os-release
NAME="Alpine Linux"
ID=alpine
VERSION_ID=3.x.x
PRETTY_NAME="Alpine Linux v3.x"
/ # exit
```
**Erkenntnis:**  
Alpine Linux ist eine auf minimalen Speicherverbrauch und Sicherheit optimierte Distribution (basierend auf musl libc und BusyBox). Das gesamte Image ist nur rund 5 MB groß, bietet aber eine vollwertige POSIX-Umgebung, weshalb es sich ideal als leichtgewichtiges Basisimage für Microservices und Webserver eignet. Durch das Flag `--rm` wird der Container beim Beenden mit `exit` rückstandslos aus dem System entfernt.

---

## 6. Didaktische Zusammenfassung & Reflexion

In dieser Übung wurden die Kernprinzipien moderner Container-Technologien praktisch angewandt:
- **Reproduzierbarkeit & Portabilität:** Ein Dockerfile beschreibt deklarativ den Aufbau einer Anwendung. Unabhängig vom Wirtsbetriebssystem verhält sich der Container identisch.
- **Immutability (Unveränderlichkeit):** Images sind schreibgeschützte Vorlagen. Code-Änderungen erfordern einen kontrollierten Rebuild und Neustart des Containers.
- **Ressourceneffizienz:** Durch den Shared-Kernel-Ansatz von Containern (im Gegensatz zu vollständigen Hypervisor-VMs) starten Container in Sekundenbruchteilen und beanspruchen minimale Ressourcen.
- **Port-Isolation:** Standardmäßig sind Container vom Host isoliert; erst durch explizites Port-Forwarding (`-p`) wird ein Dienst gezielt nach außen exponiert.
