// The purpose of this program is to develop a method of timing pressure cycles,
// initially within parameters set as constants by me in the program. The specific
// development today is tming a single pressure window and displaying the current
// and last timing cycles for this window (achieved 23-01-2019 @ 15:22). I'm now going
// to change the rectangle mode to 3 CORNERS mode rather than corner, width & height.

import processing.serial.Serial; // imports the additional functionality of the serial command set
Serial myport; // create a serial object

int progWidth = 1350; // the width of the entire program window
int progHeight = 700; // the height of the entire program window 
int plotWidth = 1000; // this is the width of the display window
int plotHeight = 513; // this is the height of the display, 513 is due to thickness of trace
int centre = plotHeight/2; // this is partly so I can check this value in the debugger
int lMargin = 40; // the width & so the position of the left margin
int rMargin = lMargin + plotWidth; // the position of the right margin (from 0)
int tMargin = 147; // the height & so the position of the top margin
int bMargin = tMargin + plotHeight; // the position of the bottom margin (from 0)

int yPos;
int xPos = 0 - lMargin; // sets the initial X position of the trace off screen
int oldY;
int oldX = 0;
int clrWidth = 40; // this is the width of the clear box in front of the trace

int lScale = 0; // defines the bottom of the vertical axis scale
int uScale = 50; // defines the top of the vertical axis scale
float pressure = 0; // converts the digital input to a pressure based on the scale

void setup() {
  String[] portsList = Serial.list();
  String arduinoPort = portsList[portsList.length-1]; // sets the COM port to highest active
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent
  myport.bufferUntil('\n'); // sets the function ro always read until the end of the line

  noSmooth(); // Processing uses smoothing by default - turn this off to see the weird
  // problems I was having, overlapping lines of same colour were being liased making them
  // visibly different shades.
  size(1350, 700); // sets the size of the graphics window AS SIZE won't accept variables!
  screenSetup(); // initialises the display e.g., size, background etc.
}

void serialEvent(Serial myport) { // the code to read the actual data
  String dataStr; // a string to store the data read from the COM port
  int dataInt; // an integer to store the integer value of the data

  dataStr = myport.readStringUntil( '\n' ); // read the whole line
  if (dataStr != null ) {
    dataStr = trim(dataStr); // trim function removed any extra spaces
    // println(inString); // prints to the terminal to prove acquisition (suspended)

    dataInt = int(dataStr);
    pressure = int(map(dataInt, 0, 1023, lScale, uScale)); // maps the pressure to the scale
    yPos = dataInt/2; // scales the input to a 512 pixel high output
    timing();
  }
}

void draw() 
{
  drawPlot();
  drawTiming(); // this must be called from within draw NOT serial event (as it has graphics functions)

  xPos ++; // increment current X position by 1, advancing the plot across the screen
  if (xPos >=plotWidth) { // if the x position is at the right edge of the plot window
    xPos = 0; // reset to the left of the plot window
    // note that xPos is always related to the plot window not the program frame
  }
  oldX = xPos; // updates previous X position
  oldY = yPos; // updates previous Y position
}
