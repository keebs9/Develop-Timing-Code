// The purpose of this program is to develop a method of timing pressure cycles,
// initially within parameters set as constants by me in the program.
// Today's aims are to add full-width scale lines so it is easier to see where the magnitude
// of the trace at all times. Other development's required are to add save & load functionality, 
// add a pressure check screen post-calibration, and allow unit selection pre-calibration

import processing.serial.Serial; // imports the additional functionality of the serial command set
Serial myport; // create a serial object

// declare variables which are used throughout the program. Note that variables are declared in the tabs from left to right
int dataInt; // an integer to store the integer value of the acquired data
float pressure = 0; // converts the digital input to a pressure based on the scale
byte nConfigs = 2; // holds the number of active configs, note that the last profile [5] holds the new config during calibration
int msStart; // records the start time of the program
int startDelay = 1700; // defines the initial delay before starting measurement (avoids blip as Arduino resets)
byte fps = 100; // defines the number of frames per second the program should run at
byte subFrames = 40; // sets the number of small plot steps to take in each real frame (must be at least 2);
float speed = 0.5; // sets the scroll speed of the plol (also influenced by frame rate)
float cX; // stores an intermediate x-position as the frame is built-up
float cY; // stores an intermediate pressure value as the frame is built-up
float oX; // stores an intermediate previous x-position as the frame is built-up
float oY; // stores an intermediate previous pressure value as the frame is built-up
float incY; // sets the sub-frame increment of the Y-value
float incX; // sets the sub-frame increment of the X-value

void setup() {
  // this section of code runs once at start-up, it configures the serial port and screen for use 
  msStart = millis();
  String[] portsList = Serial.list();
  String arduinoPort = portsList[portsList.length-1]; // sets the COM port to highest active
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent
  myport.bufferUntil('\n'); // sets the function to always read until the end of the line

  frameRate(fps); // sets the framerate in frames per second
  noSmooth(); // Processing uses smoothing by default - this causes display issues in this program
  size(1366, 768); // sets the size of the graphics window AS SIZE won't accept variables!
  
  loadCalData(); // load the 4 calibration profiles
  defineButtons(); // initialises the button variables
  screenSetup(); // initialises the display e.g., size, background etc.
}

void draw() 
// The "draw" code must contain all graphics output, even if these are within other functions and routines. At the end
// of the draw code, the graphics are refreshed on the display. This occurs at the the framerate defined in Setup
{
  if (mousePressed) whatSelected(); // if the left mouse button is being pressed
  else {
    for (byte i=0; i<(tButtons); i++)  { // repeat for the number of buttons
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
    
  if (bActive[3]) { // if in calibration mode...
      drawCalScreen(); // draw the calibration screen
  } else if (millis() > msStart + startDelay) {  // if not in calibration mode & not in start-up delay, draw usual screen
      updateTimingData(); // this must be called from within draw NOT serial event (as it has graphics functions)
      blankAhead();
      
      incY = (yPos - oY) / subFrames; // sets an increment value for the y-position
      incX = speed / subFrames; // sets an increment value for the x-position
      cX = oX + incX;
      cY = oY + incY;
      
      for (byte i=0; i<(subFrames); i++){ // was -1
        oY = constrain(oY, 0, plotHeight-2);
        cY = constrain(cY, 0, plotHeight-2);
        // println("oY: " + oY + "cY: " + cY); 
        drawPlot(); 
        oX = cX;
        oY = cY;
        cX += incX; // increment current X position, advancing the plot across the screen
        cY += incY; // increase the current Y position value
      }
      xPos += speed; // updates the true X position
      if (xPos >=plotWidth-2) { // if the x position is at the right edge of the plot window
          println("oX: " + oX + " xPos: " + xPos);
          oldX = 0; // reset to the left of the plot window
          oX = 0;
          xPos = 1;
          cX = 1;
          // note that xPos is always related to the plot window not the program frame
      }
      oldX = xPos; // updates previous X position
      // oldY = yPos; // updates previous Y position  
    }
   drawScales(); // refresh gridlines
  // oldY = yPos; // updates previous Y position regardless of whether the screen is being drawn
  // println("X: " + cX + "Y: " + cY); 
}

void serialEvent(Serial myport) {
  // the function which reads the actual data from the Arduino through the USB port
  String dataStr; // a string to store the data read from the COM port
  
  dataStr = myport.readStringUntil( '\n' ); // read the whole line
  if (dataStr != null && (millis() > msStart + startDelay - 20)) { // if there is some data (and so isn't null) and not during start0up period...
    dataStr = trim(dataStr); // trim function removed any extra spaces
    dataInt = int(dataStr); // converts the text based number to a numerical value, an integer
    pressure = (map(dataInt, minRaw[aC], maxRaw[aC], trueLo[aC], trueHi[aC])); // maps the pressure to the scale
    // *** this would be a good place to flag over/under limit ***
    pressure = constrain(pressure, lScale[aC], uScale[aC]); // constrain pressure to scale limits
    oldY = yPos; // updates previous Y position
    yPos = int(map(pressure, lScale[aC], uScale[aC], 0, plotHeight-2)); // scales the input to the plot
    // println("Ypos: " + yPos + "oldY: " + oldY); 
    timing();
  }
}
