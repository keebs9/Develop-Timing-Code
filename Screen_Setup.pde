void screenSetup() {
  frameRate(59); // sets the framerate in frames per second
  background(190); // sets the background fill colour and uses it to fill the screen

  strokeWeight(2); // sets thickness of drawing tools
  stroke(230);
  fill(230);
  rect(lMargin, tMargin, plotWidth, plotHeight);
  drawScales();
  textSize(14);
  fill(200,20,20);
  text("Window1: ", rMargin+20, tMargin+20);
}
