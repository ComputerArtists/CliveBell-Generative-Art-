# Generative Art – Flowing Blobs

Ein elegantes und organisches Generative-Art-Projekt in **Processing**, das fließende, lebendige Formen erzeugt, die sich durch Perlin-Noise sanft verändern. Inspiriert von natürlichen Bewegungen wie Wasser, Rauch oder Zellstrukturen.

## Vorschau
![Vorschau](preview.gif)  
*(falls kein GIF vorhanden, einfach ein statisches Bild einfügen)*

## Features
- Organische, fließende Formen basierend auf Perlin-Noise
- Sanfte Farbverläufe mit lebendigen Pastelltönen
- Interaktive Steuerung (Maus oder Tastatur)
- Automatische Farb- und Geschwindigkeitsänderungen über Zeit
- Export als hochauflösendes Video oder Bildreihe möglich
- Vollständig anpassbar (Parameter für Noise, Geschwindigkeit, Farben etc.)

## Demo
Du kannst die Skizze direkt in der Processing IDE ausführen oder online über den p5.js Editor testen (Portierung verfügbar).

## Installation
1. **Processing installieren**  
   Lade die neueste Version von https://processing.org/download herunter.

2. **Skizze öffnen**  
   - Kopiere den gesamten Ordner in deinen Processing-Sketch-Ordner  
   - Oder lade das Repository herunter und öffne `flowing_blobs.pde`

3. **Starten**  
   Drücke den Play-Button in der Processing IDE – und genieße die Show!

## Steuerung
| Taste/Maus          | Funktion                              |
|---------------------|---------------------------------------|
| `Space`             | Farbschema zufällig ändern            |
| `R`                 | Zurücksetzen auf Startzustand         |
| `S`                 | Aktuellen Frame als PNG speichern     |
| `V`                 | Videoaufzeichnung starten/stoppen     |
| `Mausklick`         | Neue „Blobs“ an der Klickposition     |
| `Mausrad`           | Zoom (optional)                       |

## Anpassung
Alle wichtigen Parameter sind oben in der Datei definiert:

```java
float noiseScale = 0.005;      // Größe der Noise-Details
float timeSpeed = 0.001;       // Geschwindigkeit der Veränderung
int blobCount = 12;            // Anzahl der Blobs
float maxRadius = 300;         // Maximaler Radius
