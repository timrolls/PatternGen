//UI

import controlP5.*;

ControlP5 cp5;

void setupUI(){
  PFont font = createFont("arial",20);
  
  cp5 = new ControlP5(this);
  
  //cp5.addTextfield("input")
  //   .setPosition(20,100)
  //   .setSize(200,40)
  //   .setFont(font)
  //   .setFocus(true)
  //   .setColor(color(255,0,0))
  //   ;
                 
  //cp5.addTextfield("textValue")
  //   .setPosition(20,170)
  //   .setSize(200,40)
  //   .setFont(createFont("arial",20))
  //   .setAutoClear(false)
  //   ;
       
  //cp5.addBang("clear")
  //   .setPosition(240,170)
  //   .setSize(80,40)
  //   .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)
  //   ;    
  
  //cp5.addTextfield("default")
  //   .setPosition(20,350)
  //   .setAutoClear(false)
  //   ;
     
  textFont(font);
  
}
