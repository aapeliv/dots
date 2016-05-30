class Effect {
  float startTime, endTime;
  
  Effect(float startTimeS, float endTimeS) {
    startTime = startTimeS;
    endTime = endTimeS;
  }
  
  Dot Apply(float t, Dot dot) {
    return dot;
  }
  
  Dot ApplyCheck(float t, Dot dot) {
    return ((t >= startTime && t <= endTime) || (t >= startTime && endTime == 0)) ? Apply(t, dot) : dot;
  }
}

class Dot {
  float x, y, r, red, green, blue;

  Dot(float xP, float yP, float rP, float redP, float greenP, float blueP) {
    x = xP;
    y = yP;
    r = rP;
    red = redP;
    green = greenP;
    blue = blueP;
  }

  boolean Intersect(float x2, float y2, float r2) {
    return (x - x2) * (x - x2) + (y - y2) * (y - y2) < (r + r2) * (r + r2);
  }

  float Dist(float x2, float y2) {
    return sqrt((x - x2) * (x - x2) + (y - y2) * (y - y2));
  }

  void DrawDot() {
    fill(color(red * 255, green * 255, blue * 255));
    noStroke();
    ellipse(x, y, 2*r, 2*r);
  }
}