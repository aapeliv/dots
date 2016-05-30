/*

 void FillRandomDots(float maxRadius, float minRadius) {
 float radius = maxRadius;
 while (radius > minRadius) {
 int fails = 0;
 int count = 0;
 while (fails < (2501-radius*radius)*50 && count < 50*50+1-radius*radius) {
 int x = round(random(0, cW));
 int y = round(random(0, cH));
 
 boolean intersect = false;
 for (int i = dots.size()-1; i >= 0; i--) {
 Dot dot = dots.get(i);
 if (dot.Intersect(x, y, radius)) {
 intersect = true;
 }
 }
 
 if (intersect) {
 fails++;
 } else {
 color c = color(random(0, 255), random(0, 255), random(0, 255));
 dots.add(new Dot(x, y, radius, c));
 count++;
 }
 }
 radius -= radius*0.2;
 }
 }
 
 */