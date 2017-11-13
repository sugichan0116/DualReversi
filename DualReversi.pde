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
  field = new Field(8);
  field.set((width - height) / 2, 0, height / 8);
  frameNum = new int[2][3];
  for(int n = 0; n < 2; n++) {
    for(int m = 0; m < 3; m++) {
      frameNum[n][m] = (8 * 8 - 4) / 2 / 3;
      //if(m == 0) frameNum[n][m] = 8 * 8 / 2 - (8 * 8 - 4) / 2 / 3 * 2;
    }
  }
}

void draw() {
  background(255);
  fill(0);
  rect(width / 2, 0, width / 2, height);
  fill(255);
  field.draw();
  (new Mass(true, field.isDeployColor(field.isTurn, frameKind), field.isDeployShape(field.isTurn, frameKind))).draw(mouseX - field.r / 2, mouseY - field.r / 2, field.r);
  if(field.getFrameNum(false) + field.getFrameNum(true) != 0)
  //rect(0, height, width * (float)field.getFrameNum(false) / (float)(field.getFrameNum(false) + field.getFrameNum(true)), -12);
  pushStyle();
  for(int m = 0; m < 2; m++) {
    float menuWidth = (width - height) / 2;
    pushMatrix();
    translate(width / 2, height / 2);
    if(m == 1) rotate(PI);
    for(int n = 0; n < 3; n++) {
      fill((m == 1) ? 0 : 255);
      circle(height / 2 + menuWidth / 2 , height * 0.2 * (n), (menuWidth - 8 * rateY) / 2);
      stroke((m == 1) ? 255 : 0);
      (new Mass(true, field.isDeployColor((m == 1), n), field.isDeployShape((m == 1), n))).draw(height / 2 + menuWidth / 2 - field.r / 2, height * 0.2 * (n) - field.r / 2, field.r);
      fill((m == 1) ? 255 : 0);
      stroke((m == 1) ? 0 : 255);
      circle(height / 2 + menuWidth / 2 + menuWidth * 0.2, height * 0.2 * (n + 0.2), menuWidth / 4);
      fill((m == 1) ? 0 : 255);
      textAlign(CENTER, CENTER);
      textSize(menuWidth / 4);
      text(frameNum[(field.isTurn() ^ (m == 0)) ? 1 : 0][n], height / 2 + menuWidth / 2 + menuWidth * 0.2, height * 0.2 * (n + 0.2));
    }
    textSize(menuWidth);
    text(field.getFrameNum((m == 1)), height / 2 + menuWidth / 2, height * -0.3, 12 * rateY);
    popMatrix();
  }
  popStyle();
}

void mousePressed() {
  int[] pos = field.check(mouseX, mouseY);
  if(pos != null && field.isDeploy(frameKind, pos) && frameNum[(field.isTurn()) ? 1 : 0][frameKind] > 0) {
    frameNum[(field.isTurn()) ? 1 : 0][frameKind]--;
    field.deploy(frameKind, pos);
    field.update();
  }
  for(int m = 0; m < 2; m++) {
    for(int n = 0; n < 3; n++) {
      float menuWidth = (width - height) / 2;
      if(dist(mouseX, mouseY, width / 2 + (height / 2 + menuWidth / 2) * cos((m == 1) ? PI : 0f), height / 2 + (height * 0.2 * (n)) * sin((m == 1) ? PI : 0f)) < (menuWidth - 8 * rateY) / 2) {
        field.setFrame(n);
        frameKind = n;
      }
    }
  }
}

void mouseWheel() {
  frameKind = (++frameKind) % 3;
}