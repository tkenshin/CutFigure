PShape cGroup;
  
PShape s;
PShape sc1;
PShape sc2;

boolean dividing;
boolean cutting;

float cx, cy;
float vx1, vy1, vx2, vy2;
float vx3, vy3, vx4, vy4;

float x3 = 100;
float x4 = 400;
float y4 = 250;

class CrossLine{
  float cx, cy;
  float ksi, eta, delta, ramda, mu;

  CrossLine(float p1x, float p1y, float p2x, float p2y, float p3x, float p3y, float p4x, float p4y) {
    this.ksi = (p4y - p3y) * (p4x - p1x) - (p4x - p3x) * (p4y - p1y);
    this.eta = (p2x - p1x) * (p4y - p1y) - (p2y - p1y) * (p4x - p1x);
    this.delta = (p2x - p1x) * (p4y - p3y) - (p2y - p1y) * (p4x - p3x);

    this.ramda = ksi / delta;
    this.mu = eta / delta;

    if ((ramda >= 0 && ramda <= 1) && (mu >= 0 && mu <= 1)) {
      this.cx = p1x + ramda * (p2x - p1x);
      this.cy = p1y + ramda * (p2y - p1y);
      
    }
    
  }
  
}

CrossLine[] crossLine;

void setup() {
  size(500, 500, P2D);
  crossLine = new CrossLine[2];
  dividing = false;
  cutting = false;

  cGroup = createShape(GROUP);

  s = createShape(RECT, 0, 0, 120, 240);
  sc1 = createShape();
  sc2 = createShape();
  
}

void draw() {
  background(254);
  createObject();
  
}

void createObject() {
  if (!dividing) {
    fill(0);
    text("Divide shape.[Space]", 5 , 15);
    fill(255);
    
    shape(s, width / 2 - 60, height / 2 - 120);

    // 右側の辺の頂点===================
    PVector v1 = s.getVertex(1); // 右上の頂点
    PVector v2 = s.getVertex(2); // 右下の頂点

    vx1 = v1.x + width / 2 - 60;
    vy1 = v1.y + height / 2 - 120;
    vx2 = v2.x + width / 2 - 60;
    vy2 = v2.y + height / 2 - 120;

    // 左側の辺の頂点==================
    PVector v3 = s.getVertex(3); // 左下の頂点
    PVector v4 = s.getVertex(4); // 左上の頂点

    vx3 = v3.x + width / 2 - 60;
    vy3 = v3.y + height / 2 - 120;
    vx4 = v4.x + width / 2 - 60;
    vy4 = v4.y + height / 2 - 120;

    // ==============================

    float m = map(mouseY, 0, height, vy4, vy3); // - + 45 = line始まりの座標と接点の座標との差

    crossLine[0] = new CrossLine(vx1, vy1, vx2, vy2, x3, m, x4, y4); // 右の辺の交点座標
    crossLine[1] = new CrossLine(vx3, vy3, vx4, vy4, x3, m, x4, y4); // 左の辺の交点座標

    line(x3, m, x4, y4);

    ellipse(crossLine[0].cx, crossLine[0].cy, 10, 10);
    ellipse(crossLine[1].cx, crossLine[1].cy, 10, 10);
    
  } else if (dividing) {
    fill(0);
    text("Cutting shape.[Enter]", 5 , 15);
    fill(255);
    
    sc1.setFill(color(255, 0, 0));
    sc2.setFill(color(0, 255, 0));
    shape(sc1);
    shape(sc2);
    
  }
  
}

void keyReleased() {
  if (key == ' ' && !dividing) {
    sc1.beginShape();
    sc1.vertex(vx4, vy4);
    sc1.vertex(vx1, vy4);
    sc1.vertex(vx1, crossLine[0].cy);
    sc1.vertex(vx4, crossLine[1].cy);
    sc1.endShape(CLOSE);

    sc2.beginShape();
    sc2.vertex(vx3, crossLine[1].cy);
    sc2.vertex(vx2, crossLine[0].cy);
    sc2.vertex(vx2, vy2);
    sc2.vertex(vx3, vy3);
    sc2.endShape(CLOSE);

    cGroup.addChild(sc1);
    cGroup.addChild(sc2);

    dividing = true;
    
  } else if (key == ENTER && dividing && !cutting) {
    int i = cGroup.getChildIndex(sc1);
    cGroup.removeChild(i);
    
    cutting = true;
  }
  
}