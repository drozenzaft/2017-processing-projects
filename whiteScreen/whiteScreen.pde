import processing.video.*;
Capture cam;
int iteration;
PImage moon, img;
color replace, next;
boolean debugging = false;
boolean WHITESCREEN = false;

void setup() {
  size(1280, 720);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + ": " + cameras[i]);
    }
    cam = new Capture(this, cameras[0]);
    cam.start();

    // Image used by default
    moon = loadImage("moon.jpg");
    moon.resize(width, height);
    img = new PImage(width, height);
  }
}

void draw() {
  moon = loadImage("data/frame_" + iteration + ".png");
  moon.resize(width,height);
  // For user control
  if (mousePressed) {
    if (mouseButton == LEFT) replace = cam.get((int)mouseX, (int)mouseY);
    if (mouseButton == RIGHT) next = cam.get((int)mouseX, (int)mouseY);

    if (debugging) {
      //println(avgRGB(cam.get((int)mouseX, (int)mouseY)) + ", " +stdDev(cam.get((int)mouseX, (int)mouseY)));
      println(red(get((int)mouseX, (int)mouseY))+", "+green(get((int)mouseX, (int)mouseY)) +", " + blue(get((int)mouseX, (int)mouseY)));
    }
  }

  if (cam.available()) {
    cam.read();
  }

  //Do color swap if applicable, else use the moon
  if (WHITESCREEN) {
    whiteScreen();
  } else {
    if (next == 0) screen(replace);
    else screenReplace(replace, next);
  }
  set(0, 0, img);
  iteration = (iteration + 1) % 8;
}

// Reset to moon 
void keyPressed() {
  if (keyCode == ENTER) next = 0;
}

// Replaces a given color range (centered at "input") with the moon
void screen(color input) {
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      color a = cam.get(c, r);
      if (abs(red(input)-red(a)) <= 25 && abs(green(input)-green(a)) <= 25 && abs(blue(input)-blue(a)) <= 30) {
        img.set(c, r, moon.get(c, r));
      } else {
        img.set(c, r, cam.get(c, r));
      }
    }
  }
}

// Replaces a given color range (centered at "input") with a specified color
void screenReplace(color input, color next) {
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      color a = cam.get(c, r);
      if (abs(red(input)-red(a)) <= 25 && abs(green(input)-green(a)) <= 25 && abs(blue(input)-blue(a)) <= 30) {
        img.set(c, r, next);
      } else {
        img.set(c, r, cam.get(c, r));
      }
    }
  }
}

// Calculates average brightness of a color
float avgRGB(color c) {
  return (red(c)+green(c)+blue(c))/3.0;
}

// Works only on white, but especially well
void whiteScreen() {
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      color a = cam.get(c, r);
      boolean b = (abs(156.5-red(a)) <= 25 && abs(153-green(a)) <= 25 && abs(147.5-blue(a)) <= 30);
      if ((avgRGB(a) >= 62 && stdDev(a) < 10) || b) {
        img.set(c, r, moon.get(c, r));
      } else {
        img.set(c, r, cam.get(c, r));
      }
    }
  }
}

// Finds the variance of a color
float getVariance(color c) {
  float mean = avgRGB(c);
  float[] data = {red(c), green(c), blue(c)};
  float temp = 0;
  for (float a : data)
    temp += (a-mean)*(a-mean);
  return temp/3;
}

// Finds the standard devation of a color
float stdDev(color c) {
  return (float)(Math.sqrt(getVariance(c)));
}