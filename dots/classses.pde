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

// This is the basic class of the project. A Dot simply has a location, a radius
// and a color. They are programmatically generated in a FillRandomDots in
// dots.pde. At render time, each Effect is applied to each Dot.
class Dot {
  // Position as (x,y) and radius r
  // Colors are stored as floats between 0 and 1.
  float x, y, r, red, green, blue;

  Dot(float xP, float yP, float rP, float redP, float greenP, float blueP) {
    x = xP;
    y = yP;
    r = rP;
    red = redP;
    green = greenP;
    blue = blueP;
  }

  // Check whether the Dot intersects a disk at (x2, y2) with radius r2.
  boolean Intersect(float x2, float y2, float r2) {
    // If you do this you don't have to use sqrt
    return (x - x2) * (x - x2) + (y - y2) * (y - y2) < (r + r2) * (r + r2);
  }

  // Distance from the center to (x2, y2)
  float Dist(float x2, float y2) {
    return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));
  }

  // Finally draw the Dot
  void DrawDot() {
    fill(color(red * 255, green * 255, blue * 255));
    noStroke();
    ellipse(x, y, 2*r, 2*r);
  }
}

// An Effect is applied to each Dot at each frame, they can manipulate the dot
// however they want to. The main thing here is the Apply function, which gets
// a time and a Dot, and returns a modified Dot. See effects.pde for examples.
class Effect {
  // These are just for performance improvements
  // endTime == 0 means the effect is active indefinitely
  float startTime, endTime;

  Effect(float startTimeS, float endTimeS) {
    startTime = startTimeS;
    endTime = endTimeS;
  }

  // This is the key part of the Effect
  Dot Apply(float t, Dot dot) {
    return dot;
  }

  // This is for performance, it'll check that the effect is "active" before
  // applying it.
  Dot ApplyCheck(float t, Dot dot) {
    return ((t >= startTime && t <= endTime) || (t >= startTime && endTime == 0)) ? Apply(t, dot) : dot;
  }
}
