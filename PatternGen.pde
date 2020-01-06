/* Pattern Generator  */

import processing.pdf.*;

boolean record = false;
boolean paused = false;

HDrawablePool pool;
HDrawablePool pool2;
HColorPool colors;

int cellSize = 400;

void setup() {
  size(1200, 1200);
  H.init(this);
  smooth();

  colors = new HColorPool()
    .add(#FFFFFF) 
    .add(#0C3654, 2)
    .add(#10B36B, 2) 

    ;	

  pool = new HDrawablePool(16); // big ones
  pool.autoAddToStage()

    .add(new HShape ("1.svg"))
    .add(new HShape ("2.svg"))
    .add(new HShape ("3.svg"))
    .add(new HShape ("4.svg"))
    .add(new HShape ("5.svg"))
    .add(new HShape ("6.svg"))
    .add(new HShape ("7.svg"))
    .add(new HShape ("8.svg"))
    .add(new HShape ("9.svg"))
    .add(new HShape ("10.svg"))

    .layout (
    new HGridLayout()
    .startX(0)
    .startY(0)
    .spacing(cellSize, cellSize)
    .cols(4)
    )

    .onCreate (
    new HCallback() {
    public void run(Object obj) {
      HShape d = (HShape) obj;
      d
        .enableStyle(false)
        .noStroke()
        .anchorAt(H.CENTER)
        .size(cellSize)
        //                                                .scale((int)random(2));
        //                                                .rotate((int)random(4)*90)
        ;

      d.randomColors(colors.fillOnly());
    }
  }
  )

  .requestAll()
    ;


  pool2 = new HDrawablePool(16); // little ones
  pool2.autoAddToStage()
    .add(new HShape ("1.svg"))
    .add(new HShape ("2.svg"))
    .add(new HShape ("3.svg"))
    .add(new HShape ("4.svg"))
    .add(new HShape ("5.svg"))
    .add(new HShape ("6.svg"))
    .add(new HShape ("7.svg"))
    .add(new HShape ("8.svg"))
    .add(new HShape ("9.svg"))
    .add(new HShape ("10.svg"))

    .layout (
    new HGridLayout()
    .startX(cellSize/2)
    .startY(cellSize/2)
    .spacing(cellSize, cellSize)
    .cols(4)
    )

    .onCreate (
    new HCallback() {
    public void run(Object obj) {
      HShape d = (HShape) obj;
      d
        .enableStyle(false)						
        .noStroke()
        .anchorAt(H.CENTER)
        .size(cellSize)
        //                                                .scale((int)random(2));
        ;

      d.randomColors(colors.fillOnly());
    }
  }
  )

  .requestAll()
    ;

  H.drawStage();
}

void draw() {
}

// +        = redraw() advances 1 iteration 
// r        = render to PDF
// c        = recolor 

void keyPressed() {
  if (key == ' ') {
    if (paused) {
      loop();
      paused = false;
    } else {
      noLoop();
      paused = true;
    }
  }


  if (key == 'r') {
    record = true;
    saveVector();
    H.drawStage();
    saveFrame("png/render_####.png");
  }

  if (key == '+') {
    pool.drain();
    //layout.resetIndex();
    pool.shuffleRequestAll();

    pool.requestAll();
    pool2.requestAll();
    H.drawStage();
  }
}


void saveVector() {
  PGraphics tmp = null;
  tmp = beginRecord(PDF, "pdf/render_#####.pdf");

  if (tmp == null) {
    H.drawStage();
  } else {
    H.stage().paintAll(tmp, false, 1); // PGraphics, uses3D, alpha
  }

  endRecord();
}
