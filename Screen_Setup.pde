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

  for (byte i =0; i<3; i++) { // repeat 3 times as there are 3 pressure windows
    time[i]=0;
    active[i]=false;
  }

  defineWindows();
  drawButtons();
  drawDataCaptions();
  drawMovableWindows();
  updateTimingData();
}

void defineWindows() {
  // defines pressure monitoring window 1 defaults (shall be customisable)
  upper[0] = uScale; // sets the top of the 1st windows to full scale
  lower[0] = uScale - gapNum; // sets the bottom of the 1st window to 1 division down
  ignoring[0] = false;
  valR[0] = 252; valG[0] = 187; valB[0] = 7; // sets the colours for this window
  
  // sets the line colour to a darker shade of the current window colour
  darkR[0] = darken(valR[0], 40); // runs the function below which returns a darker shade of the colour element R
  darkG[0] = darken(valG[0], 40); // runs the function below which returns a darker shade of the colour element R
  darkB[0] = darken(valB[0], 40); // runs the function below which returns a darker shade of the colour element R

  // defines pressure monitoring window 2 defaults (shall be customisable)
  upper[1] = ((abs(lScale) + abs(uScale)) / 2) + (0.5 * gapNum); // sets the top of the 2nd windows to mid-point + 1/2 a division
  lower[1] = ((abs(lScale) + abs(uScale)) / 2) - (0.5 * gapNum); // sets the top of the 2nd windows to mid-point - 1/2 a division
  ignoring[1]=false;
  valR[1] = 0; valG[1] = 177; valB[1] = 216; // sets the colours for this window
  
  // sets the line colour to a darker shade of the current window colour
  darkR[1] = darken(valR[1], 40); // runs the function below which returns a darker shade of the colour element R
  darkG[1] = darken(valG[1], 40); // runs the function below which returns a darker shade of the colour element R
  darkB[1] = darken(valB[1], 40); // runs the function below which returns a darker shade of the colour element R

  // defines pressure monitoring window 3 defaults (shall be customisable)
  upper[2]=lScale + gapNum; // sets the top of the 3rd window to 1 division up
  lower[2]=lScale; // sets the bottom of the 3rd windows to minimum scale value
  ignoring[2]=false;
  valR[2] = 255; valG[2] = 99; valB[2] = 223; // sets the colours for this window
  
  // sets the line colour to a darker shade of the current window colour
  darkR[2] = darken(valR[2], 40); // runs the function below which returns a darker shade of the colour element R
  darkG[2] = darken(valG[2], 40); // runs the function below which returns a darker shade of the colour element R
  darkB[2] = darken(valB[2], 40); // runs the function below which returns a darker shade of the colour element R
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

int darken(int colourIn, int strength){
  if (colourIn>= strength){
    colourIn = colourIn - strength;
  } else colourIn = 0;
  return colourIn;
}
