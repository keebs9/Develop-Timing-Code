// variables for the selectable windows
float[] upper = new float[3]; // stores the upper limit of the 3 timing windows
float[] lower = new float[3]; // stores the lower limit of the 3 timing windows
boolean[] upperDrag = new boolean[3]; // is the upper line still selected and being dragged
boolean[] lowerDrag = new boolean[3]; // is the lower line still selected and being dragged
byte nWin = 2; // the number of currently active windows, used in for loops processing window actions

int[] valR = new int[3]; // stores the timing window colour - R (red) component
int[] valG = new int[3]; // stores the timing window colour - G (green) component
int[] valB = new int[3]; // stores the timing window colour - B (blue) component
int[] darkR = new int[3]; // stores the darker line colour - R (red) component
int[] darkG = new int[3]; // stores the darker line colour - G (green) component
int[] darkB = new int[3]; // stores the darker line colour - B (blue) component

// variables for the actual timing of the pressure windows
int[] time = new int[3]; // stores the time in ms for the 3 timing windows
int[] start = new int[3]; // stores the window start time for the 3 timing windows
boolean[] winActive = new boolean[3]; // stores the current status of the 3 timing windows
boolean[] ignoring = new boolean[3]; // stores the current status of the 3 timing windows

void timing() {
  for (byte i =0; i<nWin; i++) { // repeat for the number of active pressure windows
    if ((pressure >= lower[i]) && (pressure <= upper[i])) { // if the pressure is within the current timing window...
      if (winActive[i] == false) { // if timing was not already active...
        start[i] = millis(); // set the start time of this pressure window to the current time
      } else { // if it was already being timed...
        
        // if not ignoring transients OR ignoring them but the time exceeds the ignore period...
        if ((!ignore) || (ignore && (millis() - start[i] > transTime))) {
          time[i] = millis() - start[i]; // set the duration of this pressure window to the current time - the start time
        }
      }
      winActive[i] = true; // set this pressure window to being active
      
      // if ignoring transients AND the duration is lower than the ignore period...
      if (ignore && (millis() - start[i] < transTime)) {
        ignoring[i] = true; // tell the button drawing routine that this timing is being ignored and shouldn't be highlighted
      } else ignoring[i] = false; // tell the button drawing routine that this timing is to be highlighted
    } else { // if the current pressure is outside the timing window
      if (winActive[i]) winActive[i] = false; // if it was active set it to inactive
    }
  }
}
