int[] upper = new int[3]; // stores the upper limit of the 3 timing windows
int[] lower = new int[3]; // stores the lower limit of the 3 timing windows
int[] time = new int[3]; // stores the time in ms for the 3 timing windows
int[] start = new int[3]; // stores the window start time for the 3 timing windows
boolean[] active = new boolean[3]; // stores the current status of the timing window

void timing() {
  if (mousePressed) {
      stroke(255, 0, 0); // just a debugging line //<>//
    }
  for (byte i =0; i<3; i++) {
    if ((pressure >= lower[i]) && (pressure <= upper[i])) {
      if (active[i] == false) {
        start[i] = millis();
      } else {
        time[i] = millis()-start[i];
      }
      active[i] = true;
    } else {
      if (active[i]) {
        active[i] = false;
      }
    }
    //println(active[0] + " , last duration: " + time[0] + " current pressure: " + pressure + " ypos: " + yPos);
  }
  println(pressure, active[0], active[1], active [2]);
}
