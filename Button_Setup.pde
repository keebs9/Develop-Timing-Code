byte nButtons = 3; // sets the total number of buttons
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
  bX1[0] = 30; // define button one
  bY1[0] = 20;
  bX2[0] = 130;
  bY2[0] = 50;
  bPress[0] = false;
  bHeld[0] = false;
  bActive[0] = true; // this sets the button to be selected by default
  bText[0] = "2 windows";
   
  bX1[1] = 160; // define button one
  bY1[1] = 20;
  bX2[1] = 260;
  bY2[1] = 50;
  bPress[1] = false;
  bHeld[1] = false;
  bActive[1] = false;
  bText[1] = "3 windows";
  
  bX1[2] = 160; // define button three
  bY1[2] = 70;
  bX2[2] = 260;
  bY2[2] = 125;
  bPress[2] = false;
  bHeld[2] = false;
  bActive[2] = true; // the default is to ignore transients
  bText[2] = "ignore" + '\n' + "transients"; // the '/n' adds a new line command to the string
}
