int bgFill = 190; // defines the greyscale colour of the background
int plotFill = 230; // defines the greyscale colour of the plot window
int grey = 100; // defines the greyscale colour for greyed out text (must be at least 30)

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

  for (byte i =0; i<3; i++) { // repeat 3 times as there are 3 pressure windows
    msTime[i]=0;
    count[i]=0;
    average[i]=0;
    winActive[i]=false;
  }

  defineWindows();
  Buttons();
  drawDataCaptions();
  drawMovableWindows();
  updateTimingData();
}

void defineWindows() {

  // defines pressure monitoring window 1 defaults (shall be customisable)
  upper[0] = uScale[aC]; // sets the top of the 1st windows to full scale
  lower[0] = uScale[aC] - gapNum; // sets the bottom of the 1st window to 1 division down
  valR[0] = 252; 
  valG[0] = 187; 
  valB[0] = 7; // sets the colours for this window

  // defines pressure monitoring window 2 defaults (shall be customisable)
  upper[1] = ((lScale[aC] + uScale[aC]) / 2) + (0.5 * gapNum); // sets the top of the 2nd windows to mid-point + 1/2 a division
  lower[1] = ((lScale[aC] + uScale[aC]) / 2) - (0.5 * gapNum); // sets the top of the 2nd windows to mid-point - 1/2 a division
  valR[1] = 0; 
  valG[1] = 177; 
  valB[1] = 216; // sets the colours for this window

  // defines pressure monitoring window 3 defaults (shall be customisable)
  upper[2]=lScale[aC] + gapNum; // sets the top of the 3rd window to 1 division up
  lower[2]=lScale[aC]; // sets the bottom of the 3rd windows to minimum scale value
  valR[2] = 255; 
  valG[2] = 99; 
  valB[2] = 223; // sets the colours for this window

  // defines generic window settings
  for (byte i = 0; i<3; i++) {
    ignoring[i] = false;
    upperDrag[i] = false;
    lowerDrag[i] = false;
    darkR[i] = darken(valR[i], 40); // runs the function below which returns a darker shade of the colour element R
    darkG[i] = darken(valG[i], 40); // runs the function below which returns a darker shade of the colour element G
    darkB[i] = darken(valB[i], 40); // runs the function below which returns a darker shade of the colour element B
  }
  setWindowHeight(); // calls the function which sets the data windows heights & ensures they don't clash
}

void Buttons() {
  if (!bActive[3]) drawButtons(0,3); // if not in calibraiton mode draw normal buttons 
  else if (calStage <7) drawButtons(4,7); // draw the calibration buttons
  else if (calStage == 7) drawButtons(8,12); // draw the file operation buttons
}

void drawButtons(int lo, int hi) {
  for (int i = lo; i < hi + 1; i++) { // repeat for number of buttons
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

int darken(int colourIn, int strength) {
  if (colourIn>= strength) {
    colourIn = colourIn - strength;
  } else colourIn = 0;
  return colourIn;
}

void setWindowHeight() { // sets the 3 timing windows to default values based on the current scale limits
  // set the vertical positions of the 3 movable windows & ensure they don't overlap
  winTopY[0] = map(upper[0]-((upper[0]-lower[0])/2), lScale[aC], uScale[aC], plotHeight, 0) + tMargin-17;
  winTopY[1] = map(upper[1]-((upper[1]-lower[1])/2), lScale[aC], uScale[aC], plotHeight, 0) + tMargin-17;
  winTopY[2] = map(upper[2]-((upper[2]-lower[2])/2), lScale[aC], uScale[aC], plotHeight, 0) + tMargin-17;

  winBotY[0] = winTopY[0] +24;
  winBotY[1] = winTopY[1] +24;
  winBotY[2] = winTopY[2] +24;

  //check for overlaps and if so adjust the positions of windows 0 & 3 relative to centre window 1
  if ((winBotY[0]+51) > winTopY[1]) { // if the bottom of the 0-win overlaps the top of the 1-win then...
    winBotY[0] = winTopY[1]-52; // move the bottom of 0-win to a fixed distance above the top of 1-win
    winTopY[0] = winBotY[0]-24; // set the bottom of 0-win to 24 below its top
  }
  if ((winBotY[1]+51) > winTopY[2]) { // if the bottom of the 1-win overlaps the top of the 2-win then...
    winTopY[2] = winBotY[1]+52; // move the bottom of 2-win up to a fixed distance below the bottom of 1-win
    winBotY[2] = winTopY[2]+24; // set the bottom of 0-win to 24 below its top
  }
}
