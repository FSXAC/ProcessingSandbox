class Terrain {
  private int size;
  private float[] map;

  // constructor
  Terrain(int size) {
    this.size = size;
    this.map  = new float[size * size + 1];

    // generate random terrain
    this.generate();
  }

  // Generates random terrain and saves to a map array
  public void generate() {
    for (int y = 0; y < this.size; y++) {
      for (int x = 0; x < this.size; x++) {
        this.map[y * this.size + x] = T_AMP * noise(x * T_RES, y * T_RES);
      }
    }
  }

  // returns the height at specific x and y
  private float get(int x, int y) {
    if (x < 0 && y >= 0 && y < this.size)               return get(x + 1, y);
    else if (x >= 0 && y < 0 && x < this.size)          return get(x, y + 1);
    else if (y >= 0 && x >= this.size && y < this.size) return get(x - 1, y);
    else if (x >= 0 && x < this.size && y >= this.size) return get(x, y - 1);
    else if (x < 0 && y < 0)                            return get(0, 0);
    else if (x >= this.size && y >= this.size)          return get(x - 1, y - 1);
    else                                                return map[y * size + x];
  }

  private void fillWater(float level) {
    if (level < T_THRES)
      // set water depth color
      fill(lerpColor(
        color(58, 42, 14),
        color(224, 219, 197),
        map(level, 0, T_THRES, 0, 1))
      );
    else fill(255);
  }

  public void display() {
    for (int y = 0; y < this.size; y++) {
      for (int x = 0; x < this.size; x++) {
        // draw triangle and verticies
        beginShape(TRIANGLE_FAN);
        fillWater(this.get(x, y));
        vertex(x * T_SIZE,       this.get(x, y),     y * T_SIZE);
        fillWater(this.get(x+1, y));
        vertex((x + 1) * T_SIZE, this.get(x + 1, y), y * T_SIZE);
        fillWater(this.get(x, y+1));
        vertex(x * T_SIZE,       this.get(x, y + 1), (y + 1) * T_SIZE);
        endShape(CLOSE);

        // second half of the triangle
        beginShape(TRIANGLE_FAN);
        fillWater(this.get(x+1, y));
        vertex((x + 1) * T_SIZE, get(x + 1, y),     y * T_SIZE);
        fillWater(this.get(x, y+1));
        vertex(x * T_SIZE,       get(x, y + 1),     (y + 1) * T_SIZE);
        fillWater(this.get(x+1, y+1));
        vertex((x + 1) * T_SIZE, get(x + 1, y + 1), (y + 1) * T_SIZE);
        endShape(CLOSE);
      }
    }
  }
}
