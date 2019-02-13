int bgFill = 190; // defines the greyscale colour of the background
int plotFill = 230; // defines the greyscale colour of the plot window

void screenSetup() {
  frameRate(59); // sets the framerate in frames per second
  background(bgFill); // sets the background fill colour and uses it to fill the screen
  rectMode(CORNERS); // means thar rectangles will have 2 corners defined rather than width & height 

  strokeWeight(2); // sets thickness of drawing tools
  stroke(230);
  fill(plotFill);
  rect(lMargin, tMargin, rMargin, bMargin);
  drawScales();
  textSize(14); // sets the font size of the timing-window text label
  fill(200, 20, 20); // sets the colour of the timing-window text label

  for (byte i =0; i<3; i++) {
    time[i]=0;
    active[i]=false;
    text("Window" + (i+1) +": ", timeXpos, tMargin+20+(75*i));
  }

  drawButtons();

  upper[0]=50; // defines pressure monitoring window 1 (shall later be customisable)
  lower[0]=45;
  ignoring[0]=false;

  upper[1]=28;  // defines pressure monitoring window 2 (shall later be customisable)
  lower[1]=23;
  ignoring[1]=false;

  upper[2]=5; // defines pressure monitoring window 3 (shall later be customisable)
  lower[2]=0;
  ignoring[2]=false;
}

void drawButtons() {
  for (byte i =0; i<(nButtons); i++) { // repeat for number of buttons
    if (!bActive[i]) { // if the button isn't selected draw a shadow
      fill(20); // sets the fill colour of the shadow
      stroke(20);
      rect(bX1[i] + shadow, bY1[i] + shadow, bX2[i] + shadow, bY2[i] + shadow); // draws the button shadow
    } else { // erase any previous shadow by using the background colour
      fill(bgFill); // sets the fill colour of the shadow
      stroke(bgFill);
      rect(bX1[i] + shadow, bY1[i] + shadow, bX2[i] + shadow, bY2[i] + shadow); // draws the button shadow
    }

    stroke(100); // sets colour of button perimeter
    fill(240); // sets fill colour for the button
    rect(bX1[i], bY1[i], bX2[i], bY2[i]); // draws the button

    if (bActive[i]) { // if the current button is latched (active)...
      fill(10, 10, 190); // sets the text colour
      textSize(16); // sets the text size for the button text
    } else {
      fill(0); // sets the text colour
      textSize(14); // sets the text size for the button text
    }
    text(bText[i], bX1[i] + xOff, bY1[i] + yOff); // draws the button text
  }
}
