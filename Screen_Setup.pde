void screenSetup() {
  frameRate(59); // sets the framerate in frames per second
  background(190); // sets the background fill colour and uses it to fill the screen
  rectMode(CORNERS); // means thar rectangles will have 2 corners defined rather than width & height 

  strokeWeight(2); // sets thickness of drawing tools
  stroke(230);
  fill(230);
  rect(lMargin, tMargin, rMargin, bMargin);
  drawScales();
  textSize(14);
  fill(200, 20, 20);
  
  for (byte i =0; i<3; i++) {
    time[i]=0;
    active[i]=false;
    text("Window" + (i+1) +": ", rMargin+20, tMargin+20+(75*i));
  }

  upper[0]=50; // defines pressure monitoring window 1
  lower[0]=45;

  upper[1]=28;  // defines pressure monitoring window 2
  lower[1]=23;

  upper[2]=5; // defines pressure monitoring window 3
  lower[2]=0;
}
