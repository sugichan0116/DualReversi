class Mass {
  private boolean isExsist, Shape, Color;
  int rot;
  
  Mass() {
    this(false, false, false);
  }
  
  Mass(boolean isExsist, boolean Color, boolean Shape) {
    this.isExsist = isExsist;
    this.Color = Color;
    this.Shape = Shape;
    rot = 0;
  }
  
  public void draw(float x, float y, float r) {   
    if(!isExsist) return;
    pushStyle();
    fill((Color == Frame.BLACK) ? 0 : 255);
    if(Shape == Frame.CIRCLE) {
      //ellipseMode(CENTER);
      //ellipse(x + r / 2f, y + r / 2f, r * 0.8f, r * 0.8f);
      pushMatrix();
        translate(x + r / 2f, y + r / 2f, r * 0.5f * abs(sin(radians(rot))));
        rotateY(radians(rot));
        int poly = 32;
        for(int m = 0; m < 2; m++) {
          beginShape();
          for(int n = 0; n < poly; n++) {
            vertex(r * 0.4f * cos(radians(n * 360 / poly)),
                   r * 0.4f * sin(radians(n * 360 / poly)),
                   r * 0.05f * ((m % 2 == 0) ? 1 : -1));
          }
          endShape();
        }
        for(int n = 0; n < poly; n++) {
          beginShape();
          for(int m = 0; m < 4; m++) {
            vertex(r * 0.4f * cos(radians(((m / 2 == 0) ? n : n + 1) * 360 / poly)),
                   r * 0.4f * sin(radians(((m / 2 == 0) ? n : n + 1) * 360 / poly)),
                   r * 0.05f * (((m % 2 == 0) ^ (m / 2 == 0)) ? 1 : -1));
          }
          endShape();  
        }
      popMatrix();
    }else if(Shape == Frame.RECT) {
      //rectMode(CENTER);
      //rect(x + r / 2f, y + r / 2f, r * 0.7f, r * 0.7f);
      pushMatrix();
        translate(x + r / 2f, y + r / 2f, r * 0.5f * abs(sin(radians(rot))));
        rotateY(radians(rot));
        box(r * 0.7f, r * 0.7f, r * 0.1f);
      popMatrix();
    }
    popStyle();
  }
  
  void update() {
    rot = max(0, rot - 4);
  }
  
  void reverseColor() {
    Color = !Color;
    rot = 180;
  }
  
  void reverseShape() {
    Shape = !Shape;
    rot = 180;
  }
  
  boolean deploy(boolean Color, boolean Shape) {
    if(isExsist) return false;
    
    this.Color = Color;
    this.Shape = Shape;
    return isExsist = true;
  }
  
  boolean isExsisted() {
    return isExsist;
  }
  
  boolean isColor() {
    return Color;
  }
  
  boolean isShape() {
    return Shape;
  }
  
}