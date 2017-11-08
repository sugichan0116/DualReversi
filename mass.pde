class Mass {
  private boolean isExsist, Shape, Color;
  
  Mass() {
    isExsist = Shape = Color = false;
  }
  
  public void draw(float x, float y, float r) {
    if(!isExsist) return;
    pushStyle();
    fill((Color == Frame.BLACK) ? 0 : 255);
    ellipseMode(CENTER);
    ellipse(x + r / 2f, y + r / 2f, r * 0.8f, r * 0.8f);
    popStyle();
  }
  
  void reverse() {
    Color = !Color;
  }
  
  boolean isExsisted() { return isExsist; }
  
  boolean deploy(boolean isTurn) {
    if(isExsist) return false;
    
    if(isTurn == false) Color = Frame.BLACK;
    else if(isTurn == true) Color = Frame.WHITE;
    return isExsist = true;
  }
  
  boolean isColor() {
    return Color;
  }
  
  
}