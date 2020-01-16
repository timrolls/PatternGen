//UI

import controlP5.*;

ControlP5 cp5;

void setupUI() {
  PFont font = createFont("arial", 20);

  cp5 = new ControlP5(this);

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'cellSize' 
  cp5.addSlider("cellSize")
    .setPosition(50, 50)
    .setValue(cellSize)
    .setSize(200, 20)
    .setRange(0, 255)
    ;

  cp5.getController("cellSize").getCaptionLabel().setColor(color(0, 0, 0) );

  // add a horizontal sliders, the value of this slider will be linked
  // to variable 'elements' 
  cp5.addSlider("elements")
    .setPosition(50, 75)
    .setSize(200, 20)
    .setRange(0, 300)
    .setValue(128)
    ;

  cp5.getController("elements").getCaptionLabel().setColor(color(0, 0, 0) );

  //cp5.addSlider("elementScale")
  //  .setPosition(50, 100)
  //  .setSize(200, 20)
  //  .setRange(1, 5) // values can range from big to small as well
  //  .setValue(2)
  //  .setNumberOfTickMarks(5)
  //  //.setSliderMode(Slider.FLEXIBLE)
  //  ;
  //// use Slider.FIX or Slider.FLEXIBLE to change the slider handle
  //// by default it is Slider.FIX
  
  //  cp5.getController("elementScale").getCaptionLabel().setColor(color(0, 0, 0) );


  // create a new button with name 'reset'
  cp5.addButton("reset")
    .setValue(0)
    .setPosition(50, 100)
    .setSize(97, 20)
    ;

  // create a new button with name 'buttonA'
  cp5.addButton("save")
    .setValue(0)
    .setPosition(152, 100)
    .setSize(97, 20)
    ;

  textFont(font);
}

void cellSize(int value) {
  cellSize=value;
  tileSize= int(value*1.8);
  resetPools();
}

void elements(int value) {
  elements = value;

  pool.drain();
  H.clearStage();
  createShapePool();

  resetPools();
}

//void elementScale(int value){
//  elementScale =value;
//  reset();
//}

void reset() {
  resetPools();
  H.clearStage();
  resetPools();
}

void save() {
  saveVector();
  H.drawStage();
  saveFrame("png/render_####.png");
}
