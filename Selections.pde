// declare variables used in determination of selections
float upLinePos; // stores the graphical Y position of the upper selector line (rather than pressure value of line)
float lowLinePos; // stores the graphical Y position of the lower selector line (rather than pressure value of line)
int xM = 0; // stores the x position of the mouse when read as it is referenced several times
int yM = 0; // stores the y position of the mouse when read as it is referenced several times
byte minSize = 10; // defines the mimimum thickness of the timing windows
byte minGap = 4; // defines the minimum gpa between successive pressure windwos
float compare; // stores the difference in #pixels between two timing windows

boolean butPress; // true if any button is being pressed, if so don't process line selections
boolean lineDrag; // true if any line is selected, if so don't process any button selections

void whatSelected() { // a function used to determine what screen element has been selected
  xM = mouseX; // read the mouse X position into a variable for mulitiple referencing
  yM = mouseY; // read the mouse Y position into a variable for mulitiple referencing

  if (!lineDrag) checkButtonPress(); // if a line isn't being moved check for button presses
  
  // if a button isn't being held & not in calibration mode, check windows adjustments
  if (!butPress && !bActive[3]) checkWindowDrag();
}

void checkButtonPress() { // is a button being pressed?
  butPress = false; // sets the logical variable butPress to the default assumption of false
  for (byte i = 0; i < (tButtons); i++) { // repeat for each button
    if ((xM >= bX1[i] && xM <= bX2[i]) && (yM >= bY1[i] && yM <= bY2[i])) { // checks the mouse position against button co-ordinates
      
      // if a normal buttons 0-7 and not in calibration mode, or higher buttons but in certain calibration modes...
      if ((i<nButtons && calStage == -1) || (i>nButtons-1 && (calStage == 0 || calStage == 7))) { 
        bPress[i] = true; // set the current button to pressed
        actionButtons(); // process the button selection
        butPress = true; // sets the logical variable butPress to true, this is tested elsewhere in the program
      }
    }
    // if any buttons are alraedy held (but the mouse is no longer over them) then set butPress to true
    if (bHeld[i]) butPress = true; // sets the logical variable butPress to true, this is tested elsewhere in the program
  }
}

void checkWindowDrag() { // is one of the pressure window limits being adjusted?
  lineDrag = false; // sets the logical variable lineDrag to the default assumption of false
  for (byte i = 0; i <nWin; i++) { // repeat for each active pressure window
    // map the pressure values to graphical heights, note pressure and graphical values are inverse of each other
    upLinePos = map(upper[i], lScale[aC], uScale[aC], bMargin, tMargin); 
    lowLinePos = map(lower[i], lScale[aC], uScale[aC], bMargin, tMargin);

// **look for upper line selections**     

    // if the mouse is in range, or the line is already selected...
    // the -2 and +3 in determining the selection are to save pointer precision, making the line easier to click on
    if ((yM >= upLinePos-2 && yM <= upLinePos+3 && xM >= winXpos && xM <= winXpos + winWidth) || upperDrag[i]) {
      for (byte j =0; j<nWin; j++) { // repeat for each active pressure window

        // if any adjsutable lines (other than this one) are selected then lineDrag is True
        if (upperDrag[j] && !upperDrag[i]) lineDrag = true; // if any upper lines selected then lineDrag is True
        if (lowerDrag[j]) lineDrag = true; // if any lower lines selected then lineDrag is True
      }
      if (lineDrag) break; // if another line is already selected then exit the for loop

      upperDrag[i] = true; // set the line as being selected
      lineDrag = true; // state that a line is being selected (tested elsewhere in the program)
      upLinePos = yM; // set the new upper limit to the current mouse Y position
      if (i<2) { // if the upper or middle window...
        upLinePos = constrain (upLinePos, tMargin, bMargin); // constrain the value to within the plot window
      } else upLinePos = constrain (upLinePos, tMargin, bMargin + minSize + minGap); // constrain to the plot window or just below (3rd window only)
      
      // stop the top of the window merging with the bottom of the window
      if (upLinePos > lowLinePos-minSize) upLinePos = lowLinePos-minSize;

      // stop the 2nd and 3rd upper margins going above the next winows lower margin
      compare = map(lower[constrain(i-1, 0, 2)], lScale[aC], uScale[aC], bMargin, tMargin); // constrain to within array limits
      if (i>0 && upLinePos < compare+minGap) upLinePos = compare+minGap;

      // map the value from graphical back to pressure, noting that they are the inverse of each other
      upLinePos = map(upLinePos, tMargin, bMargin, uScale[aC], lScale[aC]);

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
      if (i<2){ // if the upper or middle window...
        lowLinePos = constrain (lowLinePos, tMargin, bMargin); // constrain the value to within the plot window
      } else lowLinePos = constrain (lowLinePos, tMargin, bMargin+20); // constrain to plot window, or just below (3rd window only)
            
      // stop the bottom of the window merging with the top of the window
      if (lowLinePos < upLinePos+minSize) lowLinePos = upLinePos+minSize;

      // stop the 1st and 2nd lower margins going below the next winows upper margin
      compare = map(upper[constrain(i+1, 0, 2)], lScale[aC], uScale[aC], bMargin, tMargin); // constrain to within array limits
      if (i<2 && lowLinePos > compare-minGap) lowLinePos = compare-minGap;

      // map the value from graphical back to pressure, noting that they are the inverse of each other
      lowLinePos = map(lowLinePos, tMargin, bMargin, uScale[aC], lScale[aC]);

      lower[i] = lowLinePos; // assign the pressure based lower limit
      resetTiming(i); // reset the current window timings as they're now invalid due to new parameters
            
      setWindowHeight(); // calls the function which sets the data windows' heights & ensures they don't clash
      drawMovableWindows(); // redraw the adjustable windows 
      drawDataCaptions(); // redraw the data windows
      break; // exits the for loop and stops looking for lines to be selected
    }
  }
}

void actionButtons() { // take specific actions depending on which button has been pressed / selected
// **specifically deals with the first 2 buttons which are interlocked**
  // if button 0 or 1 are exclusively pressed and weren't previously 
  if (!bHeld[2]  && !bHeld[3] && ((bPress[0] && !bHeld[0] && !bHeld[1]) || (bPress[1] && !bHeld[1] && !bHeld[0]))) {
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

    drawDataCaptions(); // redraw the timing windows and captions (as may have changed colour)
    updateTimingData(); // redraw the timing windows and captions (as may have changed colour)
    drawMovableWindows(); // redraw the adjustable windows (as will may have changed colour)
  }

// specifically deals with button 3 which determines if transients are ignored
  // if button 2 is exclusively pressed but wasn't previously
  if (bPress[2] && !bHeld[2] && !bHeld[0] && !bHeld[1] && !bHeld[3]) {
    bActive[2] = !bActive[2]; // invert the button2 Held
    ignore = bActive[2]; // set the ignore flag to the button state i.e., True or False
    bHeld[2] = true; // set the button Held to true meaning it was already pressed and actioned
  }
  
// specifically deals with button 4 which will put the program into calibration mode
  // if button 3 is exclusively pressed & not already in calibration mode...
  if (bPress[3] && !bActive[3] && !bHeld[0] && !bHeld[1] && !bHeld[2]) {
    bActive[3] = true; // set button 3 as active, this is used to determine that the program is in calibration mode
    calStage = 0; // sets the progress of calibration to one
    clearWinArea(); // blanks out all the timing data
    clearPlotArea(); // clears the plot area ready to be used by the calibration routine
  }
  
// specifically deals with button 6 which will allow the user to set the scales and save the setup if desired
  // if button 5 is exclusively pressed & not already in calibration mode...
  if (bPress[5] && !bActive[5] && !bHeld[0] && !bHeld[1] && !bHeld[2]) {
    bActive[5] = true; // set button 3 as active, this is used to determine that the program is in calibration mode
    calStage = 3; // sets the progress of calibration to 3, bypassing the calibration of the actual transducer
    clearWinArea(); // blanks out all the timing data
    clearPlotArea(); // clears the plot area ready to be used by the calibration routine
  }

// specifically deals with button 7 which sets if timing should start after a phase change
  // if button 6 is exclusively pressed but wasn't previously
  if (bPress[6] && !bHeld[6] && !bHeld[0] && !bHeld[1] && !bHeld[3]) {
    bActive[6] = !bActive[6]; // invert the button6 Held
    startNext = bActive[6]; // set the startNext flag to the button state i.e., True or False
    bHeld[6] = true; // set the button Held to true meaning it was already pressed and actioned
    
    if (startNext) { // if startNext activated, reset all the timings, but reactivate the current pressure window (if was active)
      byte index = -1; // set the index flag out of range of the pressire woindows (0..2) 
      for (byte i=0; i<nWin; i++) { // repeat for each window
        if (winActive[i]) index = i; // if the window is active set the index to it (only 1 can be active at once)
      }
      for (byte i=0; i<nWin; i++) resetTiming(i); // reset the timing of each window (0..2)
      if (index>-1) winActive[index]=true; // if an index was set then reactivate that window
    }
  }
  
// specifically deals with button 8 which turns the recording on / off
  // if button 7 is exclusively pressed but wasn't previously
  if (bPress[7] && !bHeld[7] && !bHeld[0] && !bHeld[1] && !bHeld[3]) {
    bActive[7] = !bActive[7]; // invert the button6 Held
    bHeld[7] = true; // set the button Held to true meaning it was already pressed and actioned
    
    if (bActive[7]) {
      startRecording();
      bText[7] = "Stop" + '\n' + "recording";
    } else {
      stopRecording();
      stopRecStamps();
      bText[7] = "Start" + '\n' + "recording";
    }
  }

// specifically deals with the calibration buttons (9-12)
  if (calStage == 0) { // if acquiring the pressure units during calibration stage 0...
    for (byte j=nButtons; j < tButtons; j++) { // repeat for all the calibration buttons
      if (bPress[j] && !bHeld[j]) { // if the button was pressed...
        units[nConfigs-1] = bText[j]; // sets the current unit text to that of the button
        bActive[j] = true; // set the button press to active
        bHeld[j] = true; // set the button Held to true meaning it was already pressed and actioned
        calStage++;
      }
    }
  } else if (calStage == 7) { // if querying whether the data should be saved during calibration stage 7...
     for (int j = nButtons + cButtons; j < tButtons; j++) { // repeat for all the calibration buttons (was nBut + cBut -1)
      if (bPress[j] && !bHeld[j]) { // if the button was pressed...
        bActive[j] = true; // set the button press to active
        bHeld[j] = true; // set the button Held to true meaning it was already pressed and actioned
        if (j<tButtons-1) { // if not the "don't save" button which has been pressed then...
          minRaw[j- nButtons - cButtons] = minRaw[nConfigs-1]; // set the selected dataset to the new value 
          maxRaw[j- nButtons - cButtons] = maxRaw[nConfigs-1]; // set the selected dataset to the new value
          lScale[j- nButtons - cButtons] = lScale[nConfigs-1]; // set the selected dataset to the new value
          uScale[j- nButtons - cButtons] = uScale[nConfigs-1]; // set the selected dataset to the new value
          trueLo[j- nButtons - cButtons] = trueLo[nConfigs-1]; // set the selected dataset to the new value
          trueHi[j- nButtons - cButtons] = trueHi[nConfigs-1]; // set the selected dataset to the new value
          saveCalData(); // save the data unless the button pressed was "don't save"
        }
        aC = j-nButtons-cButtons; // sets the active config to either the dataset selected or the temporary set stored in set 5 (was also -1)
        calStage++; // move on to the next calibration stage
      }
    }
  }
  
  buttons(); // redraw the buttons (as they may have changed state)
}

void clearWinArea() { // clear the area where timing windows and timing data is displayed
  fill(bgFill); // set the fill colour to the background colour of the screen
  stroke(bgFill); // set the line colour to the background colour of the screen
  rect (winXpos, 0, progWidth, progHeight); // blanks the whole area that could have windows & timings drawn in
}
