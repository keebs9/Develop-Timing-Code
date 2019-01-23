// The purpose of this program is to develop a method of timing pressure cycles, //<>// //<>// //<>// //<>// //<>//
// initially within parameters set as constants by me in the program.

// add the additional functionality of the serial command set
import processing.serial.*;
Serial myport; // create a serial object
String data_in; // stores data received from the serial port

int plotWidth = 1000; // this is the width of the display window
int plotHeight = 513; // this is the height of the display, 513 is due to thickness of trace
int centre = plotHeight/2; // this is partly so I can check this value in the debugger
int lMargin = 40; // the position of the left margin
int rMargin = 900; // the position of the right margin

int yPos;
int xPos = 0; // sets the initial X position of the trace 
int oldY;
int oldX = 0;
int clrWidth = 40; // this is the width of the clear box in front of the trace

int upper = 50; // defines the upper limit of the timing window
int lower = 45; // defines the lower limit of the timing window
int scale = 50; // defines the scale of the vertical axis, presuming 0 at bottom
int pessure = 0; // converts the gitial input to a pressure based on the scale

void setup() {
  String arduinoPort = "COM3"; // my Arduino is on port COM3 as printer is on COM1
  println(arduinoPort); // this was used for debuggung COM select line
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent
  myport.bufferUntil('\n'); // reads until the end of the line

  noSmooth(); // Processing uses smoothing by default - turn this off to see the weird
  // problems I was having, overlapping lines of same colour were being liased making them
  // visibly different shades.

  frameRate(59); // sets the framerate in frames per second
  background(230); // sets the background fill colour and uses it to fill the screen
  size(1000, 513); // sets the size of the graphics window AS SIZE won't accept variables!
  strokeWeight(2); // sets thickness of drawing tools
  drawScales();
}

void serialEvent(Serial myport) { // the code to read the actual data
  String inString = myport.readStringUntil( '\n' ); // read the whole line

  if (inString != null ) {
    inString = trim(inString); // trim function removed any extra spaces
    // println(inString); // prints to the terminal to prove acquisition (suspended)

    yPos = int(inString)/2; // scales the input to a 512 pixel high output
  }
}

void draw() 
{
  if (xPos >= lMargin) { // doesn't draw anything at the very start when X is off the screen. This seems
    // an odd way of doing this but it also allows time for the acquired signal to become valid 
    fill(230); // sets the fill colour for the blanking rectangle
    if (xPos < rMargin-clrWidth-2) {
      stroke(230); // sets the stroke colour for the perimeter of the blanking rectangle
      rect(xPos, 0, clrWidth, plotHeight); // draws the blanking rectangle
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1, centre, xPos+clrWidth+1, centre); // reinstates portion of centre line
    } else {
      // no blanking rectangle is required as it has already been cleared by this point
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1, centre, rMargin, centre); // reinstates portion of centre line
    }
    stroke(230, 10, 10); // sets the drawing colour
    line(oldX, plotHeight - oldY, xPos, plotHeight - yPos); // plots the point at the current X position
  }

  xPos ++;
  if (xPos >=rMargin) { // leaving room on the right for text.
    xPos = lMargin; // leaving room for the scale
  }
  oldX = xPos;
  oldY = yPos;
}

void drawScales() {
  strokeCap(SQUARE);
  stroke(10); // sets the colour of the centre line and scales
  line(lMargin-1, centre, rMargin, centre); // horizontal line half way up
  line(lMargin-2, 0, lMargin-2, height); // draws left hand scale
  line(rMargin, 0, rMargin, height); // draws right hand scale
  stroke(0,0,230); // sets the colour of the graticules
  line(lMargin-7, 0, lMargin-2, 0); // draws lower left graticule
  line(rMargin, plotHeight, rMargin+5, plotHeight); // draws lower right graticule
  line(lMargin-7, plotHeight*0.125, lMargin-2, plotHeight*0.125); // draws 1/8 left graticule
  line(rMargin, plotHeight*0.125, rMargin+5, plotHeight*0.125); // draws 1/8 right graticule
  line(lMargin-7, plotHeight*0.25, lMargin-2, plotHeight*0.25); // draws 2/8 left graticule
  line(rMargin, plotHeight*0.25, rMargin+5, plotHeight*0.25); // draws 2/8 right graticule
  line(lMargin-7, plotHeight*0.375, lMargin-2, plotHeight*0.375); // draws 3/8 left graticule
  line(rMargin, plotHeight*0.375, rMargin+5, plotHeight*0.375); // draws 3/8 right graticule
  line(lMargin-7, plotHeight*0.5, lMargin-2, plotHeight*0.5); // draws 4/8 left graticule
  line(rMargin, plotHeight*0.5, rMargin+5, plotHeight*0.5); // draws 4/8 right graticule
  line(lMargin-7, plotHeight*0.625, lMargin-2, plotHeight*0.625); // draws 5/8 left graticule
  line(rMargin, plotHeight*0.625, rMargin+5, plotHeight*0.625); // draws 5/8 right graticule
  line(lMargin-7, plotHeight*0.750, lMargin-2, plotHeight*0.750); // draws 6/8 left graticule
  line(rMargin, plotHeight*0.750, rMargin+5, plotHeight*0.750); // draws 6/8 right graticule
  line(lMargin-7, plotHeight*0.875, lMargin-2, plotHeight*0.875); // draws 7/8 left graticule
  line(rMargin, plotHeight*0.875, rMargin+5, plotHeight*0.875); // draws 7/8 right graticule
  line(lMargin-7, plotHeight, lMargin-2, plotHeight); // draws upper left graticule
  line(rMargin, plotHeight, rMargin+5, plotHeight); // draws upper right graticule
  strokeCap(ROUND);
}
