class Field {
  private float x, y, r;
  private Mass[][] mass;
  private boolean isTurn;
  
  Field () {
    this(8);
    mass[3][3].deploy(false);
    mass[4][3].deploy(true);
    mass[3][4].deploy(true);
    mass[4][4].deploy(false);
    
  }
  
  Field (int Size) {
    this(Size, 0f, 0f, 32f);
  }
  
  Field (int Size, float x, float y, float r) {
    if(Size < 0) return;
    mass = new Mass[Size][Size];
    for(int n = 0; n < mass.length; n++) {
      for(int m = 0; m < mass[0].length; m++) {
        mass[n][m] = new Mass();
      }
    }
    
    isTurn = false;
    
    set(x, y, r);
  }
  
  void set(float x, float y) {
    set(x, y, this.r);
  }
  
  void set(float x, float y, float r) {
    this.x = x;
    this.y = y;
    this.r = r;
  }
  
  void draw() {
    pushMatrix();
    translate(x, y);
    for(int n = 0; n < mass.length; n++) {
      for(int m = 0; m < mass[0].length; m++) {
        noFill();
        if(isDeploy(new int[]{n, m})) fill(128);
        stroke(0);
        rectMode(CORNER);
        rect(r * n, r * m, r, r);
        fill(128);
        text(n + "" + m, r * n, r * m);
        mass[n][m].draw(r * n, r * m, r);
      }
    }
    popMatrix();
  }
  
  void update() {
    isTurn = !isTurn;
  }
  
  int[] check(float x, float y) {
    int Row = floor((x - this.x) / r);
    int Col = floor((y - this.y) / r);
    if(!isValid(Row, Col)) return null;
    return new int[]{Row, Col};
  }
  
  boolean isValid(int x, int y) {
    return (isInRange(0, x, mass.length - 1) &&
         isInRange(0, y, mass[0].length - 1));
  }
  
  boolean isDeploy(int[] pos) {
    if(massID(pos) == null || massID(pos).isExsisted()) return false;
    for(int[] _dir: DIRECTION) {
      if(isReverse(new int[]{0}, new int[]{pos[0], pos[1]}, _dir)) return true;
    }
    return false;
  }
  
  void deploy(int[] pos) {
    if(massID(pos) == null) return;
    
    if(massID(pos).deploy(isTurn)) {
      for(int[] _dir: DIRECTION) {
        if(isReverse(new int[]{0}, new int[]{pos[0], pos[1]}, _dir)) 
          reverse(new int[]{pos[0], pos[1]}, _dir);
      }
    }
  }
  
  boolean isReverse(int[] times, int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    times[0]++;
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return false;
    if(massID(pos).isColor() != isTurn ) return isReverse(times, pos, direction);
    if(times[0] <= 1) return false;
    return true;
  }
  
  void reverse(int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return;
    if(massID(pos).isColor() == isTurn ) return;
    if(massID(pos).isColor() != isTurn ) { 
      massID(pos).reverse();
      reverse(pos, direction);
    }
    
  }
  
  Mass massID(int[] pos) {
    if(pos.length != 2) return null;
    if(!isValid(pos[0], pos[1])) return null;
    return mass[pos[0]][pos[1]];
  }
  
}

static boolean isInRange(float a, float b, float c) {
  return (a <= b && b <= c);
}