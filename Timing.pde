int[] upper = new int[3]; // stores the upper limit of the 3 timing windows
int[] lower = new int[3]; // stores the lower limit of the 3 timing windows
int[] time = new int[3]; // stores the time in ms for the 3 timing windows
int[] start = new int[3]; // stores the window start time for the 3 timing windows
boolean[] active = new boolean[3]; // stores the current status of the timing window

void timing() {
  if ((pressure >= lower[0]) && (pressure <= upper[0])) {
    if (active[0] == false) {
      start[0] = millis();
    } else {
      time[0] = millis()-start[0];
    }
    active[0] = true;
  } else {
    if (active[0]) {
      active[0] = false;
      time[0] = millis()-start[0];
    }
  }
  println(active[0] + " , last duration: " + time[0] + " current pressure: " + pressure + " ypos: " + yPos);
}
