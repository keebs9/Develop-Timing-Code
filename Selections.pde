// set up variables in determination of selections //<>//

float upLinePos; // holds the graphical Y position of the upper selector line (rather than pressure value of line)
float lowLinePos; // holds the graphical Y position of the lower selector line (rather than pressure value of line)
int xM = 0;
int yM = 0;
float compare;

boolean butPress; // used to determine if any button is being pressed, if so don't process line selections
boolean lineDrag; // used to determine if any line is selected, if so don't process any button selections

void whatSelected() {
  xM = mouseX; // read the mouse X position into a variable
  yM = mouseY; // read the mouse Y position into a variable

  if (!lineDrag) checkButtonPress();
  if (!butPress) checkWindowDrag();
}

void checkButtonPress() { // is a button being pressed?
  butPress = false;
  for (byte i = 0; i < (nButtons); i++) { // repeat for each button
    if ((xM >= bX1[i] && xM <= bX2[i]) && (yM >= bY1[i] && yM <= bY2[i])) {
      bPress[i] = true; // set the current button to pressed
      actionButtons(); // process the button selection
      butPress = true;
    }
    // if any buttons are alraedy held (but the mouse is no longer over them) then set butPress to true
    if (bHeld[i]) butPress =true;
  }
}

void checkWindowDrag() { // is one of the pressure window limits being adjusted?
  lineDrag = false;  
  for (byte i = 0; i <nWin; i++) { // repeat for each active pressure window
    // map the pressure values to graphical heights, note pressure and graphical values are inverse of each other
    upLinePos = map(upper[i], lScale, uScale, bMargin, tMargin); 
    lowLinePos = map(lower[i], lScale, uScale, bMargin, tMargin);

    // **look for upper line selections**     

    // if the mouse is in range or the line is already selected
    // the -2 and +3 in determining the selection are to save pointer prcesions, making the line easier to click on
    if ((yM >= upLinePos-2 && yM <= upLinePos+3 && xM >= winXpos && xM <= winXpos + winWidth) || upperDrag[i]) {
      for (byte j =0; j<nWin; j++) { // repeat for each active pressure window

        // if any adjsutable lines (other than this one) are selected then lineDrag is True
        if (upperDrag[j] && !upperDrag[i]) lineDrag = true; // if any upper lines selected then lineDrag is True
        if (lowerDrag[j]) lineDrag = true; // if any lower lines selected then lineDrag is True
      }
      if (lineDrag) break; // if another line is already selected then exit the for loop

      upperDrag[i] = true; // set the line as being selected
      lineDrag = true; // state that a line is being pressed
      upLinePos = yM; // set the new upper limit to the current mouse Y position
      upLinePos = constrain (upLinePos, tMargin, bMargin); // constrain the value to within the plot window
      // stop the top of the window merging with the bottom of the window
      if (upLinePos > lowLinePos-5) upLinePos = lowLinePos-5;

      // stop the 2nd and 3rd upper margins going above the next winows lower margin
      compare = map(lower[constrain(i-1, 0, 2)], lScale, uScale, bMargin, tMargin); // constrain to within array limits
      if (i>0 && upLinePos < compare+5) upLinePos = compare+5;

      // map the value from graphical back to pressure, noting that they are the inverse of each other
      upLinePos = map(upLinePos, tMargin, bMargin, uScale, lScale);

      upper[i] = upLinePos; // assign the pressure based upper limit
      msTime[i] = 0; // reset the last cycle time as it is void due to new monitoring window
      count[i] = 0; // reset the current cycle count as it is void due to new monitoring window
      totTime[i] = 0; // reset the total of cycle times (used in averaging) as it is void due to new monitoring window
      average[i] = 0; // reset the average cycle time as it is void due to new monitoring window

      setWindowHeight();
      drawMovableWindows(); // redraw the adjustable windows 
      drawDataCaptions(); // redraw the data windows
      break; // exits the for loop and stops looking for lines to be selected
    }

    // **now look for lower line selections**

    // if the mouse is in range or the line is already selected
    // the -2 and +3 in determining the selection are to save pointer prcesions, making the line easier to click on
    if ((yM >= lowLinePos-2 && yM <= lowLinePos+3 && xM >= winXpos && xM <= winXpos + winWidth) || lowerDrag[i]) {
      for (byte j =0; j<nWin; j++) { // repeat for each pressure window

        // if any adjsutable lines (other than this one) are selected then otherSelected is True
        if (lowerDrag[j] && !lowerDrag[i]) lineDrag = true;
        if (upperDrag[j]) lineDrag = true; // if any lower lines selected then otherSelected is True
      }
      if (lineDrag) break; // if another line is selected then exit the for loop

      lowerDrag[i] = true; // set the line as being selected
      lowLinePos = yM; // set the new upper limit to the current mouse Y position
      lowLinePos = constrain (lowLinePos, tMargin, bMargin); // constrain the value to within the plot window
      // stop the bottom of the window merging with the top of the window
      if (lowLinePos < upLinePos+5) lowLinePos = upLinePos+5;

      // stop the 1st and 2nd lower margins going below the next winows upper margin
      compare = map(upper[constrain(i+1, 0, 2)], lScale, uScale, bMargin, tMargin); // constrain to within array limits
      if (i<2 && lowLinePos > compare-5) lowLinePos = compare-5;

      // map the value from graphical back to pressure, noting that they are the inverse of each other
      lowLinePos = map(lowLinePos, tMargin, bMargin, uScale, lScale);

      lower[i] = lowLinePos; // assign the pressure based lower limit
      msTime[i] = 0; // reset the last cycle time as it is void due to new monitoring window
      count[i] = 0; // reset the current cycle count as it is void due to new monitoring window
      totTime[i] = 0; // reset the total of cycle times (used in averaging) as it is void due to new monitoring window
      average[i] = 0; // reset the average cycle time as it is void due to new monitoring window
      
      setWindowHeight();
      drawMovableWindows(); // redraw the adjustable windows 
      drawDataCaptions(); // redraw the data windows
      break; // exits the for loop and stops looking for lines to be selected
    }
  }
}

void actionButtons() {
  // **specifically deals with the first 2 buttons which are interlocked**

  // if button 0 or 1 are exclusively pressed and weren't previously 
  if (!bHeld[2] && ((bPress[0] && !bHeld[0] && !bHeld[1]) || (bPress[1] && !bHeld[1] && !bHeld[0]))) {
    if (!bActive[0] && bPress[0]) { // if button 0 wasn't active and is now pressed...
      bActive[0] = true; // set button 0 to active
      bActive[1] = false; // set btton 1 to inactive
      nWin = 2; // set the number of active windows to 2
      winActive[2] = false; // set the 3rd window to inactive
      start[2] = 0; // reset the 3rd window start time to zero (so timing doesn't continue);
      count[2] = 0; // reset the 3rd window cycle count to zero (as timing has now stopped for this window)
      average[2] = 0; // reset the 3rd window average cyclec time to zero (as timing has now stopped for this window)
    } else if (!bActive[1] && bPress[1]) { // if button 1 wasn't active and is now pressed...
      bActive[0] = false; // set btton 0 to inactive
      bActive[1] = true;// set btton 1 to active
      nWin = 3; // set the number of active windows to 3
    }
    if (bPress[0]) bHeld[0] = true; // set the held flag for comparison next time round
    if (bPress[1]) bHeld[1] = true; // set the held flag for comparison next time round

    drawButtons(); // redraw the buttons (as they may have changed state)
    drawDataCaptions(); // redraw the timing windows and captions (as may have changed colour)
    updateTimingData(); // redraw the timing windows and captions (as may have changed colour)
    drawMovableWindows(); // redraw the adjustable windows (as will may have changed colour)
  }

  // specifically deals with button 3 which determines if transients are ignored

  // if button 2 is exclusively pressed but wasn't previously
  if (bPress[2] && !bHeld[2] && !bHeld[0] && !bHeld[1]) {
    bActive[2] = !bActive[2]; // invert the button2 Held
    ignore = bActive[2]; // set the ignore flag to the button state i.e., True or False
    drawButtons(); // redraw the buttons in their new states
    bHeld[2] = true; // set the button Held to true meaning it was already pressed and actioned
  }
}
