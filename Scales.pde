float lScale = -40; // defines the bottom of the vertical axis scale (shall be definable)
float uScale = 40; // defines the top of the vertical axis scale (shall be definable)
byte nDivisions = 8; // creates a variable for the number of on-screen divisions
float gapNum; // creates a variable to hold the gap/spacing in the numerical value of the scale divisions
String units = "cmH2O"; // sets the default pressure units
String nVal; // holds the value of the current scale division (tidies up the code)
float yScale; // this holds the current Y value for drawing the scale (tidies up the code)

void drawScales() {
  strokeCap(SQUARE);

  gapNum = (abs(lScale) + abs(uScale)) / nDivisions; // calculates the size of the numerical gap between divisions 

  stroke(10); // sets the colour of the centre line and scales
  line(lMargin-1, centre+tMargin, rMargin, centre+tMargin); // horizontal line half way up
  line(lMargin-2, tMargin-1, lMargin-2, bMargin+1); // draws left hand scale
  line(rMargin, tMargin-1, rMargin, bMargin+1); // draws right hand scale

  stroke(0, 0, 230); // sets the colour of the graticules
  fill(30, 30, 230); // sets the colour of the text for the pressure values on the vertical scale
  for (byte i =0; i <= nDivisions; i++) { // repeat for number of scale points

    yScale = tMargin + (plotHeight * (i * 0.125)); // calculates the vertical position of the current scale 
    nVal = nfp(uScale - (i * gapNum), 0, 2); // calculates the current scale value, nfp is used to add polarity sign and set decimal points

    line(lMargin-7, yScale, lMargin-2, yScale); // draws left hand scale
    line(rMargin, yScale, rMargin+5, yScale); // draws right hand scale
    text(nVal + " " + units, rMargin + 6, yScale+4); // prints the scale numerical value (from the top down)
  }
}
