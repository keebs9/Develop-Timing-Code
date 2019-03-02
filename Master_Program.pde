// The purpose of this program is to develop a method of timing pressure cycles,
// initially within parameters set as constants by me in the program.
// Today's aims are to show average cycle times as well as last cycle times and to set the output to seconds in the format #.#s

import processing.serial.Serial; // imports the additional functionality of the serial command set
Serial myport; // create a serial object

int progWidth = 1366; // the width of the entire program window
int progHeight = 768; // the height of the entire program window 
int plotWidth = 700; // this is the width of the display window
int plotHeight = 513; // this is the height of the display, 513 is due to thickness of trace
int centre = plotHeight/2; // this is partly so I can check this value in the debugger
int lMargin = 40; // the width & so the position of the left margin
int rMargin = lMargin + plotWidth; // the position of the right margin (from 0)
int tMargin = 147; // the height & so the position of the top margin
int bMargin = tMargin + plotHeight; // the position of the bottom margin (from 0)

int yPos;
int xPos = 0 - lMargin; // sets the initial X position of the trace off the viewable screen
int oldY;
int oldX = 0;
int clrWidth = 40; // this is the width of the clear box in front of the trace

float pressure = 0; // converts the digital input to a pressure based on the scale
int transTime = 100; // defines the duration in ms of transient timings which are to be ignored
boolean ignore = true; // a variable to record if transients are being ignored (tidier than using the button's active variable)

void setup() {
  String[] portsList = Serial.list();
  String arduinoPort = portsList[portsList.length-1]; // sets the COM port to highest active
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent
  myport.bufferUntil('\n'); // sets the function to always read until the end of the line

  noSmooth(); // Processing uses smoothing by default - turn this off to see the weird
  // problems I was having, overlapping lines of same colour were being liased making them
  // visibly different shades.
  size(1366, 768); // sets the size of the graphics window AS SIZE won't accept variables!
  defineButtons(); // initialises the buttons
  screenSetup(); // initialises the display e.g., size, background etc.
}

void serialEvent(Serial myport) { // the code to read the actual data
  String dataStr; // a string to store the data read from the COM port
  int dataInt; // an integer to store the integer value of the data

  dataStr = myport.readStringUntil( '\n' ); // read the whole line
  if (dataStr != null ) { // if there is some data and so isn't null...
    dataStr = trim(dataStr); // trim function removed any extra spaces
    dataInt = int(dataStr); // converts the text based number to a numerical value, an integer
    pressure = int(map(dataInt, 0, 1023, lScale, uScale)); // maps the pressure to the scale
    yPos = dataInt/2; // scales the input to a 512 pixel high output
    timing();
  }
}

void draw() 
{
  if (mousePressed) whatSelected(); // if the left mouse button is being pressed
  else {
    for (byte i=0; i<nButtons; i++)  { // repeat for the number of buttons
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
  println("line:"+lineDrag+" button:"+butPress); //development step
  
  drawPlot(); 
  updateTimingData(); // this must be called from within draw NOT serial event (as it has graphics functions)

  xPos ++; // increment current X position by 1, advancing the plot across the screen
  if (xPos >=plotWidth) { // if the x position is at the right edge of the plot window
    xPos = 0; // reset to the left of the plot window
    // note that xPos is always related to the plot window not the program frame
  }
  oldX = xPos; // updates previous X position
  oldY = yPos; // updates previous Y position
}
