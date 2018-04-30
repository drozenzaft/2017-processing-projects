float x, y;
int size, speed;
boolean d1, d2 = false;

void setup() {
  size(720, 480);
  x = width/2;
  y = height/2;
  size = 30;
  speed = 2;
  fill(0, 0, 255);
}

void draw() {
  background(120);
  if (x >= width - size/2 || x <= size/2)
    d1 = !d1;
  if (d1)
    x += speed;
  else
    x -= speed;
  if (y >= height - size/2 || y <= size/2)
    d2 = !d2;
  if (d2)
    y += speed;
  else
    y -= speed;
  //ellipse(x, height/2, size, size);
  //ellipse(width/2, y, size, size);
  ellipse(x, y, size, size);
}