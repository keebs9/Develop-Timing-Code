int timeXpos = rMargin+200; // defines the X position of the timing data box
int timeWidth = 90; // defines the width of the timing data box 
int timeShade = 255; // defines the shade of the timing data box
int textWidth = 105; // defines the width of the timing data caption box e.g., "Window 1"
int textShade = 230; // defines the shafe of the timing data caption box

int winXpos = rMargin+110; // defines the position for the adjustable timing window
int winWidth = 70; // defines the width of the adjsuatble timing window
float y1; // used to record the upper Y position of the adjustable timing window (tidies the code)
float y2; // used to record the lower Y position of the adjustable timing window (tidies the code)
float yWin; // used to record the upper Y position of the data timing window (tidies the code)

void updateTimingData() {
  for (byte i =0; i<3; i++) { // repeat for number of timing windows (change to a variable)
    // map the window position in relation to the scale based on the window limits
    yWin = map(upper[i]-((upper[i]-lower[i])/2), lScale, uScale, plotHeight, 0) + tMargin-5;
    
    fill(textShade); // sets fill colour of the blanking rectangle used to cover previous text
    stroke (textShade); // this must be the same colour as the fill (it is the outside of the rectangle)
    rect(timeXpos, yWin, timeXpos+textWidth, yWin+24); // draw blanking rectangle over text
    fill(timeShade); 
    stroke (timeShade);
    rect(timeXpos+textWidth+1, yWin, timeXpos+textWidth+timeWidth, yWin+24);
    textSize(14);
    fill(0);
    text("Last duration: ", timeXpos+4, yWin+18);
    if (active[i] && !ignoring[i]) { // if this timing window is active enlarge the text & change its colour
      textSize(16); // set increased font size of the highlighted text
      fill(220, 155, 20); // sets the colour for the highlighted text
      text(time[i] + "ms", timeXpos+textWidth+10, yWin+18); // print the time for this window in milliseconds
    } else {
      textSize(14); // set the font size to normal for normal text
      fill(0); // set the text colour to black for normal text
      text(time[i] + "ms", timeXpos+textWidth+10, yWin+18); // print the time for this window in milliseconds
    }
  }
}

void drawDataCaptions() { // this is only used when the windows are first drawn or moved
  fill(bgFill); // sets the colour to that of the background
  stroke(bgFill); // sets the line colour for the outside of the rectangle to that of the background
  rect(timeXpos, tMargin, timeXpos + timeWidth + textWidth, tMargin + plotHeight); // blanks the whole area of the timing screen so it can be re-drawn afresh
  
  for (byte i=0; i<3; i++){ // reepat 3 times, once for each timing window possible
    // map the window position in relation to the scale based on the window limits
    yWin = map(upper[i]-((upper[i]-lower[i])/2), lScale, uScale, plotHeight, 0) + tMargin-5;  //<>//
    
    textSize(14); // sets the font size of the timing-window text label
    fill(200, 20, 20); // sets the colour of the timing-window text label
    text("Window" + (i+1) +": ", timeXpos, yWin-8); // print the text caption for the window
  }
}

void drawMovableWindows() { // this is used when only the timing needs to be updated
  for (byte i=0; i<3; i++) { // repeat 3 times, once for each timing window possible
    
    // map the window position in relation to the scale based on the window limits
    y1 = map(upper[i], lScale, uScale, plotHeight, 0) + tMargin;
    y2 = map(lower[i], lScale, uScale, plotHeight, 0) + tMargin;
    
    fill(valR[i], valG[i], valB[i]); // sets the fill colour to that of the current window
    noStroke(); // sets the rectangle to have no outer line
    rect(winXpos, y1, winXpos + winWidth, y2);
    
    stroke(darkR[i], darkG[i], darkB[i]);
    line(winXpos, y1, winXpos + winWidth, y1); // draw upper line of adjustable window
    line(winXpos, y2, winXpos + winWidth, y2); // draw lower line of adjustable window
  }
}
