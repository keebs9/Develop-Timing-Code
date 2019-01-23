// The purpose of this program is to develop a method of timing pressure cycles, //<>//
// initially within parameters set as constants by me in the program. The specific
// development today is placing the current plot window within a larger screen,
// allowing the top of the scales to be visible, and space for buttons & menus etc. 

// add the additional functionality of the serial command set
import processing.serial.*;
Serial myport; // create a serial object
String data_in; // stores data received from the serial port

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

int upper = 50; // defines the upper limit of the timing window
int lower = 45; // defines the lower limit of the timing window
int scale = 50; // defines the scale of the vertical axis, presuming 0 at bottom
int pessure = 0; // converts the digital input to a pressure based on the scale

void setup() {
  String arduinoPort = "COM3"; // my Arduino is on port COM3 as printer is on COM1
  println(arduinoPort); // this was used for debuggung COM select line
  myport = new Serial(this, arduinoPort, 115200); // "this" is default parent
  myport.bufferUntil('\n'); // reads until the end of the line

  noSmooth(); // Processing uses smoothing by default - turn this off to see the weird
  // problems I was having, overlapping lines of same colour were being liased making them
  // visibly different shades.

  frameRate(59); // sets the framerate in frames per second
  size(1350, 700); // sets the size of the graphics window AS SIZE won't accept variables!
  background(190); // sets the background fill colour and uses it to fill the screen
  
  strokeWeight(2); // sets thickness of drawing tools
  stroke(230);
  fill(230);
  rect(lMargin, tMargin, plotWidth, plotHeight);
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
  if (xPos >= 0) { // doesn't draw anything at the very start when X is off the screen. This seems
    // an odd way of doing this but it allows time for the acquired signal to become valid 
    fill(230); // sets the fill colour for the blanking rectangle
    if (xPos < plotWidth-clrWidth-2) {
      stroke(230); // sets the stroke colour for the perimeter of the blanking rectangle
      rect(xPos+lMargin, tMargin, clrWidth, plotHeight); // draws the blanking rectangle
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1+lMargin, centre+tMargin, xPos+lMargin+clrWidth+1, centre+tMargin); // reinstates portion of centre line
    } else {
      // no blanking rectangle is required as it has already been cleared by this point
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1+lMargin, centre+tMargin, lMargin+plotWidth, centre+tMargin); // reinstates portion of centre line
    }
    stroke(230, 10, 10); // sets the drawing colour
    line(oldX+lMargin, plotHeight-oldY+tMargin, xPos+lMargin, plotHeight-yPos+tMargin); // plots the point at the current X position
  }

  xPos ++;
  if (xPos >=plotWidth) { // if the x position is at the right edge of the plot window
    xPos = 0; // reset to the left of the plot window
    // note that xPos is always related to the plot window not the program frame
  }
  oldX = xPos;
  oldY = yPos;
}

void drawScales() {
  strokeCap(SQUARE);
  stroke(10); // sets the colour of the centre line and scales
  line(lMargin-1, centre+tMargin, rMargin, centre+tMargin); // horizontal line half way up
  line(lMargin-2, tMargin, lMargin-2, bMargin); // draws left hand scale
  line(rMargin, tMargin, rMargin, bMargin); // draws right hand scale
  stroke(0, 0, 230); // sets the colour of the graticules
  line(lMargin-7, tMargin, lMargin-2, tMargin); // draws lower left graticule
  line(rMargin, plotHeight+tMargin, rMargin+5, plotHeight+tMargin); // draws lower right graticule
  line(lMargin-7, (plotHeight*0.125)+tMargin, lMargin-2, (plotHeight*0.125)+tMargin); // draws 1/8 left graticule
  line(rMargin, (plotHeight*0.125)+tMargin, rMargin+5, (plotHeight*0.125)+tMargin); // draws 1/8 right graticule
  line(lMargin-7, (plotHeight*0.25)+tMargin, lMargin-2, (plotHeight*0.25)+tMargin); // draws 2/8 left graticule
  line(rMargin, (plotHeight*0.25)+tMargin, rMargin+5, (plotHeight*0.25)+tMargin); // draws 2/8 right graticule
  line(lMargin-7, (plotHeight*0.375)+tMargin, lMargin-2, (plotHeight*0.375)+tMargin); // draws 3/8 left graticule
  line(rMargin, (plotHeight*0.375)+tMargin, rMargin+5, (plotHeight*0.375)+tMargin); // draws 3/8 right graticule
  line(lMargin-7, (plotHeight*0.5)+tMargin, lMargin-2, (plotHeight*0.5)+tMargin); // draws 4/8 left graticule
  line(rMargin, (plotHeight*0.5)+tMargin, rMargin+5, (plotHeight*0.5)+tMargin); // draws 4/8 right graticule
  line(lMargin-7, (plotHeight*0.625)+tMargin, lMargin-2, (plotHeight*0.625)+tMargin); // draws 5/8 left graticule
  line(rMargin, (plotHeight*0.625)+tMargin, rMargin+5, (plotHeight*0.625)+tMargin); // draws 5/8 right graticule
  line(lMargin-7, (plotHeight*0.750)+tMargin, lMargin-2, (plotHeight*0.750)+tMargin); // draws 6/8 left graticule
  line(rMargin, (plotHeight*0.750)+tMargin, rMargin+5, (plotHeight*0.750)+tMargin); // draws 6/8 right graticule
  line(lMargin-7, (plotHeight*0.875)+tMargin, lMargin-2, (plotHeight*0.875)+tMargin); // draws 7/8 left graticule
  line(rMargin, (plotHeight*0.875)+tMargin, rMargin+5, (plotHeight*0.875)+tMargin); // draws 7/8 right graticule
  line(lMargin-7, plotHeight+tMargin, lMargin-2, plotHeight+tMargin); // draws upper left graticule
  line(rMargin, plotHeight+tMargin, rMargin+5, plotHeight+tMargin); // draws upper right graticule
  strokeCap(ROUND);
}
