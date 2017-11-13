class Field {
  //フィールド
  private float x, y, r;    //盤の位置・大きさ
  private Mass[][] mass;    //盤
  private boolean isTurn;   //手番
  private byte rule;        //ルール
  private int deployedKind;
  
  //メソッド
  //コンストラクタ
  Field () {
    this(8);
  }
  
  Field (int Size) {
    this(Size, 0f, 0f, 32f);
  }
  
  Field (int Size, float x, float y, float r) {
    if(Size < 0) Size = 8;
    mass = new Mass[Size][Size];
    for(int n = 0; n < mass.length; n++) {
      for(int m = 0; m < mass[0].length; m++) {
        mass[n][m] = new Mass();
      }
    }
    
    setRule((byte)(0x00));
    isTurn = false;
    init();
    
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
  
  void setRule(byte rule) {
    this.rule = rule;
  }
  
  void init() {
    int[] pos = new int[]{ceil(mass.length / 2) - 1, ceil(mass.length / 2) - 1};
    for(int n = 0; n < 2; n++) {
      for(int m = 0; m < 2; m++) {
        if(massID(new int[]{ pos[0] + n, pos[1] + m }) != null)
        mass[pos[0] + n][pos[1] + m].deploy((n == m) ^ isRulePos(), (n == m) ^ isRulePos());
      }
    }
  }
  
  //ルール
  boolean isRuleValid() {
    return ((rule & Rule.ISVALID) == Rule.ISVALID);
  }
  
  boolean isRuleNormal() {
    return (isRuleValid() && (rule & Rule.ISNORMAL) == Rule.ISNORMAL);
  }
  
  boolean isRuleSimple() {
    return (isRuleValid() && (rule & Rule.ISSIMPLE) == Rule.ISSIMPLE);
  }
  
  boolean isRuleBlackShape() {
    return (isRuleValid() && (rule & Rule.ISBLACK) == Rule.ISBLACK);
  }
  
  boolean isRuleWhiteShape() {
    return (isRuleValid() && (rule & Rule.ISWHITE) == Rule.ISWHITE);
  }
  
  boolean isRulePos() {
    return (isRuleValid() && (rule & Rule.ISPOSITION) == Rule.ISPOSITION);
  }
  
  boolean isTurn() {
    return isTurn;
  }
  
  void setFrame(int deployedFrame) {
    
    if(isInRange(0, deployedFrame, 2)) deployedKind = deployedFrame;
  }      
  
  //メイン
  void draw() {
    pushMatrix();
    translate(x, y);
    rectMode(CORNER);
    fill(32, 188, 32);
    strokeWeight(1f * rateY);
    rect(0, 0, r * mass.length, r * mass[0].length);
    int PointPos = 0;
    while(PointPos * 4 <= mass.length / 2) {
      for(int n = 0; n < 4; n++) {
        circle(r * 2 * ((n % 2 == 0) ? (mass.length / 2 - 1 - PointPos) : (1 + PointPos)),
          r * 2 * ((n / 2 == 0) ? (mass.length / 2 - 1 - PointPos) : (1 + PointPos)), r * 0.05);
      }
      PointPos++;
    }
    for(int n = 0; n < mass.length; n++) {
      for(int m = 0; m < mass[0].length; m++) {
        noFill();
        if(isDeploy(-1, new int[]{n, m})) fill(0, 64, 0, 128);
        stroke(0);
        rect(r * n, r * m, r, r);
        fill(128);
        //text(n + "" + m, r * n, r * m);
        mass[n][m].draw(r * n, r * m, r);
      }
    }
    popMatrix();
  }
  
  void update() {
    isTurn = !isTurn;
  }
  
  //機能
  //画面の座標からマスを計算
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
  
  boolean isDeploy(int deployedFrame, int[] pos) {
    setFrame(deployedFrame);
    if(massID(pos) == null || massID(pos).isExsisted()) return false;
    for(int[] _dir: DIRECTION) {
      if(isReverse(new int[]{pos[0], pos[1]}, _dir)) return true;
    }
    return false;
  }
  
  boolean isDeployColor() {
    return isDeployColor(isTurn, deployedKind);
  }
  boolean isDeployColor(boolean isTurn, int deployedKind) {
    return isTurn ^ (deployedKind == 2);
  }
  
  boolean isDeployShape() {
    return isDeployShape(isTurn, deployedKind);
  }
  boolean isDeployShape(boolean isTurn, int deployedKind) {
    return isTurn ^ (deployedKind == 1);
  }
  
  void deploy(int deployedFrame, int[] pos) {
    setFrame(deployedFrame);
    if(massID(pos) == null) return;
    
    if(massID(pos).deploy(isDeployColor(), isDeployShape())) {
      for(int[] _dir: DIRECTION) {
        if(isReverse(new int[]{pos[0], pos[1]}, _dir)) 
          reverse(new int[]{pos[0], pos[1]}, _dir);
      }
    }
  }
  
  boolean isReverse(int[] pos, final int[] direction) {
    return isReverseColor(new int[]{0}, new int[]{pos[0], pos[1]}, direction) || 
           isReverseShape(new int[]{0}, new int[]{pos[0], pos[1]}, direction);
  }
  
  boolean isReverseColor(int[] times, int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    times[0]++;
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return false;
    if(massID(pos).isColor() != isDeployColor())
      return isReverseColor(times, pos, direction);
    if(times[0] <= 1) return false;
    return true;
  }
  
  boolean isReverseShape(int[] times, int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    times[0]++;
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return false;
    if(massID(pos).isShape() != isDeployShape())
      return isReverseShape(times, pos, direction);
    if(times[0] <= 1) return false;
    return true;
  }
  
  void reverse(int[] pos, final int[] direction) {
    if(isReverseColor(new int[]{0}, new int[]{pos[0], pos[1]}, direction))
      reverseColor(new int[]{pos[0], pos[1]}, direction);
    if(isReverseShape(new int[]{0}, new int[]{pos[0], pos[1]}, direction))
      reverseShape(new int[]{pos[0], pos[1]}, direction);
  }
  
  void reverseColor(int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return;
    if(massID(pos).isColor() == isDeployColor()) return;
    if(massID(pos).isColor() != isDeployColor()) { 
      massID(pos).reverseColor();
      reverseColor(pos, direction);
    }
    
  }
  
  void reverseShape(int[] pos, final int[] direction) {
    pos[0] += direction[0];
    pos[1] += direction[1];
    
    if(massID(pos) == null || !massID(pos).isExsisted()) return;
    if(massID(pos).isShape() == isDeployShape()) return;
    if(massID(pos).isShape() != isDeployShape() ) { 
      massID(pos).reverseShape();
      reverseShape(pos, direction);
    }
    
  }
  
  Mass massID(int[] pos) {
    if(pos == null || pos.length != 2) return null;
    if(!isValid(pos[0], pos[1])) return null;
    return mass[pos[0]][pos[1]];
  }
  
  boolean getShape(boolean isColor) {
    boolean Shape = false;
    if(isColor == Frame.BLACK) Shape = (!isRuleBlackShape()) ?  Frame.CIRCLE : Frame.RECT;
    if(isColor == Frame.WHITE) Shape = (isRuleWhiteShape()) ?  Frame.CIRCLE : Frame.RECT;
    return Shape;
  }
  
  int getFrameNum(boolean isTurn) {
    int Sum = 0;
    for(Mass[] n : mass) {
      for(Mass m : n) {
        if(m.isExsisted() && m.Color == isTurn && m.Shape == getShape(isTurn)) Sum++;
      }
    }
    
    return Sum;
  }
  
}

void circle(float x, float y, float r) {
  pushStyle();
  ellipseMode(RADIUS);
  ellipse(x, y, r, r);
  popStyle();
}

static boolean isInRange(float a, float b, float c) {
  return (a <= b && b <= c);
}