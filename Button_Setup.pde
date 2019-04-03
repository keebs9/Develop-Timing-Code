// declare all the vaiabled which are generic to all the buttons e.h., how many of each group
byte nButtons = 8; // defines the total number of "normal" buttons
byte cButtons = 4; // defines the total number of "calibration" buttons
byte dButtons = 5; // defines the total numerb of "data" buttons (used for save and load actions)
int tButtons = nButtons + cButtons + dButtons; // stores the total number of buttons
byte xOff = 5; // defines an X value offset for the buttons text so it is inset slightly
byte yOff = 20; // defines a Y value offset for the buttons text as text Y coordinates indicates bottom of text not the top
byte shadow = 2; // defines the offset of the selected button shadow

// declare the button variables, each element is an array with a size of the total number of buttons
int[] bX1 = new int[tButtons]; // stores the top left X coordinate of all the buttons
int[] bY1 = new int[tButtons]; // stores the top left Y coordinate of all the buttons
int[] bX2 = new int[tButtons]; // stores the bottom right X coordinate of all the buttons
int[] bY2 = new int[tButtons]; // stores the bottom right Y coordinate of all the buttons
String[] bText = new String[tButtons]; // stores the text of all of the buttons
boolean[] bPress = new boolean[tButtons]; // bPress means the cursor is over the button & left button is being pressed
boolean[] bHeld = new boolean[tButtons]; // bHeld means you've actioned the button but kept the mouse pressed (prevents rapid toggling)
boolean[] bActive = new boolean[tButtons]; // bActive means the buttons function is applied

boolean startNext = false; // if True instructs the program only to start timing when a new phase is entered

void defineButtons(){
// assign values to the "normal" buttons (1 to 8)
  
  // define button one (2 window selection)
  bX1[0] = lMargin; // top left corner (x)
  bY1[0] = 20; // top left corner (y)
  bX2[0] = bX1[0] + 100; // bottom right corner (x)
  bY2[0] = bY1[0] + 30; // bottom right corner (y)
  bPress[0] = false;
  bHeld[0] = false;
  bActive[0] = false; // this sets the button to be selected by default
  bText[0] = "2 windows"; // button text
   
  // define button two (3 window selection)
  bX1[1] = bX1[0];  // top left corner (x)
  bY1[1] = bY2[0] +15; // top left corner (y)
  bX2[1] = bX1[1] + 100; // bottom right corner (x)
  bY2[1] = bY1[1] + 30; // bottom right corner (y)
  bPress[1] = false;
  bHeld[1] = false;
  bActive[1] = true;
  bText[1] = "3 windows"; // button text
    
  // define button three (transients)
  bX1[2] = bX1[1] + 160; // top left corner (x)
  bY1[2] = 20; // top left corner (y)
  bX2[2] = bX1[2] + 100; // bottom right corner (x)
  bY2[2] = bY1[2] + 55; // bottom right corner (y)
  bPress[2] = false;
  bHeld[2] = false;
  bActive[2] = true; // the default is to ignore transients
  bText[2] = "Ignore" + '\n' + "transients"; // the '/n' adds a new line command to the string
  
  // define button four (calibraiton)
  bX1[3] = lMargin+plotWidth+5; // top left corner (x)
  bY1[3] = 20; // top left corner (y)
  bX2[3] = bX1[3] + 100; // bottom right corner (x)
  bY2[3] = 50; // bottom right corner (y)
  bText[3] = "Calibrate";
  
  // define button five (Time base)
  bX1[4] = 350; // top left corner (x)
  bY1[4] = progHeight -55; // top left corner (y)
  bX2[4] = bX1[4] + 75; // bottom right corner (x)
  bY2[4] = bY1[4] + 30; // bottom right corner (y)
  bPress[4] = false;
  bHeld[4] = false;
  bActive[4] = false;
  bText[4] = "Timebase"; // sets the text to the string defined above
  
  // define button six (Alter Scale)
  bX1[5] = bX1[3]; // top left corner (x)
  bY1[5] = progHeight -75; // top left corner (y)
  bX2[5] = bX1[5] + 100; // bottom right corner (x)
  bY2[5] = bY1[5] + 55; // bottom right corner (y)
  bPress[5] = false;
  bHeld[5] = false;
  bActive[5] = false;
  bText[5] = "Alter" + '\n' + "scale"; // the '/n' adds a new line command to the string
  
  // define button seven (Start on new phase)
  bX1[6] = bX1[2] + 160; // top left corner (x)
  bY1[6] = 20; // top left corner (y)
  bX2[6] = bX1[6] + 100; // bottom right corner (x)
  bY2[6] = bY1[6] + 55; // bottom right corner (y)
  bPress[6] = false;
  bHeld[6] = false;
  bActive[6] = false; // can't start true as it may enter a new phase instantly
  bText[6] = "Start on" + '\n' + "new phase"; // the '/n' adds a new line command to the string
  
  // define button eight (Record timing)
  bX1[7] = bX1[6] + 160; // top left corner (x)
  bY1[7] = 20; // top left corner (y)
  bX2[7] = bX1[7] + 100; // bottom right corner (x)
  bY2[7] = bY1[7] + 55; // bottom right corner (y)
  bPress[7] = false;
  bHeld[7] = false;
  bActive[7] = false;
  bText[7] = "Start" + '\n' + "recording"; // the '/n' adds a new line command to the string
  
// assign values to the "calibration" buttons (9 to 12)
  
  // define button five (cmH2O)
  bX1[nButtons] = lMargin + 160; // top left corner (x) (nButtons is used in case more buttons are added)
  bY1[nButtons] = tMargin + 200; // top left corner (y)
  bX2[nButtons] = lMargin + 260; // bottom right corner (x)
  bY2[nButtons] = tMargin + 230; // bottom right corner (y)
  bText[nButtons] = "cmH2O"; // holds the unit text
  units[aC] = bText[nButtons]; // sets the currently displayed units to cmH2O
 
  // define button six (mBar)
  bX1[nButtons+1] = rMargin - 260; // top left corner (x)
  bY1[nButtons+1] = tMargin + 200; // top left corner (y)
  bX2[nButtons+1] = rMargin - 160; // bottom right corner (x)
  bY2[nButtons+1] = tMargin + 230; // bottom right corner (y)
  bText[nButtons+1] = "mBar"; // holds the unit text
  
  // define button seven (mmHg)
  bX1[nButtons+2] = lMargin + 160; // top left corner (x)
  bY1[nButtons+2] = tMargin + 300; // top left corner (y)
  bX2[nButtons+2] = lMargin + 260; // bottom right corner (x)
  bY2[nButtons+2] = tMargin + 330; // bottom right corner (y)
  bText[nButtons+2] = "mmHg"; // holds the unit text
  
  // define button eight (PSI)
  bX1[nButtons+3] = rMargin - 260; // top left corner (x)
  bY1[nButtons+3] = tMargin + 300; // top left corner (y)
  bX2[nButtons+3] = rMargin - 160; // bottom right corner (x)
  bY2[nButtons+3] = tMargin + 330; // bottom right corner (y)
  bText[nButtons+3] = "PSI";  // holds the unit text
  
// assigns data to the save/load data buttons (13 to 17)
  
  // define button nine (profile 1)
  bX1[nButtons+cButtons] = lMargin + 100; // top left corner (x) (nButtons+cButtons is used in case more buttons are added)
  bY1[nButtons+cButtons] = tMargin + 160; // top left corner (y)
  bX2[nButtons+cButtons] = lMargin + 260; // bottom right corner (x)
  bY2[nButtons+cButtons] = tMargin + 280; // bottom right corner (y)
  bText[nButtons+cButtons] = "Set A";  // holds the unit text
  
  // define button ten (profile 2)
  bX1[nButtons+cButtons+1] = rMargin - 260; // top left corner (x)
  bY1[nButtons+cButtons+1] = tMargin + 160; // top left corner (y)
  bX2[nButtons+cButtons+1] = rMargin - 100; // bottom right corner (x)
  bY2[nButtons+cButtons+1] = tMargin + 280; // bottom right corner (y)
  bText[nButtons+cButtons+1] = "Set B"; // holds the unit text
  
  // define button eleven (profile 3)
  bX1[nButtons+cButtons+2] = lMargin + 100; // top left corner (x)
  bY1[nButtons+cButtons+2] = tMargin + 320; // top left corner (y)
  bX2[nButtons+cButtons+2] = lMargin + 260; // bottom right corner (x)
  bY2[nButtons+cButtons+2] = tMargin + 440; // bottom right corner (y)
  bText[nButtons+cButtons+2] = "Set C"; // holds the unit text
  
  // define button twelve (profile 4)
  bX1[nButtons+cButtons+3] = rMargin - 260; // top left corner (x)
  bY1[nButtons+cButtons+3] = tMargin + 320; // top left corner (y)
  bX2[nButtons+cButtons+3] = rMargin - 100; // bottom right corner (x)
  bY2[nButtons+cButtons+3] = tMargin + 440; // bottom right corner (y)
  bText[nButtons+cButtons+3] = "Set D";  // holds the unit text
  
  // define button thirteen (don't save)
  bX1[nButtons+cButtons+4] = rMargin - 400; // top left corner (x)
  bY1[nButtons+cButtons+4] = tMargin + 285; // top left corner (y)
  bX2[nButtons+cButtons+4] = rMargin - 300; // bottom right corner (x)
  bY2[nButtons+cButtons+4] = tMargin + 315; // bottom right corner (y)
  bText[nButtons+cButtons+4] = "Don't Save";  // holds the unit text
  
  for (byte i = nButtons; i< tButtons; i++) { // sets the typical buttons' activity flags to false
    bPress[i] = false;
    bHeld[i] = false;
    bActive[i] = false;
  }
}
