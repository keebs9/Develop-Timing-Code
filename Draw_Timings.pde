void drawTiming() {
  for (byte i =0; i<3; i++) { // repeat for number of timing windows (change to a variable)
    fill(230); // sets fill colour of the blanking rectangle used to cover previous text
    stroke (230); // this must be the same colour as the fill (it is the outside of the rectangle)
    rect(rMargin+15, tMargin+29+(75*i), rMargin+118, tMargin+53+(75*i)); // draw blanking rectangle
    fill(255); 
    stroke (255);
    rect(rMargin+119, tMargin+29+(75*i), rMargin+200, tMargin+53+(75*i));
    textSize(14);
    fill(0);
    text("Last duration: ", rMargin+20, tMargin + 45 +(75*i));
    if (active[i] && !ignoring[i]) { // if this timing window is active enlarge the text & change its colour
      textSize(16); // set increased font size of the highlighted text
      fill(220, 155, 20); // sets the colour for the highlighted text
      text(time[i] + "ms", rMargin + 120, tMargin + 45 +(75*i)); // print the time for this window in milliseconds
    } else {
      textSize(14); // set the font size to normal for normal text
      fill(0); // set the text colour to black for normal text
      text(time[i] + "ms", rMargin + 120, tMargin + 45 +(75*i)); // print the time for this window in milliseconds
    }
  }
}
