byte nButtons = 4; // sets the total number of "normal" buttons
byte cButtons = 4; // sets the total number of "calibration" buttons
byte dButtons = 5; // sets the total numerb of "data" buttons (used for save and load actions)
int tButtons = nButtons + cButtons + dButtons; // holds the total number of buttons
byte xOff = 5; // sets an X value offset for the buttons text so it is inset slightly
byte yOff = 20; // sets a Y value offset for the buttons text as text Y coordinates indicates bottom of text not the top
byte shadow = 2; // sets the offset of the selected button shadow

// create the button variables
int[] bX1 = new int[tButtons]; // holds the top left X coordinate of all the buttons
int[] bY1 = new int[tButtons]; // holds the top left Y coordinate of all the buttons
int[] bX2 = new int[tButtons]; // holds the bottom right X coordinate of all the buttons
int[] bY2 = new int[tButtons]; // holds the bottom right Y coordinate of all the buttons
boolean[] bPress = new boolean[tButtons]; // bPress means cursor is over the button & left button is being pressed
boolean[] bHeld = new boolean[tButtons]; // bHeld means you've actioned the button but kept the mouse pressed (prevents rapid toggling)
boolean[] bActive = new boolean[tButtons]; // bActive means the buttons function is applied
String[] bText = new String[tButtons]; // holds the text of all of the buttons

void defineButtons(){
// assign values to the "normal" buttons
  
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
  bText[3] = "Calibrate";
  
// assign values to the "calibration" buttons
  
  // define button five (cmH2O)
  bX1[4] = lMargin + 160; // top left corner (x)
  bY1[4] = tMargin + 200; // top left corner (y)
  bX2[4] = lMargin + 260; // bottom right corner (x)
  bY2[4] = tMargin + 230; // bottom right corner (y)
  bText[4] = "cmH2O"; // holds the unit text
  units[aC] = bText[4]; // sets the currently displayed units to cmH2O
 
  // define button six (mBar)
  bX1[5] = rMargin - 260; // top left corner (x)
  bY1[5] = tMargin + 200; // top left corner (y)
  bX2[5] = rMargin - 160; // bottom right corner (x)
  bY2[5] = tMargin + 230; // bottom right corner (y)
  bText[5] = "mBar"; // holds the unit text
  
  // define button seven (mmHg)
  bX1[6] = lMargin + 160; // top left corner (x)
  bY1[6] = tMargin + 300; // top left corner (y)
  bX2[6] = lMargin + 260; // bottom right corner (x)
  bY2[6] = tMargin + 330; // bottom right corner (y)
  bText[6] = "mmHg"; // holds the unit text
  
  // define button eight (PSI)
  bX1[7] = rMargin - 260; // top left corner (x)
  bY1[7] = tMargin + 300; // top left corner (y)
  bX2[7] = rMargin - 160; // bottom right corner (x)
  bY2[7] = tMargin + 330; // bottom right corner (y)
  bText[7] = "PSI";  // holds the unit text
  
// assigns data to the save/load data buttons
  
  // define button nine (profile 1)
  bX1[8] = lMargin + 100; // top left corner (x)
  bY1[8] = tMargin + 160; // top left corner (y)
  bX2[8] = lMargin + 260; // bottom right corner (x)
  bY2[8] = tMargin + 280; // bottom right corner (y)
  bText[8] = "Set A";  // holds the unit text
  
  // define button ten (profile 2)
  bX1[9] = rMargin - 260; // top left corner (x)
  bY1[9] = tMargin + 160; // top left corner (y)
  bX2[9] = rMargin - 100; // bottom right corner (x)
  bY2[9] = tMargin + 280; // bottom right corner (y)
  bText[9] = "Set B"; // holds the unit text
  
  // define button eleven (profile 3)
  bX1[10] = lMargin + 100; // top left corner (x)
  bY1[10] = tMargin + 320; // top left corner (y)
  bX2[10] = lMargin + 260; // bottom right corner (x)
  bY2[10] = tMargin + 440; // bottom right corner (y)
  bText[10] = "Set C"; // holds the unit text
  
  // define button twelve (profile 4)
  bX1[11] = rMargin - 260; // top left corner (x)
  bY1[11] = tMargin + 320; // top left corner (y)
  bX2[11] = rMargin - 100; // bottom right corner (x)
  bY2[11] = tMargin + 440; // bottom right corner (y)
  bText[11] = "Set D";  // holds the unit text
  
  // define button thirteen (profile 4)
  bX1[12] = rMargin - 400; // top left corner (x)
  bY1[12] = tMargin + 285; // top left corner (y)
  bX2[12] = rMargin - 300; // bottom right corner (x)
  bY2[12] = tMargin + 315; // bottom right corner (y)
  bText[12] = "Don't Save";  // holds the unit text
  
  for (byte i = nButtons; i< tButtons; i++) { // sets the typical buttons' activity flags to false
    bPress[i] = false;
    bHeld[i] = false;
    bActive[i] = false;
  }
}
