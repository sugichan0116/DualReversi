Field field;
final static int[][] DIRECTION = new int[][]
  {{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}};
int frameKind = 0;
float rateX, rateY;
int[][] frameNum;
int Scale = 6;

void setup() {
  fullScreen(P3D);
  //size(480, 360);
  rateX = (float)width / 480f;
  rateY = (float)height / 360f;
  field = new Field(Scale);
  field.set(float(width - height) / 2f, 0f, float(height) / float(Scale));
  frameNum = new int[2][3];
  for(int n = 0; n < 2; n++) {
    for(int m = 0; m < 3; m++) {
      frameNum[n][m] = (Scale * Scale - 4) / 2 / 3;
      if(m == 0) frameNum[n][m] = (Scale * Scale - 4) / 2 - (Scale * Scale - 4) / 2 / 3 * 2;
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
  pushStyle();
  for(int m = 0; m < 2; m++) {
    float menuWidth = (width - height) / 2;
    pushMatrix();
    translate(width / 2, height / 2, 0f);
    if(m == 1) rotate(PI);
    for(int n = 0; n < 3; n++) {
      fill((m == 1) ? 0 : 255);
      if(field.isTurn() ^ (m == 0) && frameKind == n) fill(128);
        circle(height / 2 + menuWidth / 2 , height * 0.2 * (n), min(field.r * 0.7, (menuWidth - 8 * rateY) / 2));
      stroke((m == 1) ? 255 : 0);
        (new Mass(true, field.isDeployColor((m == 1), n), field.isDeployShape((m == 1), n))).
          draw(height / 2 + menuWidth / 2 -  min(field.r, menuWidth * 0.8f) / 2,
          height * 0.2 * (n) - min(field.r, menuWidth * 0.8f) / 2,
          min(field.r, menuWidth * 0.8f));
      fill((m == 1) ? 255 : 0);
      stroke((m == 1) ? 0 : 255);
        pushMatrix();
        translate(0f, 0f, 6f * rateY);
        circle(height / 2 + menuWidth / 2 + menuWidth * 0.2, height * 0.2 * (n + 0.2), min(field.r * 0.3, menuWidth / 4));
        popMatrix();
      fill((m == 1) ? 0 : 255);
      textAlign(CENTER, CENTER);
      textSize(min(field.r * 0.3, menuWidth / 4));
        text(frameNum[((m == 0)) ? 1 : 0][n],
          height / 2 + menuWidth / 2 + menuWidth * 0.2,
          height * 0.2 * (n + 0.2), 6f * rateY);
    }
    textSize(int(min(field.r * 2, menuWidth)));
      text(field.getFrameNum((m == 1)), height / 2 + menuWidth / 2, height * -0.3, 0f);
    popMatrix();
  }
  popStyle();
}

void mousePressed() {
  int[] pos = field.check(mouseX, mouseY);
  if(pos != null && field.isDeploy(frameKind, pos) && frameNum[(field.isTurn()) ? 1 : 0][frameKind] > 0) {
    frameNum[(field.isTurn()) ? 0 : 1][frameKind]--;
    field.deploy(frameKind, pos);
    field.update();
  }
    for(int n = 0; n < 3; n++) {
      float menuWidth = (width - height) / 2;
      fill(128);
      if(dist(mouseX, mouseY, width / 2 + (height / 2 + menuWidth / 2) * ((field.isTurn()) ? -1f : 1f), height / 2 + (height * 0.2 * float(n)) * ((field.isTurn()) ? -1f : 1f)) < min(field.r * 0.7, (menuWidth - 8 * rateY) / 2)) {
        field.setFrame(n);
        frameKind = n;
      }
    }
}

void mouseWheel() {
  frameKind = (++frameKind) % 3;
}