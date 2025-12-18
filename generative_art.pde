// Globale Variablen
float noiseScale = 0.01;
float timeOffset = 0;

// Feste Farbpaletten (wie zuvor)
color[] paletteDezent = {
  color(240, 80, 95), color(220, 70, 85), color(200, 60, 90), color(190, 50, 80), color(210, 40, 95)
};

color[] paletteNeon = {
  color(0, 255, 255), color(255, 0, 255), color(0, 255, 0), color(255, 255, 0), color(255, 100, 255)
};

color[] paletteNight = {
  color(10, 20, 60), color(20, 40, 100), color(0, 60, 80), color(50, 30, 120), color(80, 20, 100)
};

// Aktuelle Palette
color[] currentPalette;

// Shape-Typ: 0 = Ellipse/Sphere, 1 = Rect/Box, 2 = Line
int shapeType = 0;

// Noise-Typ: 0=Perlin, 1=FBM, 2=Ridged, 3=Turbulence, 4=Voronoi (NEU)
int noiseType = 0;

// Display-Modus: 0=2D, 1=3D (NEU)
int displayMode = 0;

// Für 3D-Rotation
float rotY = 0;

// Funktion zur Erzeugung einer zufälligen Palette
color[] generateRandomPalette() {
  color[] randPalette = new color[5];
  for (int i = 0; i < 5; i++) {
    float hue = random(360);
    float sat = random(60, 100);
    float bri = random(70, 100);
    randPalette[i] = color(hue, sat, bri);
  }
  return randPalette;
}

// Noise-Funktionen (NEU)
float getNoise(float x, float y, float z) {
  if (noiseType == 0) {  // Standard Perlin
    return noise(x, y, z);
  } else if (noiseType == 1) {  // FBM
    float value = 0;
    float amp = 1;
    for (int i = 0; i < 5; i++) {  // 5 Oktaven
      value += noise(x * amp, y * amp, z) * amp;
      amp *= 0.5;
      x *= 2;
      y *= 2;
    }
    return value / 2.0;  // Normalisieren (ca. 0-1)
  } else if (noiseType == 2) {  // Ridged
    float n = noise(x, y, z);
    return 1 - abs(n * 2 - 1);  // Scharfe Kanten
  } else if (noiseType == 3) {  // Turbulence
    return abs(noise(x, y, z) * 2 - 1);
  } else if (noiseType == 4) {  // Vereinfachter Voronoi
    float minDist = 1;
    for (int i = 0; i < 5; i++) {  // 5 zufällige Punkte
      float px = noise(i * 10) * 2 - 1;
      float py = noise(i * 10 + 100) * 2 - 1;
      float dist = dist(x, y, px, py);
      if (dist < minDist) minDist = dist;
    }
    return minDist;
  }
  return 0;  // Fallback
}

void setup() {
  size(800, 800, P3D);  // P3D für 3D-Modus
  colorMode(HSB, 360, 100, 100);
  background(0);
  noStroke();
  hint(DISABLE_DEPTH_TEST);  // Für Overlay-Text

  // Zufällige Palette beim Start
  selectRandomPalette();

  // Zufälligen Shape und Noise
  shapeType = int(random(3));
  noiseType = int(random(5));
}

void draw() {
  background(0);
  timeOffset += 0.005;
  rotY += 0.01;  // Leichte Rotation für 3D

  int numParticles = (displayMode == 0) ? 30000 : 5000;  // Weniger in 3D für Perf.

  if (displayMode == 1) {  // 3D-Setup
    lights();
    translate(width/2, height/2, 0);
    rotateY(rotY);
    scale(0.8);  // Etwas verkleinern
  }

  for (int i = 0; i < numParticles; i++) {
    float x = random(-width/2, width/2);  // Zentriert für 3D
    float y = random(-height/2, height/2);
    float z = (displayMode == 1) ? random(-300, 300) : 0;  // Z für 3D

    float noiseVal = getNoise(x * noiseScale, y * noiseScale, timeOffset + z * noiseScale);

    // Zufällige Farbe
    int colIndex = int(random(currentPalette.length));
    color baseCol = currentPalette[colIndex];

    float hue = hue(baseCol) + noiseVal * 30 - 15;
    float sat = map(noiseVal, 0, 1, 60, 100);
    float bri = map(noiseVal, 0, 1, 40, 100);

    fill(hue, sat, bri, 180);

        // ... (Farbberechnung bleibt gleich) ...

    // Setze die Farbe für Linien mit stroke() statt fill()
    if (shapeType == 2) {
      stroke(hue, sat, bri, 180);  // Farbe + Transparenz
      noFill();                    // Sicherstellen, dass kein fill wirkt
    } else {
      fill(hue, sat, bri, 180);
      noStroke();                  // Für Ellipse/Rect/Box
    }

    // Zeichne basierend auf Shape und Modus
    float size = 8;
    if (shapeType == 0) {  // Ellipse/Sphere
      if (displayMode == 0) {
        ellipse(x + width/2, y + height/2, size, size);
      } else {
        pushMatrix();
        translate(x, y, z);
        sphere(size / 2);
        popMatrix();
      }
    } else if (shapeType == 1) {  // Rect/Box
      if (displayMode == 0) {
        rectMode(CENTER);
        rect(x + width/2, y + height/2, size, size);
      } else {
        pushMatrix();
        translate(x, y, z);
        box(size);
        popMatrix();
      }
    } else if (shapeType == 2) {  // Line
      float angle = noiseVal * TWO_PI;
      float len = map(noiseVal, 0, 1, 5, 20);
      if (displayMode == 0) {
        line(x + width/2, y + height/2,
             x + width/2 + cos(angle) * len,
             y + height/2 + sin(angle) * len);
      } else {
        pushMatrix();
        translate(x, y, z);
        line(0, 0, 0,
             cos(angle) * len,
             sin(angle) * len,
             sin(angle + PI/2) * len);
        popMatrix();
      }
    }
  }

  // Anzeige der Einstellungen
  fill(255);
  textSize(16);
  String paletteName = getPaletteName();
  String shapeName = shapeType == 0 ? "Ellipse/Sphere" : shapeType == 1 ? "Rect/Box" : "Line";
  String noiseName = new String[]{"Perlin", "FBM", "Ridged", "Turbulence", "Voronoi"}[noiseType];
  String modeName = displayMode == 0 ? "2D" : "3D";
  text("Palette: " + paletteName + " (r = neu)", 20, 30);
  text("Shape: " + shapeName + " (s = wechseln)", 20, 50);
  text("Noise: " + noiseName + " (n = wechseln)", 20, 70);
  text("Mode: " + modeName + " (m = wechseln)", 20, 90);
  text("Speichern: p", 20, 110);
}

// Funktion zur zufälligen Palette-Auswahl
void selectRandomPalette() {
  int rand = int(random(4));
  if (rand == 0) currentPalette = paletteDezent;
  else if (rand == 1) currentPalette = paletteNeon;
  else if (rand == 2) currentPalette = paletteNight;
  else currentPalette = generateRandomPalette();
}

// Hilfsfunktion für Palette-Namen
String getPaletteName() {
  if (currentPalette == paletteDezent) return "Dezent";
  else if (currentPalette == paletteNeon) return "Neon";
  else if (currentPalette == paletteNight) return "Night";
  else return "Random";
}

void keyPressed() {
  if (key == 'r') {
    selectRandomPalette();
  } else if (key == 's') {
    shapeType = (shapeType + 1) % 3;
  } else if (key == 'n') {
    noiseType = (noiseType + 1) % 5;  // Wechsle Noise-Typ
  } else if (key == 'm') {
    displayMode = 1 - displayMode;  // Toggle 2D/3D
  } else if (key == 'p') {
    saveFrame("generative_art-####.png");  // Speichern (NEU)
  }
}
