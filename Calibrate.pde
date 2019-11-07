// declare the variables used primarily to calibrate the pressure sensor
boolean enter = false; // true if the enter key has been pressed, this is often used to progress the calibration
boolean suggested = false; // true if a number has already been suggested to the user
boolean high = true; // true if the current calibration is high, otherwise it will be flaseM
int blueShade = 140; // defines the shade of blue used to display the calibration instructional text
int calStage = -1; //stores the current stage of calibration the user is at (-1 means calibraiton not in progress)
float[] minRaw = new float[nConfigs]; // stores the minimum raw calibration value (0 is minimum)
float[] maxRaw = new float[nConfigs]; // stores the maximum raw calibration value (1023 is maximum)
String kbInput = ""; // stores the string of text characters that the user has entered
float kbVal = 0; // stores the numerical value of the user-inputted number held in kbInput
String topBot = ""; // stores the contextual wording for the calibration text e.g., minimum or maximum

void drawCalScreen() { // a routine to take the user through a calibration process
/* the flow and principles of this calibraion process are:
   to allow selection of the pressure channel, wither low or high range
   to allow selection of the correct pressure units
   to associate a true low pressure reading with a low raw digital value from the sensor / Arduino
   to associate a true high pressure reading with a high raw digital value from the sensor / Arduino
   scales are suggested slightly wider than the readings to allow for some out-of-range measurement
   the scales can be set to whatever the user wants without affecting accuracy (signal may clip or not reach limits)
   calibration can be done at ANY low and high pressure as it just determines a relationship and linear slope
   best practice shall be to calibrate at as low and high pressure as possible, for best accuracy
   accuracy is also determined by the accuracy of the pressure meter used & the skill of the operator */

  if (enter) { // if the enter key has been pressed...
    if (bActive[5] && calStage ==4) {
      calStage = 7; // if only setting the scales and lower been set, jump to setting upper scale
      suggested = false; // reset the suggested flag (in ful lcalibration this is set elsewhere)
    }
    else calStage ++;  // otherwise increment the current calibration stage by 1
    enter = false; // set enter to false as last enter press now dealt with
  }

  clearPlotArea(); // clears the plot area ready for the new text etc
  
  if (calStage == 0) setRange();
  else
  if (calStage == 1) setUnits();
  else
  if (calStage == 2 || calStage == 5) requestPressure(); // instruct user to apply the minimum / maximum pressure
  else
  if (calStage == 3 || calStage == 6) getPressure(); // instruct the user to enter a value for the minimum pressure
  else
  if (calStage == 4 || calStage == 7) setScaleLimits(); // suggest a value for the bottom of the scale
  else
  if (calStage == 8) askSaveData(); // offer to save in 1 of 4 profiles or use calibration without saving
  else
  if (calStage == 10) askLoadData(); // offer to load 1 of 4 profiles or cancel without loading 
  else
  if (calStage>8) exitCalibration(); // if all calibration steps now complete then exit calibration
  // (if calStage 9 after saving or 11 after laoding)
}

void setRange() {
  buttons(); // draw the calibration buttons
  textSize(30); // sets the font size for the calibration screen text
  fill(0, 0, blueShade); // sets the text colour
  text("Please select either the Low or High" + '\n' + "pressure channel", lMargin+30, tMargin+40); // instructional text to the user
}

void setUnits() {
  // this calibraiton step requires the user to select the pressure units
  buttons(); // draw the calibration buttons
  textSize(30); // sets the font size for the calibration screen text
  fill(0, 0, blueShade); // sets the text colour
  text("Please click on the required units below", lMargin+30, tMargin+40); // instructional text to the user
}

void requestPressure(){
  // this calibration setup instructs the user to apply low or high pressure depending when it is called
  
  // set the contextual text based on this being upper or lower scale calibration
  textSize(30); // sets the font size for the calibration screen text
  high = calStage == 5; // high is true if at calibtaion stage 5, if stage 2 then high is false (low calibration)
  // set the instructional text based on whether the user is being asked to apply low or high pressure
  if (high) topBot = "Apply the maximum possible pressure that";
  else topBot = "Apply the minimum possible pressure" + '\n' + "(either zero or most negative) that the";
      
  // set the font colour & print the text
  fill(0, 0, blueShade);
  text(topBot, lMargin+30, tMargin+40);
  // set the instructional text based on whether the user is being asked to apply low or high pressure
  if (high) text("the transducer can read." + '\n' + "Press [Enter] to take a reading,", lMargin+30, tMargin+77);
  else  text("transducer can read." + '\n' + "Press [Enter] to take a reading,", lMargin+30, tMargin+134);
  kbInput = ""; // set the user input text string to blank
}

void getPressure(){
  // this calibration step reads the user keyboard input to define the pressure in the selected units
  high = calStage == 6; // high is true if at calibtaion stage 6, if stage 3 then high is false (low calibration)
  if (high) maxRaw[nConfigs-1] = dataInt[ADC[nConfigs-1]]; // sets maxRaw to value of the raw data input e.g., 0..1023 when calibrating upper scale
  else minRaw[nConfigs-1] = dataInt[ADC[nConfigs-1]]; // sets minRaw to value of the raw data input e.g., 0..1023 when calibrating lower scale
  
  // set the font colour & print the instructional calibration text
  textSize(30); // sets the font size for the calibration screen text
  fill(0, 0, blueShade);
  text("Enter the value of the applied pressure" + '\n' + "in " + units[nConfigs-1] + ": ", lMargin+30, tMargin+40);
  if (kbInput.length()>0) { // if therer is text to display..
    text(kbInput + '_', lMargin+200, tMargin+87); // display the user-entered value
    kbVal = float(kbInput); // convert the text of the value to a number
  } else text('_', lMargin+200, tMargin+87); // display the text-entry cursor
  suggested = false; // ensures that the suggested flag is false after the user progresses the calibration stage
}

void setScaleLimits() {
  // allows the user to accept suggested scale values or set them to their own preference
  high = calStage == 7; // high is true if at calibtaion stage 7, if stage 4 then high is false (low calibration)
  
  if (!suggested) { // if a number has not yet been suggested then suggest one
    if (bActive[5]) { // if only setting a new scale and not in full calibration mode...
      if (high) kbVal = uScale[aC]; // set the suggested upper scale value to the current
      else kbVal = lScale[aC]; // set the suggested lower scale value to the current
      
      // populate temporary config with current pressure values in case the data is saved after defining the scales
      minRaw[nConfigs-1] = minRaw[aC];
      maxRaw[nConfigs-1] = maxRaw[aC];
      trueLo[nConfigs-1] = trueLo[aC];
      trueHi[nConfigs-1] = trueHi[aC];
      units[nConfigs-1] = units[aC];
      ADC[nConfigs-1] = ADC[aC];
    }
    else if (bActive[3]) { // if in full calibration mode...
      if (high) trueHi[nConfigs-1] = kbVal; // assign the current value to the temporary (set 5) true upper calibration pressure
      else trueLo[nConfigs-1] = kbVal; // assign the current value to the temporary (set 5) true lower calibration pressure
      kbVal = suggestValue(kbVal); // suggest a wider scale limit based on the magnitude of the value entered
    }
    kbInput = str(kbVal); // assigns the current value to the keyboard entry string
    suggested = true; // flags that the program has now suggested a value for the particular scale
  }
    
  // set the font colour & print the text
  textSize(30); // sets the font size for the calibration screen text (in full cal mode this is set earlier)
  fill(0, 0, blueShade);
  if (high) topBot = "Suggested value for the upper scale limit";
  else topBot = "Suggested value for the lower scale limit"; 
    
  text(topBot + '\n' + "(use backspace to edit if desired)", lMargin+30, tMargin+40);
   
  if (kbInput.length()>0) { // if there is text to display..
    text(kbInput + '_', lMargin+200, tMargin+150); // display the suggested or edited value
  }
  kbVal = float(kbInput); // convert the text of the value to a number
  if (high) uScale[nConfigs-1] = kbVal; // assign the current value to the upper scale limit
  else lScale[nConfigs-1] = kbVal; // assign the current value to the lower scale limit
}

void askSaveData() {
  // prompts the user to save the new calibration data in 1 of 4 profiles, or to use it without saving
  buttons(); // draw the calibration buttons
  listCalData(); // prints the text desriptions of the currently saved configs over the buttons 
  textSize(30); // sets the font size for the calibration screen text
  fill(0, 0, blueShade);
  text("Please select a profile to save the data to", lMargin+50, tMargin+40);
  text("or click don't save to use the calibration", lMargin+50, tMargin+77);
  text("without saving the data", lMargin+50, tMargin+134);
}

void askLoadData() {
  // allows the user to load a previous profile (calibration & scale) or cancel the operation
  bText[nButtons+cButtons+4] = "Cancel"; // temprarily changes the "Don't Save" button text
  buttons(); // draw the relevent buttons
  bText[nButtons+cButtons+4] = "Don't Save";  // restores the button text
  listCalData(); // prints the text desriptions of the currently saved configs over the buttons 
  textSize(30); // sets the font size for the calibration screen text
  fill(0, 0, blueShade);
  text("Please select a profile to load the calibration", lMargin+50, tMargin+40);
  text("and scale data from, or click cancel to continue", lMargin+50, tMargin+77);
  text("using the curretnt data. Note that the scale can", lMargin+50, tMargin+114);
  text("be adjusted after the calibration data is loaded", lMargin+50, tMargin+151);
}

void exitCalibration() {
  // this sets all calibration buttons to inactive, sets the stage to -1, and resets the plot position to the left side
  // it also resets all the timing variables & sets new default timing windows based on the updated calibration data
    
  calStage = -1; // clears the current calibration stage
  bActive[3] = false; // resets the calibration button's status to inactive
  bActive[5] = false; // resets the adjust scale button's status to inactive
  bActive[8] = false; // resets the load profile button's status to inactive
  xPos = speed; // resets the x position of the trace to zero + speed to start drawing a new trace (was 0)
  oldX = 0; // resets the previous x vale to zero too so no spurious line is drawn
  oX = 0; // sets the intermediate frame old-x position to 0 too
  oldY = yPos; // sets the previous y position to the current so no spurious line is drawn 
  suggested = false; // otherwise it can remain set if calibration or scale adjustment is performed twice

  for (byte i=0; i<nWin; i++) resetTiming(i); // reset the timing variables for window "i"
      
  drawScales(); // re-draw the scales
  drawGridLines(lMargin, rMargin-1); // refresh gridlines
  defineWindows(); // sets the timing windows to defaults based on new scale values
  drawDataCaptions(); // redraw the timing window captions 
  drawMovableWindows(); // redraw the movable timing windows
  updateTimingData(); // redraw the timings
  
  for (int i=nButtons; i<nButtons+cButtons; i++) bActive[i] = false; // set all the calibration buttons to inactive
  // (data buttons are always flagged as active so their titles are drawn in a larger font)
}

float suggestValue(float val) { // a function which returns a suggested appopriate scale value
// the basis of this code is that the scale should be widened. Therefore:
// if the low calibration number is positive, reduce the magnitude of the number e.g., from +17.1 down to +16
// if the high calibration number is negative, reduce the magnitude of the number e.g., from -11 down to -10
// if the low calibration number is negative, increase the magnitude of the number e.g., from -53 up to -55
// if the high calibration number is positive, increase the magnitude of the number e.g., from +37 to +38
// the addition or subtraction of 0.0001 is to make exact numbers expand e.g., 70.0 expands to 75.0

  boolean negative=false; // start from the assumption that the number is positive
  if (val<0.0) { // if the value is a negative number...
    negative=true; // set the flag to say the original number was negative
    val=val*-1; // negate the number to make it positive for rounding operations (will be negated back later)
  }
  if (val>0.0 && val<=10.0) { // if the value is a single digit (0.x to 9.x), round up to the nearest whole number 
    if ((negative && !high) || (!negative && high)) val = ceil(val+0.0001); // round up the number (increase magnitude)
    else val = floor(val-0.0001); // round down the number (decrease magnitude) to widen the range
  } else if (val>10.0 && val <=50.0) { // if the value is 10-50 then round up to nearest even number above
      if ((negative && !high) || (!negative && high)) {
        val = ceil(val+0.0001);  // round up the number
        if (val % 2 !=0) val++; // if the remainder of value/2 is not zero, val is odd so add 1 to make it even
      } else {
        val = ceil(val+0.0001); // round down the number
        if (val % 2 !=0) val--; // if the remainder of value/2 is not zero, val is odd so subtract 1 to make it even
      }
  } else if (val>50.0 && val <=100.0) { // if the value is 50-100 then round up to nearest 5 or 10 number above e.g., 55, 60, 65
      if ((negative && !high) || (!negative && high)) val = ceil((val+0.0001)/5)*5; // rounds the number up to the nearest 5 above
      else val = floor((val-0.0001)/5)*5; // rounds the number down to the nearest 5 below
  } else if (val>100.0) { // if the value is >100 then round up to nearest 10 number above e.g., 110, 120, 130
      if ((negative && !high) || (!negative && high)) val = ceil((val+0.0001)/10)*10; // rounds the number up to the nearest 10 above
      else val = floor((val-0.0001)/10)*10; // rounds the number down to the nearest 10 below
  }
  if (negative) val=val*-1; // if the number was negative then negate it back
  return val;
}

void keyReleased() { // this runs whenever a key is pressed & then released (saves multiple strokes from holding a key down)
  int newKey = key; // read the key stroke Unicode into the variable newKey
  
  // if the enter key (ascii code 10) is pressed and in calibration mode set enter flag
  if (newKey == 10 && (bActive[3] || bActive[5]) && calStage > 0 && calStage < 8) {
    enter=true;
  }
  else if (calStage > 1 && calStage < 8) { // if at a calibration stage requiring user input...
    // read the input and add it to the input string so long as it is a number or a decimal point
    if (newKey >47 && newKey <58) {
      kbInput += newKey-48; // adds the numeric value of the ascii character to the string (0=48, 1=49 etc.)
    } else if (newKey == 46) { // else if the key pressed was a decimal point...
      kbInput += '.'; // add the decimal point to the string (so no need to subtract 48);
    } else if (newKey == 45 && kbInput.length() ==0) { // else if the character is a minus sign, and the first character...
      kbInput = "-"; // set the string to be just a minus sign
    } else if (newKey == 8 && kbInput.length()>0) { // else if the key pressed was backspace & there is at least one chracter...
      kbInput = kbInput.substring(0, kbInput.length()-1); // removes the last character from the string
    }
    if (kbInput.length() >6) kbInput = kbInput.substring(0, 6); // trims the inputted number to 6 characters total
  }
}
