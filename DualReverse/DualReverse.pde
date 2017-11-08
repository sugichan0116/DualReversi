Field field;
final static int[][] DIRECTION = new int[][]
  {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};

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
  text("Turn : " + ((field.isTurn) ? "WHITE" : "BLACK"), 0, 0);
  field.draw();
}

void mousePressed() {
  int[] pos = field.check(mouseX, mouseY);
  if(pos != null && field.isDeploy(pos)) {
    field.deploy(pos);
    field.update();
  }
}