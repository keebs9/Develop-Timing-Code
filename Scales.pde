// declare all the variables primarily associated with the plot's vertical scales
int scaleColour = #B9D8FF; // defines the colour of the scale lines over the plot (acquired from colour picker) 
int gratColour = #124889; // defiens the colour used to draw the scale graticules
int labelColour = #1011AA; // defines the colour used to print the axis labels

float[] trueLo = new float[nConfigs]; // defines the lowest pressure recorded during calibration (in pressure units)
float[] trueHi = new float[nConfigs]; // defines the highest pressure recorded during calibration (in pressure units)
float[] lScale = new float[nConfigs]; // defines the bottom of the vertical axis scale (in pressure units)
float[] uScale  = new float[nConfigs]; // defines the top of the vertical axis scale (in pressure units)

byte nDivisions = 8; // defines the number of on-screen divisions of the vertical axis, note that this 8 divsions (band) = 9 graticules
float gapNum; // stores the gap/spacing in the numerical value of the scale divisions
String[] units = new String[nConfigs]; // stores the current pressure units
String nVal; // stores the value of the current scale division (tidies up the code)
float yScale; // stores the current Y value for drawing the scale (tidies up the code)

// the defined speeds which result in the 6 selectable timebases (5s, 10s, 15s, 20s, 30s, 60s)
// speed = plot width (can't be referenced here as yet to be defiend) / timebase * frames per second 
float[] speeds = {pW/(5.0*fps), pW/(10.0*fps), pW/(15.0*fps), pW/(20.0*fps), pW/(30.0*fps), pW/(60.0*fps)};

void drawScales() { // a function which draws the vertical plot scale lines, graticules and labels
  strokeCap(SQUARE);
  fill(bgFill); // set the fill colour to that of the background
  stroke(bgFill); // set the line colour the same as this is used for the ouside of the rectangle
  rect(rMargin, tMargin-10, winXpos-1, bMargin+6); // blanks the area of the scale (was rMargin+10)
  
  if (lScale[aC] <0 && uScale[aC] >=0) { // if the lower scale is negative & the top scsale positive...
    // the numerical gap between divisions equals the sum of the absolute scale limits e.g., -20 to 40 = 60
    gapNum = (abs(lScale[aC]) + abs(uScale[aC])) / nDivisions;
  } else
  {
    // the numerical gap between divisions equals the difference between the scale limits e.g., 20 to 40 = 20
    gapNum = (uScale[aC]-lScale[aC]) / nDivisions; // calculates the size of the numerical gap between divisions
  }
  
  stroke(gratColour); // set the colour used to draw the scale lines at each edge of the plot
  line(lMargin-1, tMargin-1, lMargin-1, bMargin+1); // draws left hand scale (-1 else drawn over by trace blanking)
  line(rMargin, tMargin-1, rMargin, bMargin+1); // draws right hand scale

  fill(labelColour); // sets the colour of the text for the pressure values on the vertical scale
  textSize(14); // define text size
  for (byte i =0; i <= nDivisions; i++) { // repeat for number of scale points
    yScale = tMargin + (plotHeight * (i * 0.125)); // calculates the vertical position of the current scale 
    nVal = nfp(uScale[aC] - (i * gapNum), 0, 2); // calculates the current scale value, nfp is used to add polarity sign and set decimal points
    stroke(gratColour); // sets the colour of the graticules
    line(lMargin-7, yScale, lMargin-2, yScale); // draws left hand scale
    line(rMargin, yScale, rMargin+5, yScale); // draws right hand scale
    text(nVal + " " + units[aC], rMargin + 6, yScale+4); // prints the scale numerical value (from the top down)
  }
}

void drawGridLines(float x1, float x2) { // a function to draw the gridlines between 2 given (inputted) x co-ordinates
  for (byte i =0; i <= nDivisions; i++) { // repeat for number of scale points 
  yScale = tMargin + (plotHeight * (i * 0.125)); // calculates the vertical position of the current scale
    // set the colour of the scale lines over the actual plot (black for centre line)
    if (i == nDivisions/2) stroke(10);
    else stroke(scaleColour);
    line(x1, yScale, x2, yScale); // draws the scale lines over the actual plot
  }
}

void drawHorizontalScale(){
  fill(bgFill); // set the fill colour to that of the background
  stroke(bgFill); // set the line colour the same as this is used for the ouside of the rectangle
  rect(lMargin, plotHeight+tMargin+3, rMargin, progHeight); // blanks the area of the horizontal scale & label
  
  float i=0; // stores the current horizontal position, used in the while loop 
  String textOut = ""; // stores the text label to be printed under the horizontal scale
  float textX = 0; // stores the left hand edge of the text position, set automatically below
  
  stroke(gratColour); // sets the colour of the graticules
  line(lMargin, plotHeight+tMargin+9, rMargin, plotHeight+tMargin+9);
  
  while(int(i)<=plotWidth) { // repeat the loop until i is greater than the plotwidth
    line(lMargin+i, plotHeight+tMargin+8, lMargin+i, plotHeight+tMargin+24); // draws a second (s) division at the current position
    i += (speed*fps); // increment i by the number of frames per second, putting it at the x-position of the next whole second
  }
  
  i -= (speed*fps); // decrement i by 1 frame as last increment takes position beyond plotwidth and causes #s to be 1 too high
  
  textSize(16); // sets the text size of the following text
  textOut = "The plot width spans " + str(round(i/fps/speed)) + " seconds"; // sets the text to be printed on the screen
  textX = lMargin + (plotWidth/2) - (textWidth(textOut) / 2); // sets the start of the text X position based on the lenght of the text
  fill(labelColour); // sets the text colour to black
  text(textOut, textX, plotHeight+tMargin+45); // states the purpose of the horizontal graticules
}

void selectTimebase(){
  buttons();
}
