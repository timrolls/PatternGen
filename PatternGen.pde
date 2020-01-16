/*  Pattern Generator  
 
 Arranges .svg files from the /data folder into a grid.
 Uses colors with weighting from colors.txt to color the geometry
 
 Keys:
 space = advances 1 iteration 
 s = save to PDF/png
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
HHexLayout  layout;
HGridLayout  layout2;

int cols =40;
int cellSize=40;
int tileSize= int(cellSize*1.8);
//int tileSize= 70;
int elements = 128; //number of elements per shape pool
int elementScale =2;

int numFiles;
String shortPath = "data";
String[] loadedFiles;

int w, h;
String ws = "";

void setup() {
  size(1920, 1200);
  surface.setResizable(true);
  surface.setSize(displayWidth, displayHeight);
  w = width;
  h = height;
  registerMethod("pre", this); //register pre to run before draw

  H.init(this).background(#FFFFFF);

  smooth();

  setupUI(); // set up CP5 UI

  //Set up directory loading
  initDirectoryList();

  String loadPath = (sketchPath() + "\\"+shortPath) ; // does not work declared globally
  loadedFiles = listFileNames(loadPath);
  //printArray(loadedFiles); //For debugging
  numFiles = loadedFiles.length;

  //cellSize = width/(cols-1);

  //Read colors and weights from text file
  String[] loadedColors = loadStrings("colors.txt");
  int numColors = loadedColors.length;

  colors = new HColorPool();

  //Store colors and weights into color pool
  for (int i=0; i<numColors; i++) {
    String[] colorWeight = ( split((loadedColors[i]), ","));
    colors.add(unhex(colorWeight[0]) | 0xff000000, int(colorWeight[1])); // hex part is adding alpha bits
  }

  layout = new HHexLayout()
    .offsetX(0)
    .offsetX(0)
    .spacing(cellSize)
    //.cols(cols)
    ;

  createShapePool();
}

//catch window resize
void pre() {
  if (w != width || h != height) {
    // Sketch window has resized
    w = width;
    h = height;
    ws = "Size = " +w + " x " + h + " pixels";
    // Do what you need to do here

    layout.offsetX(0)
      .offsetX(0)
      .spacing(cellSize)
      ;

    resetPools();
  }
}

void draw() {
  H.background(255);
  H.drawStage();
}



void keyPressed() {
  // +        = redraw() advances 1 iteration 
  // r        = render to PDF

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
    H.clearStage();
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

  layout = new HHexLayout()
    .offsetX(0)
    .offsetX(0)
    .spacing(cellSize)
    ;

  pool.drain();
  pool.layout(layout);
  pool.shuffleRequestAll();
}

void createShapePool() {
  //Hacky implementation of size weighting - needs final for some reason
  final int[] sizePool = new int[]{0, 0, 0, 0, 0, 1, 1, 2};

  pool = new HDrawablePool(elements); 

  for (int i=0; i<numFiles; i++) {
    pool.autoAddToStage().add(new HShape (loadedFiles[i]));
  }

  pool.layout ( layout )

    .onCreate (
    new HCallback() {
    public void run(Object obj) {
      HShape d = (HShape) obj;
      d
        .enableStyle(false)
        //.noStroke()
        .anchorAt(H.CENTER)
        .size(sizePool[(int)random(0, sizePool.length)]*tileSize)
        .rotate(int(random(2))*180);
      ;

      d.randomColors(colors.fillOnly());
      //d.randomColors(colors);
    }
  }
  )
  .shuffleRequestAll()
    ;
}
