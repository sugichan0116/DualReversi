Field field;
final static int[][] DIRECTION = new int[][]
  {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
int frameKind = 0;

void setup() {
  size(480, 360);
  field = new Field();
  field.set(32f, 32f);
}

void draw() {
  background(255);
  fill(0);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Turn : " + ((field.isTurn) ? "WHITE" : "BLACK") + frameKind +
    "[B" + field.getFrameNum(false) + "] vs [W" + field.getFrameNum(true) + "]", 0, 0);
  field.draw();
  (new Mass(true, field.isTurn, field.isTurn)).draw(mouseX, mouseY, field.r);
}

void mousePressed() {
  int[] pos = field.check(mouseX, mouseY);
  if(pos != null && field.isDeploy(pos)) {
    field.deploy(pos);
    field.update();
  }
}

void mouseWheel() {
  frameKind = (++frameKind) % 3;
}