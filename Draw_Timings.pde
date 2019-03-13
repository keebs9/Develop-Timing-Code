int timeXpos = rMargin+220; // defines the X position of the timing data box
int timeWidth = 90; // defines the width of the timing data box 
int timeShade = 255; // defines the shade of the timing data box
int textWidth = 140; // defines the width of the timing data caption box e.g., "Window 1"
int textShade = 230; // defines the shafe of the timing data caption box

int winXpos = timeXpos-90; // defines the position for the adjustable timing window
int winWidth = 70; // defines the width of the adjsuatble timing window
float y1; // used to record the upper Y position of the adjustable timing window (tidies the code)
float y2; // used to record the lower Y position of the adjustable timing window (tidies the code)
float sTime; // stores the last time converted to the nearest 10th of a second
float aTime; // stores the average time converted to the nearest 10th of a second

void updateTimingData() {
 
  for (byte i =0; i<3; i++) { // repeat for number of timing windows
    // map the window position in relation to the scale based on the window limits
    
    //convert last time from milliseconds to seconds with 1 decimal point
    sTime = round(msTime[i]/100.0); // rounds the milliseconds to 10ths of a second (note round yields a whole number)
    sTime = sTime /10; // now divide the 10ths of seconds by 10 to get decimal seconds to 1dp
    
    //convert average time from milliseconds to seconds with 1 decimal point
    aTime = round(average[i]/100.0); // rounds the milliseconds to 10ths of a second (note round yields a whole number)
    aTime = aTime /10; // now divide the 10ths of seconds by 10 to get decimal seconds to 1dp
        
    fill(textShade); // sets fill colour of the blanking rectangle used to cover previous text
    stroke (textShade); // this must be the same colour as the fill (it is the outside of the rectangle)
    rect(timeXpos, winTopY[i], timeXpos+textWidth, winBotY[i]); // draw blanking rectangle over "last time" text
    rect(timeXpos, winBotY[i]+4, timeXpos+textWidth, winBotY[i]+28); // draw blanking rectangle over "average time" text
    fill(timeShade); // set fill colour to that of the timing box
    stroke (timeShade); // sets the stroke colour to that of the timing box
    rect(timeXpos+textWidth+1, winTopY[i], timeXpos+textWidth+timeWidth, winBotY[i]); // draws the "last time" box
    rect(timeXpos+textWidth+1, winBotY[i]+4, timeXpos+textWidth+timeWidth, winBotY[i]+28); // draws the "average time" box
    
    textSize(14); // define text size
    if (i==2 && nWin==2) fill(grey); else fill(0); // set text to black unless drawing inactive 3rd window
    text("Last duration: ", timeXpos+4, winTopY[i]+17); // prints the "last time" parmater label
    text("Average duration: ", timeXpos+4, winBotY[i]+21); // prints the "last time" parmater label
    
    if (winActive[i] && !ignoring[i] && i< nWin) { // if this timing window is active enlarge the text & change its colour
      textSize(16); // set increased font size of the highlighted text
      fill(220, 155, 20); // sets the colour for the highlighted text
      text(sTime+ "s", timeXpos+textWidth+10, winTopY[i]+17); // print the time for this window in seconds
      text(aTime+ "s", timeXpos+textWidth+10, winBotY[i]+21); // print the time for this window in seconds
    } else {
      textSize(14); // set the font size to normal for normal text
      if (i==2 && nWin==2) {
        fill(grey);
        text("n/a",timeXpos+textWidth+10, winTopY[i]+17); // advises that the window time in inactive and not applicable
        text("n/a",timeXpos+textWidth+10, winBotY[i]+21); // advises that the window time in inactive and not applicable
      } else {
          fill(0); // set text to black unless drawing inactive 3rd window
          text(sTime+ "s", timeXpos+textWidth+10, winTopY[i]+17); // print the time for this window in milliseconds
          text(aTime+ "s", timeXpos+textWidth+10, winBotY[i]+21); // print the time for this window in milliseconds
      }
    }
  }
}

void drawDataCaptions() { // this is only used when the windows are first drawn or moved
  fill(bgFill); // sets the colour to that of the background
  stroke(bgFill); // sets the line colour for the outside of the rectangle to that of the background
  rect(timeXpos, 0, timeXpos + timeWidth + textWidth, progHeight); // blanks the whole area of the timing screen so it can be re-drawn afresh
  
  for (byte i=0; i<3; i++){ // reepat 3 times, once for each timing window possible
    textSize(14); // sets the font size of the timing-window text label
    if (i==2 && nWin==2) fill(grey); else fill(200, 20, 20); // set text to grey if drawing inactive 3rd window
    text("Window" + (i+1) +": ", timeXpos, winTopY[i]-8); // print the text caption for the window
  }
}

void drawMovableWindows() { // this is used when only the timing needs to be updated
  
  // clear the area of the adjustable windows and redraw them
  fill(bgFill); // set the fill colour to the background colour
  stroke(bgFill); // set the line colour to the background colour
  rect (winXpos, tMargin, winXpos+winWidth, bMargin+20); // blanks the whole area that could have windows drawn in 
  
  for (byte i=0; i<3; i++) { // repeat 3 times, once for each timing window possible
    
    // map the window position in relation to the scale based on the window limits
    y1 = map(upper[i], lScale[aC], uScale[aC], plotHeight, 0) + tMargin;
    y2 = map(lower[i], lScale[aC], uScale[aC], plotHeight, 0) + tMargin;
    
    if (i==2 && nWin==2) { // if drawing the 3rd window but only 2 are active
      fill(grey); // set colour to greyed out
    } else fill(valR[i], valG[i], valB[i]); // sets the fill colour to that of the current window
    noStroke(); // sets the rectangle to have no outer line
    rect(winXpos, y1, winXpos + winWidth, y2); // draw the adjustable window
    
    if (i==2 && nWin==2) { // if drawing th3 3rd window but only 2 are active
      stroke(grey-20); // set the colour to slighly darker than the greyed out colour
    } else stroke(darkR[i], darkG[i], darkB[i]);
    line(winXpos, y1, winXpos + winWidth, y1); // draw upper line of adjustable window
    line(winXpos, y2, winXpos + winWidth, y2); // draw lower line of adjustable window
  }
}
