// declare variables used for drawing the plot
int traceColour = 10; // defines the colour of the trace when not in a timing window
int livePressureFill = 255; // defines the fill colour of the live-pressure window
int livePressureOutline = #0A0ABE; // defines the colour of the live-pressure window outline
int livePressureText = #0A0ABE; // defines the colour of the live-pressure text
int livePressureClipped = #BC0B0E; // defines the colour of the pressure when outside working scale
String livePressure = ""; // stores the output text of the live pressure
boolean clipped = false; // s

int yPos; // stores the current Y position of the trace (relative to the plot window)
float xPos = 0; // stores the initial X position of the trace (relative to the plot window), initially 0
int oldY; // stores the previous recored Y position of the trace (relative to the plot window)
float oldX = 0; // stores the previous recored X position of the trace (relative to the plot window), initially 0
int clrWidth = 40; // defines the width of the clear box in front of the trace

void drawPlot() { // a function used to draw the pressure plot on the plot window
  // sets the drawing colour based on whether the trace is in a measurement window or not
  float pos = (map(cY, 0, plotHeight-2, lScale[aC], uScale[aC])); // maps the current Y position back to the true pressure; (was -2)
  stroke(traceColour); // sets the default colour of the trace for when it is out of all timing windows
  
  for (byte i=0; i<3; i++){ // repeat 3 times, once for each pressure window
    if ((pos >= lower[i]) && (pos <= upper[i]) && (nWin != i)) { // if in range & not the 3rd window when it's disabled...
      stroke(valR[i], valG[i], valB[i]); // set the drawing colours to that of the active window
    }
  }
  strokeWeight(3); // sets thickness of the line to 3, rather than 2 as in the majority of the program
  strokeCap(ROUND); // this has to be round for this function otherwise there are many gaps, constant pressure lines disappear
   
  // draw plot line from last to current position. Round is used as otherwise the line function just uses the integer
  // portion of the float number e.g., 1.9 would be read as 1 not rounded to 2
  line(oX+lMargin, round(plotHeight-oY+tMargin-1), cX+lMargin, round(plotHeight-cY+tMargin-1));
     
  strokeCap(SQUARE); // resets sroke cap for rest of the program
  strokeWeight(2); // resets line thickness for rest of the program}
  displayPressure(); // updates the live pressure display below the scale
}

void blankAhead(){ // this function draws the blanking box in front of the current trace position & re-draws the scale lines in that area
  // Note that xPos is always relative to plot width for calculations and the margins added when drawn
  fill(plotFill); // sets the fill colour for the blanking rectangle
  stroke(plotFill); // sets the colour of the rectangle perimeter
  strokeWeight(1); // sets the weight of the rectangle perimeter to 1
   
   if (xPos<3) { // avoids missing the remnants of the previous very left-hand trace
    rect(lMargin, tMargin, lMargin+5, bMargin); // blanks an area in front of the trace
    strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
    drawGridLines(lMargin,lMargin+7);
   } else
    if (xPos < (plotWidth-clrWidth-2)) { // has to be -2 or it overlaps R/H scale by 1 pixel
      rect(xPos+lMargin+1, tMargin, xPos+lMargin+clrWidth, bMargin); // blanks an area in front of the trace (added +1 for line thickness)
      strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
      drawGridLines(xPos+lMargin+1, xPos + lMargin + clrWidth +1); // (added +1 for line thickness)
  } else {
    if (xPos<plotWidth-2) { // when at right edge of window
      // blanking rectangle still required else the plot line looks thicker
      rect(xPos+lMargin+1, tMargin, plotWidth+lMargin-2, plotHeight+tMargin); // blanks an area in front of the trace (added +1 for line thickness)
      strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
      drawGridLines(xPos+lMargin+1, rMargin);    
    }
  }
}

void clearPlotArea() { // clear the whole plot area
  fill(plotFill); // set the fill colour to the background colour of the plot
  stroke(plotFill); // set the line colour to the background colour of the plot
  rect (lMargin+1, tMargin, rMargin-2, bMargin); // blanks the whole plot area
}

void displayPressure() { // displays the live pressure for reference and for calibration verification
  drawLivePressureBox(); // draws the live pressure box, overwriting previous pressure text
  livePressure = nfp(truePressure, 0, 2); // truncates the pressure to 2 decimal places
  if (clipped) fill(livePressureClipped); // sets the colour of the text when the pressure is outside the range of the scale
  else fill(livePressureText); // sets the colour of the live-pressure text
  textSize(18); // sets the size of the text for the live pressure
  text(livePressure, rMargin + 50 - (textWidth(livePressure) / 2), bMargin+60); // displays the live pressure centred in the box
  
  livePressure = units[aC]; // sets the live pressure text to that of the current units
  fill(0); // sets the colour of the live-pressure units text to black
  textSize(14); // sets the size of the text for the live pressure units
  text(livePressure, rMargin + 50 - (textWidth(livePressure) / 2), bMargin+80); // displays the live pressure centred in the box
}

void drawLivePressureBox(){ // called separately so box can be drawn without pressure data at program start
  fill(livePressureFill); // sets the live pressure box fill colour to the defined colour
  stroke(livePressureOutline); // sets the live pressure box outline colour to the defined colour
  rect(rMargin+5, bMargin+40, rMargin+105, bMargin+87); // draws the live pressure box
}
