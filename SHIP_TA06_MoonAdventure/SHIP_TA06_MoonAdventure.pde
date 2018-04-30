import gab.opencv.*;
import processing.video.*;

Movie video;
OpenCV opencv;
float sourceX, sourceY, destX, destY;
PImage moon;
void setup() {
  size(640, 428);
  video = new Movie(this, "street.mov");
  opencv = new OpenCV(this, 720, 480);
  moon = loadImage("moon.jpg");
  moon.resize(640, 428);
  opencv.startBackgroundSubtraction(5, 3, 0.5);
  sourceX = -1;
  sourceY = -1;
  video.loop();
  video.play();
}

void draw() {
  image(video, 0, 0);  
  opencv.loadImage(video);

  opencv.updateBackground();

  opencv.dilate();
  opencv.erode();
  fill(255, 0, 0);
  stroke(255, 0, 0);
  strokeWeight(2);
  for (Contour contour : opencv.findContours()) {
    contour.draw();
  }
  mD();
  moonScreen();
  replaceRed();
}

void movieEvent(Movie m) {
  m.read();
}

void moonScreen() {
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      if (get(c, r) != color(255, 0, 0)) {
        set(c, r, color(moon.get(c, r)));
      }
    }
  }
}

void replaceRed() {
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      if (get(c, r) == color(255, 0, 0)) {
        set(c, r, video.get(c, r));
      }
    }
  }
}

void mousePressed() {
  sourceX = mouseX;
  sourceY = mouseY;
}

void mD() {
  int[][] edges = new int[][] {{10000000, 1000000}, {10000000, 100000000}, {
    -100000,-100000}, {-1000000000, -1000000000}}; //left, up, right, down
  float highDist = 1000900000;
  int[] coord = {-1, -1};
  if (mousePressed) {
    if (sourceX >= 0 && sourceY >= 0) {
      for (int r = (int)sourceY-25; r <= (int)sourceY+25; r++) {
        for (int c = (int)sourceX-25; c <= (int)sourceX+25; c++) {
          if (get(c, r) == color(255, 0, 0)) {
            if (c < edges[0][0]) {
              edges[0][0] = c;
              edges[0][1] = r;
            }
            if (r < edges[1][1]) {
              edges[1][0] = c;
              edges[1][1] = r;
            }
            if (c > edges[2][0]) {
              edges[2][0] = c;
              edges[2][1] = r;
            }
            if (r > edges[3][1]) {
              edges[3][0] = c;
              edges[3][1] = r;
            }
          }
          set((int)mouseX+c-(int)sourceX, (int)mouseY+r-(int)sourceY, get(c, r));
          set(c, r, moon.get(c, r));
        }
      }
    }
  } 
  else {
    if (sourceX >= 0 && sourceY >= 0) {
      for (int r = (int)sourceY-25; r <= (int)sourceY+25; r++) {
        for (int c = (int)sourceX-25; c <= (int)sourceX+25; c++) {
          if (get(c, r) == color(255, 0, 0)) {
            if (c < edges[0][0]) {
              edges[0][0] = c;
              edges[0][1] = r;
            }
            if (r < edges[1][1]) {
              edges[1][0] = c;
              edges[1][1] = r;
            }
            if (c > edges[2][0]) {
              edges[2][0] = c;
              edges[2][1] = r;
            }
            if (r > edges[3][1]) {
              edges[3][0] = c;
              edges[3][1] = r;
            }
          }
          set((int)destX+c-(int)sourceX, (int)destY+r-(int)sourceY, get(c, r));
          set(c, r, moon.get(c, r));
        }
      }
    }
  }
  for (int i = 0; i < edges.length; i++) {
    float d = dist(sourceX, sourceY, edges[i][0], edges[i][1]);
    if (d < highDist) {
      highDist = d;
      coord[0] = edges[i][0];
      coord[1] = edges[i][1];
    }
  }
  destX += sourceX - coord[0];
  destY += sourceY - coord[1];
  sourceX = coord[0];
  sourceY = coord[1];
}

void mouseReleased() {
  destX = mouseX;
  destY = mouseY;
}