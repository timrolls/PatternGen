/* Pattern Generator  
 // space = advances 1 iteration 
 // s = save to PDF/png
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

int cols =8;
int cellSize;
int elements = 32; //number of elements per shape pool

int numFiles;
String shortPath = "data";

int w, h;
String ws = "";

void setup() {
  size(1920, 1200);
  surface.setResizable(true);
  surface.setSize(displayWidth, displayHeight);
  w = width;
  h = height;
  registerMethod("pre", this); //register pre to run before draw

  H.init(this);
  smooth();

  setupUI(); // set up CP5 UI

  //Set up directory loading
  initDirectoryList();

  String loadPath = (sketchPath() + "\\"+shortPath) ; // does not work declared globally
  String[] loadedFiles = listFileNames(loadPath);
  //printArray(loadedFiles); //For debugging
  numFiles = loadedFiles.length;

  cellSize = width/(cols-1);
  
  String[] loadedColors = loadStrings("colors.txt");
  int numColors = loadedColors.length;
  

  colors = new HColorPool();
    //.add(#FFFFFF) 
    //.add(#0C3654, 2)
    //.add(#10B36B, 2) 
    //;	
    
   for (int i=0; i<numColors; i++) {
    colors.add(unhex(loadedColors[i])| 0xff000000);
  }

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

  pool = new HDrawablePool(elements+cols); // big ones

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


  pool2 = new HDrawablePool(elements); // little ones
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
}

//catch window resize
void pre() {
  if (w != width || h != height) {
    // Sketch window has resized
    w = width;
    h = height;
    ws = "Size = " +w + " x " + h + " pixels";
    // Do what you need to do here

    cellSize = width/(cols-1);

    layout.startX(0).startY(0)
      .spacing(cellSize, cellSize)
      .cols(cols+1)
      ;
    //nested layout for diamond offset
    layout2
      .startX(cellSize/2)
      .startY(cellSize/2)
      .spacing(cellSize, cellSize)
      .cols(cols)
      ;

    resetPools();

  }
}

void draw() {
  H.drawStage();
}

// +        = redraw() advances 1 iteration 
// r        = render to PDF

void keyPressed() {
  if (key == '+') {
    if (paused) {
      loop();
      paused = false;
    } else {
      noLoop();
      paused = true;
    }
  }

  if (key == 's') {
    record = true;
    saveVector();
    H.drawStage();
    saveFrame("png/render_####.png");
  }

  if (key == ' ') {
    resetPools();
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

void resetPools() {

  pool.drain();
  pool2.drain();
  layout.resetIndex();
  layout2.resetIndex();
  pool.shuffleRequestAll();
  pool2.shuffleRequestAll();

  H.drawStage();
}
