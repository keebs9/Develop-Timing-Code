// declare variables used for drawing the plot
int yPos; // stores the current Y position of the trace
float xPos = 0; // sets the initial X position of the trace
int oldY; // stores the previous recored Y position of the trace
float oldX = 0; // stores the previous recored X position of the trace
int clrWidth = 40; // this is the width of the clear box in front of the trace
// this improves plot appearance in response to rapid changes of vertical position (magnitude)

void drawPlot() { // a function used to draw the pressure plot on the plot window
  // sets the drawing colour based on whether the trace is in a measurement window or not
  float pos = (map(cY, 0, plotHeight-2, lScale[aC], uScale[aC])); // maps the current Y position back to the true pressure;
  stroke(10); // sets the default colour of the trace for when it is out of all timing windows
  for (byte i=0; i<3; i++){ // repeat 3 times, once for each pressure window
    if ((pos > lower[i]) && (pos <= upper[i]) && winActive[i]) {
      stroke(valR[i], valG[i], valB[i]); // set the drawing colours to that of the active window 
    }
  }
  strokeWeight(3); // sets thickness of the line to 3, rather than 2 as in the majority of the program
  strokeCap(ROUND); // this has to be round for this function otherwise there are many gaps, constant pressure lines disappear
  //point(xIn+lMargin, plotHeight-yIn+tMargin);
 
  line(oX+lMargin, plotHeight-oY+tMargin, cX+lMargin, plotHeight-cY+tMargin); // draw plot line from last to current position
  
  strokeCap(SQUARE); // resets sroke cap for rest of the program
  strokeWeight(2); // resets line thickness for rest of the program}
}

void blankAhead(){ // this function draws the blanking box in front of the current trace position & re-draws the scale lines in that area
  // Note that xPos is always relative to plot width for calculations and the margins added when drawn
  fill(plotFill); // sets the fill colour for the blanking rectangle
  stroke(plotFill); // sets the colour of the rectangle perimeter
  strokeWeight(1); // sets the weight of the rectangle perimeter to 1
   
   if (xPos<2) { // avoids missing the remnants of the previous very left-hand trace
    rect(lMargin, tMargin, lMargin+3, bMargin); // blanks an area in front of the trace
    strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
    drawGridLines(lMargin,lMargin+5);
   } else
    if (xPos < (plotWidth-clrWidth-2)) { // has to be -2 or it overlaps R/H scale by 1 pixel
      rect(xPos+lMargin, tMargin, xPos+lMargin+clrWidth, bMargin); // blanks an area in front of the trace
      strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
      drawGridLines(xPos+lMargin, xPos + lMargin + clrWidth +1);
  } else {
    if (xPos<plotWidth-2) { // when at right edge of window
      // blanking rectangle still required else the plot line looks thicker
      rect(xPos+lMargin, tMargin, plotWidth+lMargin-2, plotHeight+tMargin); // blanks an area in front of the trace
      strokeWeight(2); // sets the weight of the stroke back to my default thickness of 2
      
      for (byte i =0; i <= nDivisions; i++) { // repeat for number of scale points
        yScale = tMargin + (plotHeight * (i * 0.125)); // calculates the vertical position of the current scale 
        
        // set the colour of the scale lines over the actual plot (black for centre line)
        if (i == nDivisions/2) stroke(10);
        else stroke(scaleColour);
        line(xPos-1+lMargin, yScale, plotWidth+lMargin-1, yScale); // draws the scale lines over the actual plot
      }
    }
  }
}

void clearPlotArea() { // clear the whole plot area
  fill(plotFill); // set the fill colour to the background colour of the plot
  stroke(plotFill); // set the line colour to the background colour of the plot
  rect (lMargin+1, tMargin, rMargin-2, bMargin); // blanks the whole plot area
}
