import processing.video.*;
int[][] moves;
//identify kernel (no change)
int[][] noFilter = { 
  {0, 0, 0}, 
  {0, 1, 0}, 
  {0, 0, 0}};

//blur kernel
int[][] blur = {
  {1, 4, 6, 4, 1}, 
  {4, 16, 24, 16, 4}, 
  {6, 24, 36, 24, 6}, 
  {4, 16, 24, 16, 4}, 
  {1, 4, 6, 4, 1}};

//edge detection kernel
int[][] edge = { 
  {0, 1, 0}, 
  {1, -4, 1}, 
  {0, 1, 0} };

//sharpen kernel
int[][] sharpen = {
  {0, -1, 0}, 
  {-1, 5, -1}, 
  {0, -1, 0}};

int mode;

//mode 0: cam
//mode 1: blur
//mode 2: edge detection
//mode 3: sharpen

PImage p, q, r, s;

int[][][] kernels = {noFilter, blur, edge, sharpen};
Capture cam;

void setup() {
  size(640, 360);

  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(i + " " + cameras[i]);
    }
    mode = 0;
    moves = new int[][]{
      {-3, -3}, {-2, -3}, {-1, -3}, {0, -3}, {1, -3}, {2, -3}, {3, -3}, 
      {-3, -2}, {-2, -2}, {-1, -2}, {0, -2}, {1, -2}, {2, -2}, {3, -2}, 
      {-3, -1}, {-2, -1}, {-1, -1}, {0, -1}, {1, -1}, {2, -1}, {3, -1}, 
      {-3, 0}, {-2, 0}, {-1, 0}, {0, 0}, {1, 0}, {2, 0}, {3, 0}, 
      {-3, 1}, {-2, 1}, {-1, 1}, {0, 1}, {1, 1}, {2, 1}, {3, 1}, 
      {-3, 2}, {-2, 2}, {-1, 2}, {0, 2}, {1, 2}, {2, 2}, {3, 2}, 
      {-3, 3}, {-2, 3}, {-1, 3}, {0, 3}, {1, 3}, {2, 3}, {3, 3}, 
    };
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[3]);
    p = new PImage(width, height);
    q = new PImage(width, height);
    r = new PImage(width, height);
    s = new PImage(width, height);
    cam.start();
  }
}

void draw() {
  if (cam.available() == true) {
    cam.read();
  } 
  processImage(cam, p, kernels[mode], mode);
  blu(p, q);
  mirror(q, r);
  set(0, 0, r);
}

void mouseClicked() {
  mode = (mode + 1) % 4;
}

int sum(int x, int y) {
  int ans = 0;
  for (int[] a : moves) ans += get(x+a[0], y+a[1]);
  return ans;
}

void processImage(PImage cam, PImage p, int[][] kernel, int mode) {
  int sum = sum(kernel);
  for (int r = 0; r < width; r++) {
    for (int c = 0; c < height; c++) {
      int[] mult = mult(cam, kernel, r, c);
      if (mode == 1) {
        if (sum > 1) {
          p.set(r, c, color(mult[0]/sum, mult[1]/sum, mult[2]/sum));
        } else {
          p.set(r, c, color(clamp(mult[0], 0, 255), clamp(mult[1], 0, 255), clamp(mult[2], 0, 255)));
        }
      } else if (mode == 2) p.set(r, c, color((clamp(mult[0], 0, 255)+clamp(mult[1], 0, 255)+clamp(mult[2], 0, 255))/3.0));
      else p.set(r, c, color(clamp(mult[0], 0, 255), clamp(mult[1], 0, 255), clamp(mult[2], 0, 255)));
    }
  }
}

void mirror(PImage original, PImage q) {
  //PImage p = new PImage(width, height);
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      q.set(c, r, original.get(width-c, height-r));
    }
  }
}

  /*void dub(PImage original, PImage p, PImage q) {
   for (int r = 0; r < height; r++) {
   for (int c = 0; c <= width/2; c++) {
   p.set(c, r, original.get(width-c, height-r));
   p.set(width-c, r, p.get(c, r));
   }
   for (int d = width/2; d < width; d++) {
   q.set(d, r, original.get(width-d, height-r));
   //p.set(width-d, r, p.get(d, r));
   }
   }
   }*/

  void blu(PImage original, PImage p) {
    color co;
    for (int r = 0; r < height; r++) {
      for (int c = 0; c < width; c++) {
        co = original.get(c, r);
        p.set(c, r, color((red(co)+green(co)+blue(co)/3), 0, (red(co)+green(co)+blue(co)/3)));
      }
    }
  }

  float clamp(float a, float min, float max) {
    if (a < max) {
      if (a > min) {
        return a;
      } else {
        return min;
      }
    }
    return max;
  }

  int[] mult(PImage cam, int[][] kernel, int x, int y) {
    float[] ans = new float[3];
    for (int i = 0; i < kernel.length; i++) {
      for (int j = 0; j < kernel[i].length; j++) {
        ans[0] += 1.0*kernel[i][j] * (red(cam.get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
        ans[1] += 1.0*kernel[i][j] * (green(cam.get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
        ans[2] += 1.0*kernel[i][j] * (blue(cam.get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
      }
    }
    return new int[]{(int)ans[0], (int)ans[1], (int)ans[2]};
  }

  int sum(int[][] kernel) {
    int ans = 0;
    for (int[] a : kernel) {
      for (int b : a) ans += b;
    }
    return ans;
  }