int[] upper = new int[3]; // stores the upper limit of the 3 timing windows //<>//
int[] lower = new int[3]; // stores the lower limit of the 3 timing windows
int[] time = new int[3]; // stores the time in ms for the 3 timing windows
int[] start = new int[3]; // stores the window start time for the 3 timing windows
boolean[] active = new boolean[3]; // stores the current status of the timing window
boolean[] ignoring = new boolean[3]; // stores the current status of the timing window

void timing() {
  for (byte i =0; i<3; i++) { // repeat for the number of pressure windows (change to variable)
    if ((pressure >= lower[i]) && (pressure <= upper[i])) { // if the pressure is within the current timing window...
      if (active[i] == false) { // if timing was not already active...
        start[i] = millis(); // set the start time of this pressure window to the current time
      } else { // if it was already being timed...
        
        // if not ignoring transients OR ignoring them but the time exceeds the ignore period...
        if ((!ignore) || (ignore && (millis() - start[i] > transTime))) {
          time[i] = millis() - start[i]; // set the duration of this pressure window to the current time - the start time
        }
      }
      active[i] = true; // set this pressure window to being active
      
      // if ignoring transients AND the duration is lower than the ignore period...
      if (ignore && (millis() - start[i] < transTime)) {
        ignoring[i] = true; // tell the button drawing routine that this timing is being ignored and shouldn't be highlighted
      } else ignoring[i] = false; // tell the button drawing routine that this timing is to be highlighted
    } else { // if the current pressure is outside the timing window
      if (active[i]) active[i] = false; // if it was active set it to inactive
    }
  }
}
