int[][] moves;
//identify kernel (no change)
int[][] noFilter = { 
  {0, 0, 0}, 
  {0, 1, 0}, 
  {0, 0, 0}};

//blur kernel
/*int[][] blur = {
  {1, 2, 1}, 
  {2, 4, 2}, 
  {1, 2, 1}};*/

//edge detection kernel
int[][] edge = { 
  {0, 1, 0}, 
  {1, -4, 1}, 
  {0, 1, 0} };
  
  int[][] blur = {
    {1, 4, 6, 4, 1},
    {4, 16, 24, 16, 4},
    {6, 24, 36, 24, 6},
    {4, 16, 24, 16, 4},
    {1, 4, 6, 4, 1}};

//sharpen kernel
int[][] sharpen = {
  {0, -1, 0}, 
  {-1, 5, -1}, 
  {0, -1, 0}};

int mode;

//mode 0: original
//mode 1: blur
//mode 2: edge detection
//mode 3: sharpen

PImage original, p;

int[][][] kernels = {noFilter, blur, edge, sharpen};


void setup() {
  size(1200, 600);
  original = loadImage("cat.jpg");
  original.resize(width/2, height);
  p = new PImage(original.width, original.height);
  p.resize(width/2, height);
  mode = 0;
  //moves = new int[][]{{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {0, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
  moves = new int[][]{
          {-3, -3}, {-2,-3}, {-1,-3}, {0,-3}, {1,-3}, {2,-3}, {3,-3},
          {-3, -2}, {-2,-2}, {-1,-2}, {0,-2}, {1,-2}, {2,-2}, {3,-2},
          {-3, -1}, {-2,-1}, {-1,-1}, {0,-1}, {1,-1}, {2,-1}, {3,-1},
          {-3, 0}, {-2,0}, {-1,0}, {0,0}, {1,0}, {2,0}, {3,0},
          {-3, 1}, {-2,1}, {-1,1}, {0,1}, {1,1}, {2,1}, {3,1},
          {-3, 2}, {-2,2}, {-1,2}, {0,2}, {1,2}, {2,2}, {3,2},
          {-3, 3}, {-2, 3}, {-1, 3}, {0,3}, {1,3}, {2,3}, {3,3},
          };
}

void draw() {
  image(original, 0, 0);
  //image(original, width/2, 0);
  processImage(p, kernels[mode], mode);
  image(p, width/2, 0);
}

void mouseClicked() {
  mode = (mode + 1) % 4;
}

int sum(int x, int y) {
  int ans = 0;
  for (int[] a : moves) ans += get(x+a[0], y+a[1]);
  return ans;
}

void processImage(PImage p, int[][] kernel, int mode) {
  println(mode);
  int sum = sum(kernel);
  for (int r = 0; r < height; r++) {
    for (int c = 0; c < width; c++) {
      int[] mult = mult(kernel, r, c);
      if (mode == 1) {
        if (sum > 1) {
          p.set(r,c,color(mult[0]/sum,mult[1]/sum,mult[2]/sum));
        }
        else {
          p.set(r, c, color(clamp(mult[0], 0, 255), clamp(mult[1], 0, 255), clamp(mult[2], 0, 255)));
        }
      }
      else if (mode == 2) p.set(r,c,color((clamp(mult[0],0,255)+clamp(mult[1],0,255)+clamp(mult[2],0,255))/3.0));  
      else p.set(r, c, color(clamp(mult[0], 0, 255), clamp(mult[1], 0, 255), clamp(mult[2], 0, 255)));
    }
  }
}

float clamp(float a, float min, float max) {
  if (a < max) {
    if (a > min) {
      return a;
    }
    else {
      return min;
    }
  }
  return max;
}

int[] mult(int[][] kernel, int x, int y) {
  float[] ans = new float[3];
  for (int i = 0; i < kernel.length; i++) {
    for (int j = 0; j < kernel[i].length; j++) {
      try {
        ans[0] += 1.0*kernel[i][j] * (red(get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
      }
      catch (IndexOutOfBoundsException e) {}
      try {
        ans[1] += 1.0*kernel[i][j] * (green(get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
      }
      catch (IndexOutOfBoundsException e) {}
      try {
        ans[2] += 1.0*kernel[i][j] * (blue(get(moves[i*3+j][0]+x, moves[i*3+j][1]+y)));
      }
      catch (IndexOutOfBoundsException e) {}
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