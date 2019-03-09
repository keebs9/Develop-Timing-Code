byte nButtons = 4; // sets the total number of buttons
byte xOff = 5; // sets an X value offset for the buttons text so it is inset slightly
byte yOff = 20; // sets a Y value offset for the buttons text as text Y coordinates indicates bottom of text not the top
byte shadow = 2; // sets the offset of the selected button shadow

// create the button variables
int[] bX1 = new int[nButtons]; // holds the top left X coordinate of all the buttons
int[] bY1 = new int[nButtons]; // holds the top left Y coordinate of all the buttons
int[] bX2 = new int[nButtons]; // holds the bottom right X coordinate of all the buttons
int[] bY2 = new int[nButtons]; // holds the bottom right Y coordinate of all the buttons
boolean[] bPress = new boolean[nButtons]; // bPress means cursor is over the button & left button is being pressed
boolean[] bHeld = new boolean[nButtons]; // bHeld means you've actioned the button but kept the mouse pressed (prevents rapid toggling)
boolean[] bActive = new boolean[nButtons]; // bActive means the buttons function is applied
String[] bText = new String[nButtons]; // holds the text of all of the buttons

// assign values to the buttons
void defineButtons(){
  // define button one (2 window selection)
  bX1[0] = 30; // top left corner (x)
  bY1[0] = 20; // top left corner (y)
  bX2[0] = 130; // bottom right corner (x)
  bY2[0] = 50; // bottom right corner (y)
  bPress[0] = false;
  bHeld[0] = false;
  bActive[0] = true; // this sets the button to be selected by default
  bText[0] = "2 windows"; // button text
   
  // define button two (3 window selection)
  bX1[1] = 160;  // top left corner (x)
  bY1[1] = 20; // top left corner (y)
  bX2[1] = 260;
  bY2[1] = 50;
  bPress[1] = false;
  bHeld[1] = false;
  bActive[1] = false;
  bText[1] = "3 windows"; // button text
  
  // define button three (transients)
  bX1[2] = 320; // top left corner (x)
  bY1[2] = 20; // top left corner (y)
  bX2[2] = 450; // bottom right corner (x)
  bY2[2] = 75; // bottom right corner (y)
  bPress[2] = false;
  bHeld[2] = false;
  bActive[2] = true; // the default is to ignore transients
  bText[2] = "Ignore" + '\n' + "transients"; // the '/n' adds a new line command to the string
  
  // define button four (calibraiton)
  bX1[3] = 510; // top left corner (x)
  bY1[3] = 20; // top left corner (y)
  bX2[3] = 610; // bottom right corner (x)
  bY2[3] = 50; // bottom right corner (y)
  bPress[3] = false;
  bHeld[3] = false;
  bActive[3] = false; // the default is to run the program in normal mode rather than calibration mode
  bText[3] = "Calibrate";
}
