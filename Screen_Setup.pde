// declare variables which define the screen layout
int progWidth = 1366; // defines the width of the entire program window
int progHeight = 768; // defines the height of the entire program window 
int plotWidth = pW; // defines  the width of the display window
int plotHeight = 514; // defines  the height of the display, 514 is due to thickness of trace (was 513)
int lMargin = 40; // defines the width & so the position of the left margin
int rMargin = lMargin + plotWidth; // defines the position of the right margin (from 0)
int tMargin = 130; // defines the height & so the position of the top margin
int bMargin = tMargin + plotHeight; // defines the position of the bottom margin (from 0)
int bgFill = 190; // defines the greyscale colour of the background
int plotFill = 230; // defines the greyscale colour of the plot window
int grey = 100; // defines the greyscale colour for greyed out text (must be at least 30)

void screenSetup() { // this is called only during setup at program launch, it builds the screen elements
  background(bgFill); // sets the background fill colour and uses it to fill the screen
  rectMode(CORNERS); // means thar rectangles will have 2 corners defined rather than width & height 

  strokeWeight(2); // sets thickness of drawing tools
  fill(plotFill); // sets the colour of the plot window
  stroke(plotFill); // sets the colour of the rectangle perimeter to the same as the fill colour
  rect(lMargin, tMargin, rMargin, bMargin);
  drawScales(); // draws the scales on the plot
  drawGridLines(lMargin, rMargin-1); // draw gridlines
  drawHorizontalScale(); // draws the horizontal scale to indicate the time scale of the plot 
  textSize(14); // sets the font size of the timing-window text label
  fill(200, 20, 20); // sets the colour of the timing-window text label

  // set zero values to the necessary timing variables
  for (byte i =0; i<3; i++) { // repeat 3 times as there are 3 pressure windows
    start[i] = 0;
    msTime[i] = 0;
    count[i] = 0;
    average[i] = 0;
    winActive[i] = false;
  }

  defineWindows(); // assigns values to the timing window variables
  drawButtons(0, nButtons-1); // draws the "normal program buttons
  drawDataCaptions(); // this labels the 3 timing window data areas as Window 1"... Window 3"
  drawMovableWindows(); // this draws the 3 coloured blocks which represent the current timing windows
  updateTimingData(); // this updates the data displayed for each of the 3 timing windows
}

void defineWindows() { // this function assigns values to the timing window variables e.g., upper & lower values

  // defines pressure monitoring window 1 defaults (is also user-customisable)
  upper[0] = uScale[aC]; // sets the top of the 1st windows to full scale
  lower[0] = uScale[aC] - gapNum; // sets the bottom of the 1st window to 1 division down
  valR[0] = 211; 
  valG[0] = 32; 
  valB[0] = 32; // sets the colours for this window

  // defines pressure monitoring window 2 defaults (is also user-customisable)
  upper[1] = ((lScale[aC] + uScale[aC]) / 2) + (0.5 * gapNum); // sets the top of the 2nd windows to mid-point + 1/2 a division
  lower[1] = ((lScale[aC] + uScale[aC]) / 2) - (0.5 * gapNum); // sets the top of the 2nd windows to mid-point - 1/2 a division
  valR[1] = 250; 
  valG[1] = 124; 
  valB[1] = 38; // sets the colours for this window  


  // defines pressure monitoring window 3 defaults (shall be customisable)
  upper[2]=lScale[aC] + gapNum; // sets the top of the 3rd window to 1 division up
  lower[2]=lScale[aC]; // sets the bottom of the 3rd windows to minimum scale value
  valR[2] = 49; 
  valG[2] = 193; 
  valB[2] = 31; // sets the colours for this window

  // defines generic window settings
  for (byte i = 0; i<3; i++) {
    ignoring[i] = false;
    upperDrag[i] = false;
    lowerDrag[i] = false;
    darkR[i] = darken(valR[i], 40); // runs the function below which returns a darker shade of the colour element R
    darkG[i] = darken(valG[i], 40); // runs the function below which returns a darker shade of the colour element G
    darkB[i] = darken(valB[i], 40); // runs the function below which returns a darker shade of the colour element B
  }
  setWindowHeight(); // calls the function which sets the data windows' heights & ensures they don't clash
}

void buttons() { // this function is called universally and determines which buttons to draw based on the current screen
  if (bActive[4]) {
    drawButtons(nButtons+cButtons+dButtons, nButtons+cButtons+dButtons+tButtons-1); // draw timebase buttons
  }
  else if (bActive[3] || bActive[5]) {
    if (calStage ==0) {
      drawButtons(nButtons+4, nButtons+5);
    } else if (calStage >0 && calStage <8) {
      drawButtons(nButtons, nButtons+cButtons-3); // draw the calibration buttons
    } else if (calStage == 8) {
      drawButtons(nButtons+cButtons, nButtons+cButtons+dButtons-1); // draw the file operation buttons
    }
  }
  else drawButtons(0, nButtons-1); // draw the normal buttons
}

void drawButtons(int lo, int hi) { // draws the button in the range specified e.g., 0..3. The importing of button numbers
// to be drawn makes the function more flexible as it can draw only the buttons currently required for display
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

int darken(int colourIn, int strength) { // this function returns a darker shade of a colour
// it simply takes the incoming colour value e.g., R, G, or B, and reduces is by the reduction strength which is
// also passed into the function when it is called, it limits the value to 0 or above thus preventing negative values
// the purpose is to run this small section of code multiple times for different colours, saving on lines of code
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

  // (note: y=0 is at the top of the screen)
  winBotY[0] = winTopY[0] +24; // sets the bottom of the text box 24 pixels lower than the top
  winBotY[1] = winTopY[1] +24; // sets the bottom of the text box 24 pixels lower than the top
  winBotY[2] = winTopY[2] +24; // sets the bottom of the text box 24 pixels lower than the top

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
