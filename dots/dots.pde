/* Copyright (C) 2016  Aapeli Vuorinen

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>. */

// For music playback
import ddf.minim.*;
// For mp4 output
import com.hamoid.*;

AudioPlayer player;
Minim minim;

VideoExport videoExport;

// Display means it's displaying the bubbles animation
boolean display = false;
// Export means that it'll export to an .mp4 file
boolean export = false;
// Export framerate
float myFrameRate = 60;

ArrayList<Dot> dots;
ArrayList<Effect> effects;

// Screen setup (remember to update this on the second line of setup()) as
// well... for some reason it won't let me use variables in it
int cW = 600;
int cH = 400;

// Settings for automatically generated dots
float maxRadius = 30;
float minRadius = 1;

// Timing
float time = 0;
int startMillis;

// Create a unique name from the current time
String eName;
String exportName() {
  return "Dots" + String.valueOf(year()) + String.valueOf(month()) + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
}

void setup() {
  // 'cos we want determinacy
  randomSeed(0);

  size(600, 400);
  dots = new ArrayList<Dot>();
  dots.clear();

  // Create random dots
  FillRandomDots(maxRadius, minRadius);

  // Initalise effects and create the basic time-independent effects
  effects = new ArrayList<Effect>();
  effects.add(new Tint(0.2, 0.8, 0.2, 0.8, 0.6, 1));
  effects.add(new MainEffect(maxRadius));

  // Set exportname
  eName = exportName();

  // If we are displaying the animation, create the effects
  if (display) {
    // First 15 seconds, see bubbles.pde
    Bubbles(0);
    // The rest, see fromMusic.pde
    createEffectsFromMusic("bubbles.mp3");
  }

  // If we are exporting, setup export
  if (export) {
    frameRate(myFrameRate);

    videoExport = new VideoExport(this, eName + ".mp4");
    videoExport.setFrameRate(myFrameRate);

    time = 0;
  }

  // If we are not exporting, but just viewing the animation, play the music
  // !export because that's not realtime
  if (!export && display) {
    minim = new Minim(this);
    player = minim.loadFile("bubbles.mp3", 2048);
    startMillis = millis();
  }
}

// Main animation loop
void draw() {
  if (export) {
    time += 1.0 / myFrameRate;
  } else {
    // Try and stay with time
    time = ((float) millis() - startMillis) / 1000;
  }

  print(time + "\n");

  // Clear the screen
  background(0);

  // Not sure how expensive this is to compute, so we'll just do it once
  int aMax = effects.size();

  // Draw each dot
  for (int i = dots.size()-1; i >= 0; i--) {
    Dot dot = dots.get(i);
    // Apply every effect to the Dot
    for (int a = 0; a < aMax; a++) {
      dot = effects.get(a).ApplyCheck(time, dot);
    }
    // Finally draw the result
    dot.DrawDot();
  }

  // If we are exporting, create a frame and save it
  if (export) {
    loadPixels();
    videoExport.saveFrame();
    updatePixels();
  }
}

// If not exporting or displaying the animation, clicking the mouse will cycle
// through a couple of different effects.
int effectCounter = 0;
void mouseClicked() {
  if (!export && !display) {
    switch (effectCounter % 8) {
    case 0:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 200, 250, maxRadius, minRadius));
      break;
    case 1:
      effects.add(new ZoomRipple(time, mouseX, mouseY, 0.2, 50, 250, 200));
      break;
    case 2:
      effects.add(new FlashRipple(time, mouseX, mouseY, 1, 50, 250, 200));
      break;
    case 3:
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 200, 250, maxRadius, minRadius));
      break;
    case 4:
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 200, 200, maxRadius, minRadius));
      effects.add(new ZoomRipple(time, mouseX, mouseY, 0.2, 50, 250, 200));
      effects.add(new FlashRipple(time, mouseX, mouseY, 1, 50, 250, 200));
      break;
    case 5:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 200, 250, maxRadius, minRadius));
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 200, 250, maxRadius, minRadius));
      break;
    case 6:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 200, 50, maxRadius, minRadius));
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 200, 50, maxRadius, minRadius));
      break;
    case 7:
      effects.add(new ContractRipple(time, mouseX, mouseY, 0.5, 100, 100, 500));
      break;
    }

    effectCounter++;
  }
}

// This is a "smoothened" version of y = x, basically it has derivative 0 at
// both 0 and 1. It makes the animation look nicer. Note that smooth doesn't
// actually mean C^\infty. It's just y = 3x^2 - 2x^3 (normalised integral of
// x(1-x))
float SmoothTransition(float x) {
  return x < 0 ? 0 : (x > 1 ? 1 : 3*x*x - 2*x*x*x);
}

// This is 0 outside 1 and then smoothly goes up to 1 at 0. Derivative at 0, 1,
// and -1 is 0. Again, not actually smooth as in C^\infty.
float SmoothSymmetricBump(float x) {
  return (abs(x) < 1) ? (1 + cos(PI * x)) / 2 : 0;
}

// Normalise parabola x(1-x). Peaks at x = 1/2.
float Parabola(float x) {
  return x < 0 ? 0 : (x > 1 ? 0 : 4*x*(1-x));
}

// Randomly add dots to fill the screen. The algorithm is pretty
// straightforward, given a radius, you just pick random points, and check if
// you can stick a Dot there. If not, pick another point, if it works, then
// you put it there. It will start from the maximum radius and go down in
// increments of 1, and will try a few thousand times or until it takes it's
// own proportion of the surface area of the screen.
void FillRandomDots(float maxRadius, float minRadius) {
  int startDots = dots.size();

  float radius = maxRadius;
  float noRadii = maxRadius - minRadius;
  while (radius > minRadius) {
    float surfaceArea = 0;
    int fails = 0;
    while (fails < 1000 * (maxRadius - radius) && surfaceArea < cW * cH / noRadii) {
      int x = round(random(0, cW));
      int y = round(random(0, cH));

      boolean intersect = false;
      for (int i = dots.size()-1; i >= 0; i--) {
        Dot dot = dots.get(i);
        if (dot.Intersect(x, y, radius)) {
          intersect = true;
          // Get out of the loop
          i = -1;
        }
      }

      if (intersect) {
        fails++;
      } else {
        dots.add(new Dot(x, y, radius, random(0, 1), random(0, 1), random(0, 1)));
        surfaceArea += PI*radius*radius;
      }
    }
    radius -= 1;
  }

  print("Added " + (dots.size() - startDots) + " dots.\n");
}
