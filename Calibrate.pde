boolean enter = false; // shows if the enter key has been pressed
boolean suggested = false; // shows if a number has already been suggested
boolean high = true; // states whether the current calibration is high (true) or low (false)
int blueShade = 140; // sets the shade of blue used to display the calibration instructional text 
int calStage = 0; // used to track what stage of calibration the user is at
float minRaw = 0; // used to store the minimum raw calibration value (0 by default)
float maxRaw = 1023; // used to store the maximum raw calibration value (1023 by default)
String kbInput = ""; // stores the string of text characters that the user has entered
float kbVal = 0; // holds the numerical value of the user-inputted number
String topBot = ""; // holds the contextual wording for the calibration text e.g., minimum or maximum

void drawCalScreen() { // a routine to take the user through a calibration process
// the principle of this calibraion process is:
// to associate a true low pressure reading with a low raw digital value from the sensor
// to associate a true high pressure reading with a high raw digital value from the sensor
// scales are suggested slightly wider than the readings to allow for some out-of-range measurement
// the scales can be set to whatever the user wants without affecting accuracy (signal may clip or not reach limits)
// calibration can be done at ANY low and high pressure as it just determines a relationship and linear slope
// best practice shall be to calibrate at as low and high pressure as possible, for best accuracy
// accuracy is also determined by the accuracy of the pressure meter used & the skill of the operator

  if (enter) {
    calStage ++; // if the enter key has been pressed then increment the current calibration stage
    enter = false; // set enter to false as last enter press now dealt with
  }

   clearPlotArea(); // clears the plot area ready for the new text etc (in case you've used backspace & deleted characters).

  if (calStage>6) { // if all calibration steps now complete then exit calibration
    calStage = 0; // clears the current calibration stage
    bActive[3] = false; // this is used as a flag for the program being in calibration mode & is set to false
    xPos = 0; // resets the x position of the trace to zero to start drawing a new trace
    oldX = 0; // resets the previous x vale to zero too so no spurious line is drawn
    oldY = yPos; // sets the previous y position to the current so no spurious line is drawn 

    for (byte i=0; i<nWin; i++) {// for each active timing windows...
      resetTiming(i); // reset the 4 timing variables for window "i"
    }
    
    drawScales(); // re-draw the scales
    defineWindows(); // sets the timing windows to defaults based on new scale values
    drawDataCaptions(); // redraw the timing window captions 
    drawMovableWindows(); // redraw the movable timing windows
    updateTimingData(); // redraw the timings
    stroke(10); // sets the colour of the centre line
    line(lMargin-1, centre+tMargin, rMargin, centre+tMargin); // reinstate horizontal line half way up
  }

  if (calStage == 1 || calStage == 4) { // instruct user to apply the minimum / maximum pressure
    // set the contextual text based on this being upper or lower scale calibration
    high = calStage == 4; // high is true if at calibtaion stage 4, if stage 1 then high is false (low calibration)
    if (!high) topBot = "Apply the minimum possible pressure" + '\n' + "(either zero or most negative) that the";
    else topBot = "Apply the maximum possible pressure that";
    textSize(30); // sets a font size for the calibration screen text
    
    // set the font colour & print the text
    fill(0, 0, blueShade);
    text(topBot, lMargin+30, tMargin+40);
    if (calStage == 1) text("transducer can read." + '\n' + "Press [Enter] to take a reading,", lMargin+30, tMargin+134);
    else text("the transducer can read." + '\n' + "Press [Enter] to take a reading,", lMargin+30, tMargin+77);
    kbInput = "";
  } else
  if (calStage == 2 || calStage == 5) { // instruct the user to enter a value for the minimum pressure
    high = calStage == 5; // high is true if at calibtaion stage 5, if stage 2 then high is false (low calibration)
    if (!high) minRaw = dataInt; // sets minRaw to value of the raw data input e.g., 0..1023 when calibrating lower scale
    else maxRaw = dataInt; // sets maxRaw to value of the raw data input e.g., 0..1023 when calibrating upper scale
    // set the font colour & print the text
    fill(0, 0, blueShade);
    text("Enter the value of the applied pressure" + '\n' + "in cmH2O: ", lMargin+30, tMargin+40);
    if (kbInput.length()>0) { // if therer is text to display..
      text(kbInput + '_', lMargin+200, tMargin+87); // display the user-entered value
      kbVal = float(kbInput); // convert the text of the value to a number
    } else text('_', lMargin+200, tMargin+87); // display the text-entry cursor
    suggested = false; // ensures that the suggested flag is false after the user progresses the calibration stage
  } else
  if (calStage == 3 || calStage == 6) { // suggest a value for the bottom of the scale
    high = calStage == 6; // high is true if at calibtaion stage 6, if stage 3 then high is false (low calibration)
    if (!suggested) { // if a number has not yet been suggested then suggest one
      if (!high) trueLo = kbVal; // assign the current value to the true lower calibration pressure
      else trueHi = kbVal; // assign the current value to the true upper calibration pressure
      kbVal = suggestValue(kbVal); // suggest a wider scale limit based on the magnitude of the value entered
      kbInput = str(kbVal); // assigns the current value to the keyboard entry string
      suggested=true;
    }
      
    // set the font colour & print the text
    fill(0, 0, blueShade);
    if (!high) topBot = "Suggested value for the lower scale limit";
    else topBot = "Suggested value for the upper scale limit"; 
    
    text(topBot + '\n' + "(use backspace to edit if desired)", lMargin+30, tMargin+40);
    
    if (kbInput.length()>0) { // if therer is text to display..
      text(kbInput + '_', lMargin+200, tMargin+150); // display the suggested or edited value
    }
    kbVal = float(kbInput); // convert the text of the value to a number
    if (!high) lScale = kbVal; // assign the current value to the lower scale limit
    else uScale = kbVal; // assign the current value to the upper scale limit
  }
}

float suggestValue(float val) { // suggests an appopriate scale value
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
  if (newKey == 10 && bActive[3]) enter=true;
  else if (calStage > 1 && calStage < 7) { // if at a calibration stage requiring user input...
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
