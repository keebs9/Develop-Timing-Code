void whatSelected() { //<>// //<>//
  int xM = mouseX; // read the mouse X position into a variable
  int yM = mouseY; // read the mouse Y position into a variable
  for (byte i = 0; i <= (nButtons -1); i++) { // repeat for each button (index starts at zero, hence -1
    if ((xM >= bX1[i] && xM <= bX2[i]) && (yM >= bY1[i] && yM <= bY2[i])) {
      bPress[i] = true;
    }
  }
  actionButtons();
}

void actionButtons() {
  // specifically deals with the first 2 buttons which are interlocked

  // if either of the first 2 buttons are pressed (cliked on) but not yes Helded...
  if ((bPress[0] && !bActive[0]) || (bPress[1] && !bActive[1])) {
    bActive[0] = !bActive[0]; // invert the selection for button 0
    bActive[1] = !bActive[1]; // invert the selection for button 1
    drawButtons(); // redraw the buttons in their new states
  }

  // specifically deals with button 3 which determines if transients are ignored

  if (bPress[2] && !bHeld[2]) { // if button 2 was pressed but wasn't previously
    bActive[2] = !bActive[2]; // invert the button2 Held
    ignore = bActive[2]; // set the ignore flag to the button state i.e., True or False
    drawButtons(); // redraw the buttons in their new states
    bHeld[2] = true; // set the button Held to true meaning it was already pressed and actioned
  }
}
