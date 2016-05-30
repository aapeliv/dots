import ddf.minim.*;
import com.hamoid.*;

AudioPlayer player;
Minim minim;

VideoExport videoExport;

boolean display = true;
boolean export = true;
float myFrameRate = 60;

ArrayList<Dot> dots;
ArrayList<Effect> effects;

int cW = 1920;
int cH = 1080;

float maxRadius = 30;
float minRadius = 1;

float time = 0;
int effectCounter = 0;
int startMillis;

String eName;

String exportName() {
  return "Dots" + String.valueOf(year()) + String.valueOf(month()) + String.valueOf(day()) + String.valueOf(hour()) + String.valueOf(minute()) + String.valueOf(second());
}

void setup() {
  randomSeed(0);

  size(1920, 1080);
  dots = new ArrayList<Dot>();
  dots.clear();

  FillRandomDots(maxRadius, minRadius);

  effects = new ArrayList<Effect>();

  effects.add(new Tint(0.2, 0.8, 0.2, 0.8, 0.6, 1));
  effects.add(new MainEffect(maxRadius));

  eName = exportName();

  createEffectsFromMusic("bubbles.mp3");

  if (export) {
    frameRate(myFrameRate);

    videoExport = new VideoExport(this, eName + ".mp4");
    videoExport.setFrameRate(myFrameRate);  

    time = 0; //startAutoTime;

    Bubbles(0);

    sM = 0;
  } else {
    minim = new Minim(this);
    player = minim.loadFile("bubbles.mp3", 2048);
    if (display) {
      player.play();
      Bubbles(0);
      startMillis = millis();
    }
  }
}

void draw() {
  if (export) {
    time += 1.0 / myFrameRate;
  } else {
    time = ((float) millis() - startMillis) / 1000;
  }

  print(time + "\n");

  background(0);
  Dot dot;
  int aMax = effects.size();
  for (int i = dots.size()-1; i >= 0; i--) {
    dot = dots.get(i);
    for (int a = 0; a < aMax; a++) {
      dot = effects.get(a).ApplyCheck(time, dot);
    }
    dot.DrawDot();
  }

  if (export) {
    loadPixels();
    videoExport.saveFrame();
    updatePixels();
  }
}

void mouseMoved() {
  /*
  print("\n");
   print(mouseX);
   print(",");
   print(mouseY);
   print(",");
   
   int closest = 0;
   float dist = 100;
   for (int i = dots.size()-1; i >= 0; i--) {
   float d = dots.get(i).Dist(mouseX, mouseY);
   if (d < dist) {
   closest = i;
   dist = d;
   }
   }
   
   print(closest);
   print(",");
   print(dots.get(closest).x);
   print(",");
   print(dots.get(closest).y);
   */
  //p.SetCenter(mouseX, mouseY);
}

void mouseClicked() {
  //effects.add(new ContractRipple(time, mouseX, mouseY, 0.2, 100, 100, 50, 400));
  if (!export && !display) {
    //newDots();
    //redraw();

    //Bubbles(time);

    //player.play();
    //sM = millis();

    //effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 0, 25, maxRadius, minRadius));
    //effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 0, 25, maxRadius, minRadius));
    effectCounter = 8;
    switch (effectCounter % 9) {
    case 0:
      //specialDotEffects.add(new Retract(time, 10, 0.5));
      break;
    case 1:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 0, 250, maxRadius, minRadius));
      break;
    case 2:
      effects.add(new ZoomRipple(time, mouseX, mouseY, 0.2, 50, 250, 200));
      break;
    case 3:
      effects.add(new FlashRipple(time, mouseX, mouseY, 1, 50, 250, 200));
      break;
    case 4:
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 0, 250, maxRadius, minRadius));
      break;
    case 5:
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 0, 200, maxRadius, minRadius));
      effects.add(new ZoomRipple(time, mouseX, mouseY, 0.2, 50, 250, 200));
      effects.add(new FlashRipple(time, mouseX, mouseY, 1, 50, 250, 200));
      break;
    case 6:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 0, 250, maxRadius, minRadius));
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 0, 250, maxRadius, minRadius));
      break;
    case 7:
      effects.add(new BigBallsContractRipple(time, mouseX, mouseY, 0.2, 100, 0, 50, maxRadius, minRadius));
      effects.add(new SmallDotsFlashRipple(time, mouseX, mouseY, 1, 100, 0, 50, maxRadius, minRadius));
      break;
    case 8:
      effects.add(new ContractRipple(time, mouseX, mouseY, 0.5, 100, 100, 500));
      break;
    }

    effectCounter++;

    //effects.add(new FlashRipple(time, mouseX, mouseY, 1, 50, 250, 20));
    //effects.add(new ZoomRipple(time, mouseX, mouseY, 0.1, 50, 250, 20));
  }
}

float SmoothTransition(float x) {
  return x < 0 ? 0 : (x > 1 ? 1 : 3*x*x - 2*x*x*x);
}

float SmoothSymmetricBump(float x) {
  return (abs(x) < 1) ? (1 + cos(PI * x)) / 2 : 0;
}

float Parabola(float x) {
  return x < 0 ? 0 : (x > 1 ? 0 : 4*x*(1-x));
}

void FillRandomDots(float maxRadius, float minRadius) {
  int startDots = dots.size();

  float radius = maxRadius;
  float noRadii = maxRadius - minRadius;
  while (radius > minRadius) {
    float surfaceArea = 0;
    int fails = 0;
    while (fails < 1000*(maxRadius - radius) && surfaceArea < cW * cH / noRadii) {
      int x = round(random(0, cW));
      int y = round(random(0, cH));

      boolean intersect = false;
      for (int i = dots.size()-1; i >= 0; i--) {
        Dot dot = dots.get(i);
        if (dot.Intersect(x, y, radius)) {
          intersect = true;
          i = 0;
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