Field field;
final static int[][] DIRECTION = new int[][]
  {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
int frameKind = 0;
float rateX, rateY;
int[][] frameNum;

void setup() {
  fullScreen();
  rateX = (float)width / 480f;
  rateY = (float)height / 360f;
  //size(480, 360);
  field = new Field();
  field.set(64f * rateX, 32f * rateY, 32f * rateY);
  frameNum = new int[2][3];
  for(int n = 0; n < 2; n++) {
    for(int m = 0; m < 3; m++) {
      frameNum[n][m] = 5;
    }
  }
}

void draw() {
  background(255);
  fill(0);
  textSize(24);
  textAlign(LEFT, TOP);
  text("Turn : " + ((field.isTurn) ? "WHITE" : "BLACK") + frameKind +
    "[B" + field.getFrameNum(false) + "] vs [W" + field.getFrameNum(true) + "]", 0, 0);
  field.draw();
  (new Mass(true, field.isDeployColor(frameKind), field.isDeployShape(frameKind))).draw(mouseX, mouseY, field.r);
  if(field.getFrameNum(false) + field.getFrameNum(true) != 0)
  rect(0, height, width * (float)field.getFrameNum(false) / (float)(field.getFrameNum(false) + field.getFrameNum(true)), -12);
  for(int n = 0; n < 3; n++) {
    noFill();
    circle(width * 0.8, height * 0.2 * (n + 1), 32 * rateY);
    fill(0);
    text("Remain:" + frameNum[(field.isTurn()) ? 1 : 0][n], width * 0.8 - 24 * rateY, height * 0.2 * (n + 1.2), 12 * rateY);
    (new Mass(true, field.isDeployColor(n), field.isDeployShape(n))).draw(width * 0.8 - field.r / 2, height * 0.2 * (n + 1) - field.r / 2, field.r);
  }
}

void mousePressed() {
  int[] pos = field.check(mouseX, mouseY);
  if(pos != null && field.isDeploy(frameKind, pos) && frameNum[(field.isTurn()) ? 1 : 0][frameKind] > 0) {
    frameNum[(field.isTurn()) ? 1 : 0][frameKind]--;
    field.deploy(frameKind, pos);
    field.update();
  }
  for(int n = 0; n < 3; n++) {
    if(dist(mouseX, mouseY, width * 0.8, height * 0.2 * (n + 1)) < 32 * rateY) {
      field.setFrame(n);
      frameKind = n;
    }
  }
}

void mouseWheel() {
  frameKind = (++frameKind) % 3;
}