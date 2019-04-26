// The purpose of this program is to time 2 or 3 pressure phases, as defined by the user. To enable this
// a transucer calibration process is requried (including daving data), and a user interface to allow customisation.

import processing.serial.Serial; // imports the additional functionality of the serial command set
Serial myport; // create a serial object

// declare variables which are used throughout the program. Note that variables are declared in the tabs from left to right

int pW = 850; // this sets the plot width, it has to be set here as it sets up variables in other tabs
int[] dataInt = new int[2]; // stores the 2 integer values of the acquired data channels
float pressure = 0; // stores the pressure input in pressure units
float truePressure = 0; // stores the true pressure value in case it is out of range
byte nConfigs = 5; // defines the number of active configs, note that the last profile [5] holds the new config during calibration
int msStart; // stores the start time of the program in ms
int startDelay = 1800; // defines the initial delay before starting measurement (avoids blip as Arduino resets) (was 1700)
byte fps = 60; // defines the number of frames per second the program should run at (note Arduino sampling rate is 100Hz)
byte subFrames = 20; // defines the number of small plot steps to take in each real frame (must be at least 2)
// subFrames improves plot appearance in response to rapid changes of vertical position (magnitude)
float speed = (pW/(15.0*fps)); // defines the scroll speed of the plot (also influenced by frame rate), default is for 15s timespan
float cX =0; // stores an intermediate x-position as the frame is built-up
float cY; // stores an intermediate pressure value as the frame is built-up
float oX; // stores an intermediate previous x-position as the frame is built-up
float oY; // stores an intermediate previous pressure value as the frame is built-up
float incY; // stores the sub-frame increment of the Y-value
float incX; // stores the sub-frame increment of the X-value
int msNow; // stores the current time since program start in milliseconds
boolean firstLine = true; // true by default, changed to false after very first plot line drawn (see below) 

void setup() {
  // this section of code runs once at start-up, it configures the serial port and screen for use 
  msStart = millis();
  String[] portsList = Serial.list();
  String arduinoPort = portsList[portsList.length-1]; // sets the COM port to highest active
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent, 115200 is the data connection speed (BAUD)
  myport.bufferUntil('\n'); // sets the function to always read until the end of the line

  frameRate(fps); // sets the framerate in frames per second
  noSmooth(); // Processing uses smoothing by default - this causes display issues in this program
  size(1366, 736); // sets the size of the graphics window AS SIZE won't accept variables! (736 to allow for program title bar)

  loadCalData(); // load the 4 calibration profiles
  defineButtons(); // initialises the button variables
  screenSetup(); // initialises the display e.g., size, background etc.
}

void draw() {
  // The "draw" code must contain all graphics output, even if these are within other functions and routines. At the end
  // of the draw code, the graphics are refreshed on the display. This occurs at the the framerate defined in Setup
  msNow = millis();
  
  if (mousePressed) whatSelected(); // if the left mouse button is being pressed
  else {
    for (byte i=0; i<(totalButtons); i++) { // repeat for the number of buttons
      bPress[i] = false; // the button isn't being pressed
      bHeld[i] = false; // the button isn't being held
      butPress = false; // no buttons can be being pressed
      lineDrag = false; // no lines can be being dragged
    }
    for (byte i=0; i<3; i++) { // repeat for all 3 pressure windows
      upperDrag[i] = false; // marks the upper line as not being held
      lowerDrag[i] = false; // marks the lower line as not being held
    }
  }

  if (bActive[3] || bActive[5] || bActive[8]) { // if in calibration mode...
    drawCalScreen(); // draw the calibration screen (also used for altering the scales)
  }
  else if (bActive[4]) {
    //selectTimebase(); // if the timebase button has been selected then presnt timebase options to the user
  }
  else if (msNow > msStart + startDelay){ // if not in any special mode & not in start-up delay, draw usual screen
    advanceTrace();  // progress the X position of the trace
    displayPressure(); // updates the live pressure display below the scale
    drawScales(); // refresh the left & right scales as the plot line thickness means it can encroach over them
  }
  
  if (updateStartNextButton) { // if the timing routine has flagged the need for the start-next-phase button to be re-drawn...
    updateStartNextButton = false; // reset the flag
    drawButtons(6,6); // draw just the start-next-phase button
  }
} 
  

void serialEvent(Serial myport) {
  // the function which reads the actual data from the Arduino through the USB port
  String dataStr; // a string to store the data read from the COM port

  dataStr = myport.readStringUntil( '\n' ); // read the whole line
  
  if (dataStr != null) { // if there is some data (and so isn't null)
    dataStr = trim(dataStr); // trim function removes any extra spaces
    dataInt = int(split(dataStr, '\t'));
    
    // maps the pressure vaule from the active ADC channel to the scale using the calibration data
    pressure = map(dataInt[ADC[aC]], minRaw[aC], maxRaw[aC], trueLo[aC], trueHi[aC]);
    truePressure = pressure; // copies the presure value to the true pressure variable, before pressure is constrained to scale
    clipped = (pressure > uScale[aC] || pressure < lScale[aC]); // clipped flag if pressure outside current visible scale
    
    pressure = constrain(pressure, lScale[aC], uScale[aC]); // constrain pressure to scale limits of the plot
    oldY = yPos; // updates previous Y position
    yPos = round(map(pressure, lScale[aC], uScale[aC], 0, plotHeight-2)); // scales the Y position to the veritcal plot size in pixels
    timing(); // runs the timing function which checks if the current pressure is within a monitored pressure window
  }
}

void advanceTrace() {
  updateTimingData(); // this must be called from within draw NOT serial event (as it has graphics functions)
  blankAhead(); // reinstates the plot area and the gridlines in front of the trace

  if (firstLine) {
    oY = yPos; // prevents first line being drawn from 0 up to current position when no data for oY (old Y position)
    firstLine = false; // sets to false as from now on there is data for oY (old Y position)
  }
  incY = (yPos - oY) / subFrames; // sets an increment value for the y-position
  incX = speed / subFrames; // sets an increment value for the x-position
  cX = oX + incX; // increment the current X position
  cY = oY + incY; // increment the current Y positoin

  for (byte i=0; i<(subFrames); i++) { // repeat for the number of subframes
    oY = constrain(oY, 0, plotHeight-2); // constrain the old Y position to within the plot scales (was -2)
    cY = constrain(cY, 0, plotHeight-2); // constrain the current Y position to within the plot scales (was -2)
    drawPlot(); // draw the next portion of the plot in the appropriate colour 
    oX = cX; // update the old X position to equal the current
    oY = cY; // update the old Y position to equal the current
    cX += incX; // increment current X position, advancing the plot across the screen
    cY += incY; // increase the current Y position value
  }
  xPos += speed; // updates the true X position
  if (xPos >=plotWidth-2) { // if the x position is at the right edge of the plot window
    oldX = 0; // reset the per-frame X position to the left of the plot window
    oX = 0; // set the previous inter-frame X position to 0 too so a line isn't drawn across the screen
    xPos = speed; // sets the current per-frame X position to 1 frame in front of the old (was 1)
    // note that xPos is always related to the plot window not the program frame
  }
  oldX = xPos; // updates previous X position
}
