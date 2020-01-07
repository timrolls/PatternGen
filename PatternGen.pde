/* Pattern Generator  
 // + = redraw() advances 1 iteration 
 // r = render to PDF/png
 */

import hype.*;
import hype.extended.behavior.*;
import hype.extended.colorist.*;
import hype.extended.layout.*;
import hype.interfaces.*;

import processing.pdf.*;

boolean record = false;
boolean paused = false;

HDrawablePool pool;
HDrawablePool pool2;
HColorPool colors;
HGridLayout  layout;
HGridLayout  layout2;

int cellSize = 400;
int cols =6;

int numFiles;
String shortPath = "data";

void setup() {
  size(1920, 1200);
  surface.setResizable(true);
  H.init(this);
  smooth();

  setupUI(); // set up CP5 UI

  //Set up directory loading
  initDirectoryList();

  String loadPath = (sketchPath() + "\\"+shortPath) ;
  String[] loadedFiles = listFileNames(loadPath);
  //printArray(loadedFiles); //For debugging
  numFiles = loadedFiles.length;

  colors = new HColorPool()
    .add(#FFFFFF) 
    .add(#0C3654, 2)
    .add(#10B36B, 2) 
    ;	

  layout = new HGridLayout()
    .startX(0)
    .startY(0)
    .spacing(cellSize, cellSize)
    .cols(cols)
    ;
  //nested layout for diamond offset
  layout2 =  new HGridLayout()
    .startX(cellSize/2)
    .startY(cellSize/2)
    .spacing(cellSize, cellSize)
    .cols(cols)
    ;

  pool = new HDrawablePool(24); // big ones

  for (int i=0; i<numFiles; i++) {
    pool.autoAddToStage().add(new HShape (loadedFiles[i]));
  }

  pool.layout (layout)

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


  pool2 = new HDrawablePool(24); // little ones
  for (int i=0; i<numFiles; i++) {
    pool2.autoAddToStage().add(new HShape (loadedFiles[i]));
  }

    pool2.layout ( layout2 )

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
    pool2.drain();
    layout.resetIndex();
    layout2.resetIndex();
    pool.shuffleRequestAll();
    pool2.shuffleRequestAll();

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
