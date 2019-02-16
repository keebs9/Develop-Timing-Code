// set up variables in determination of selections

float upLinePos; // holds the graphical Y position of the upper selector line (rather than pressure value of line)
float lowLinePos; // holds the graphical Y position of the lower selector line (rather than pressure value of line)
boolean otherSelected; // a logic test of if other lines are selected
int xM = 0;
int yM = 0;
float compare;

void whatSelected() {
  xM = mouseX; // read the mouse X position into a variable
  yM = mouseY; // read the mouse Y position into a variable
  
  // check if a button is being selected, if not check if any windows are being dragged
  if (!checkButtonPress()) checkWindowDrag();
}
   
boolean checkButtonPress() {  // is a button being pressed?
  otherSelected = false; // a variable for checking if anything is selected
  
  // chcek if any other lines are selected
  for (byte i = 0; i <nWin; i++) { // repeat for number of active windows
    // if upper or lower line is selected then set otherSelected to true
    if (upperDrag[i] || lowerDrag[i]) otherSelected = true;
  }
  
  if (!otherSelected){ // if no lines are selected
    otherSelected = false; // reset to nothing selected & test for button selections
    for (byte i = 0; i < (nButtons); i++) { // repeat for each button
      if ((xM >= bX1[i] && xM <= bX2[i]) && (yM >= bY1[i] && yM <= bY2[i])) {
          bPress[i] = true; // set the current button to pressed
          actionButtons(); // process the button selection
          otherSelected = true;
      }
       // if any buttons are alraedy held (but the mouse is no longer over them) then set otherSelected to true
      if (bHeld[i]) otherSelected =true; 
    }
  }
  return otherSelected;
}
    
void checkWindowDrag() { // is one of the pressure window limits being adjusted?
  otherSelected = false;  
  for (byte i = 0; i <nWin; i++) { // repeat for each active pressure window
    // map the pressure values to graphical heights, note pressure and graphical values are inverse of each other
    upLinePos = map(upper[i], lScale, uScale, bMargin, tMargin); 
    lowLinePos = map(lower[i], lScale, uScale, bMargin, tMargin);
    
    // **look for upper line selections**     

    // if the mouse is in range or the line is already selected
    // the -2 and +3 in determining the selection are to save pointer prcesions, making the line easier to click on
    if ((yM >= upLinePos-2 && yM <= upLinePos+3 && xM >= winXpos && xM <= winXpos + winWidth) || upperDrag[i]){
      for (byte j =0; j<nWin; j++){ // repeat for each active pressure window
        
        // if any adjsutable lines (other than this one) are selected then otherSelected is True
        if (upperDrag[j] && !upperDrag[i]) otherSelected = true;
        if (lowerDrag[j]) otherSelected = true; // if any lower lines selected then otherSelected is True
      }
      if (otherSelected) break; // if another line is selected then exit the for loop
                   
      upperDrag[i] = true; // set the line as being selected
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
             
      drawMovableWindows(); // redraw the adjustable windows 
      drawDataCaptions(); // redraw the data windows
      break; // exits the for loop and stops looking for lines to be selected
    }
   
    // **now look for lower line selections**
    
    // if the mouse is in range or the line is already selected
    // the -2 and +3 in determining the selection are to save pointer prcesions, making the line easier to click on
    if ((yM >= lowLinePos-2 && yM <= lowLinePos+3 && xM >= winXpos && xM <= winXpos + winWidth) || lowerDrag[i]){
      for (byte j =0; j<nWin; j++){ // repeat for each pressure window
        
        // if any adjsutable lines (other than this one) are selected then otherSelected is True
        if (lowerDrag[j] && !lowerDrag[i]) otherSelected = true;
        if (upperDrag[j]) otherSelected = true; // if any lower lines selected then otherSelected is True
      }
      if (otherSelected) break; // if another line is selected then exit the for loop
                   
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
     
      drawMovableWindows(); // redraw the adjustable windows 
      drawDataCaptions(); // redraw the data windows
      break; // exits the for loop and stops looking for lines to be selected
    }
  }
}

void actionButtons() {
  // **specifically deals with the first 2 buttons which are interlocked**
  
  // if button 0 or 1 are exclusively pressed and weren't previously 
  if (!bHeld[2] && ((bPress[0] && !bHeld[0] && !bHeld[1]) || (bPress[1] && !bHeld[1] && !bHeld[0]))){
    if (!bActive[0] && bPress[0]) { // if button 0 wasn't active and is pressed... //<>//
      bActive[0] = true;
      bActive[1] = false;
      nWin = 2; // set the number of active windows to 2
      winActive[2] = false; // set the 3rd window to incative
      start[2] = 0; // reset the 3rd window start time to zero (so timing doesn't continue);
    } else if (!bActive[1] && bPress[1]) { // if button 1 wasn't active and is pressed...
      bActive[0] = false;
      bActive[1] = true;
      nWin = 3; // set the number of active windows to 3
  }
    if (bPress[0]) bHeld[0] = true;
    if (bPress[1]) bHeld[1] = true;
    
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
