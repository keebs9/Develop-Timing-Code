// declare variables used for the selectable windows
float[] upper = new float[3]; // stores the upper limit of the 3 timing windows (in pressure units)
float[] lower = new float[3]; // stores the lower limit of the 3 timing windows (in pressure units)
boolean[] upperDrag = new boolean[3]; // stores the upper line still selected and being dragged
boolean[] lowerDrag = new boolean[3]; // stores the lower line still selected and being dragged
float[] winTopY = new float[3]; // stores the upper Y position of the text box (in pixels)
float[] winBotY = new float[3]; // stores the lower Y position of the text box (in pixels)
byte nWin = 3; // stores the number of currently active windows, used in "for loops" processing window actions, default is 3

float timeStamp; // stores the formatted cycle timing which is to be printed to the output file

// variables which hold the RGB values for the adjustable windows
int[] valR = new int[3]; // stores the timing window colour - R (red) component
int[] valG = new int[3]; // stores the timing window colour - G (green) component
int[] valB = new int[3]; // stores the timing window colour - B (blue) component
int[] darkR = new int[3]; // stores the darker line colour - R (red) component
int[] darkG = new int[3]; // stores the darker line colour - G (green) component
int[] darkB = new int[3]; // stores the darker line colour - B (blue) component

// variables for the actual timing of the pressure windows
int[] msTime = new int[3]; // stores the time in ms for the 3 timing windows
int[] start = new int[3]; // stores the window start time for the 3 timing windows
int[] average = new int[3]; // stores the average cycle time for the 3 timing windows
int[] count = new int[3]; // stores the number of timing cycles measured for each of the 3 timing windows
float[] totTime = new float[3]; // stores the accumulated total time spent within the monitored window, for each of 3 windows 
boolean[] winActive = new boolean[3]; // stores the current status of the 3 timing windows (active if timing already begun)
boolean[] ignoring = new boolean[3]; // stores the current status of the 3 timing windows
int transTime = 100; // defines the duration in ms of transient timings which are to be ignored
boolean ignore = true; // true if transients are being ignored (tidier than using the button's active variable)
boolean updateStartNextButton = false; // the button can't be drawn within timing as is outside the draw loop - this flags it to be done

void timing() { // acquire & set time stamps when the current pressure is within a monitored window (range)
  for (byte i =0; i<nWin; i++) { // repeat for the number of active pressure windows
    if ((pressure > lower[i]) && (pressure <= upper[i])) { // if the pressure is within the current timing window...
      if (winActive[i] == false) { // if timing was not already active...
        start[i] = millis(); // set the start time of this pressure window to the current time
        
        if (startNext) { // if was waiting for start of next cycle
          startNext = false; // reset tue startNext logic as can only be used once, must be reactivated by the user
          bActive[6] = false; // sets the button to deactivated so it can be reset by the user
          updateStartNextButton = true; // flags that the button must be redrawn
        }
                
      } else if (!startNext) { // if it was already being timed and isn't waiting for a new pressure cycle...
        
        // if not ignoring transients OR ignoring them but the time exceeds the ignore period...
        if ((!ignore) || (ignore && (millis() - start[i] > transTime))) {
          msTime[i] = millis() - start[i]; // set the duration of this pressure window to the current time - the start time
        }
      }
      winActive[i] = true; // set this pressure window to being active
    
      // if ignoring transients AND the duration is lower than the ignore period...
      if (ignore && (millis() - start[i] < transTime)) {
        ignoring[i] = true; // tell the timing-data drawing routine that this timing is being ignored and shouldn't be highlighted
      } else ignoring[i] = false; // tell the timing-data drawing routine that this timing is to be highlighted
    } else { // if the current pressure is outside the timing window
      if (winActive[i]) { // if the window was being timed then...
        winActive[i] = false; // set the status to inactive
        count[i] ++; // increase the number of cycles which have been counted for this window
        totTime[i] += msTime[i]; // increments the total time for this window by the current time (only when pressure exits the window)
        average[i] = round(totTime[i] / count[i]); // updates the average time by dividing total time by cycle count
        
        if (!ignoring[i] && bActive[7]) { // if not ignoring this timing e.g., due to it being transient, and it's being recorded...
          // writes the phase number (1,2,3) and the measured phase time (to the nearest 100th of a second) to a new line in the file
          timeStamp = round(msTime[i]/10.0);
          timeStamp = timeStamp / 100; // if done in one line then it truncates to the nearest second for some reason
          outputData.println(i+1 + "," + timeStamp);
        }
      }
    }
  }
}

void resetTiming(byte winNum){ // serst the timing window variables when they are no longer valid e.g., after calibration
  msTime[winNum] = 0; // reset the current time
  start[winNum] = 0; // reset the last cycle time
  average[winNum] = 0; // reset the average cycle time
  count[winNum] = 0; // reset the current cycle count
  totTime[winNum] = 0; // reset the total of cycle times
  winActive[winNum] = false; // reset the active flag of the current window
}
