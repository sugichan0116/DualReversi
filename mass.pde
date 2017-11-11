class Mass {
  private boolean isExsist, Shape, Color;
  
  Mass() {
    this(false, false, false);
  }
  
  Mass(boolean isExsist, boolean Color, boolean Shape) {
    this.isExsist = isExsist;
    this.Color = Color;
    this.Shape = Shape;
  }
  
  public void draw(float x, float y, float r) {
    if(!isExsist) return;
    pushStyle();
    fill((Color == Frame.BLACK) ? 0 : 255);
    if(Shape == Frame.CIRCLE) {
      ellipseMode(CENTER);
      ellipse(x + r / 2f, y + r / 2f, r * 0.8f, r * 0.8f);
    }else if(Shape == Frame.RECT) {
      rectMode(CENTER);
      rect(x + r / 2f, y + r / 2f, r * 0.8f, r * 0.8f);
    }
    popStyle();
  }
  
  void reverseColor() {
    Color = !Color;
  }
  
  void reverseShape() {
    Shape = !Shape;
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