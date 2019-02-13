int timeXpos = rMargin+200;
int timeWidth = 90;
int timeShade = 255;
int textWidth = 105;
int textShade = 230;

void drawTiming() {
  for (byte i =0; i<3; i++) { // repeat for number of timing windows (change to a variable)
    fill(textShade); // sets fill colour of the blanking rectangle used to cover previous text
    stroke (textShade); // this must be the same colour as the fill (it is the outside of the rectangle)
    rect(timeXpos, tMargin+29+(75*i), timeXpos+textWidth, tMargin+53+(75*i)); // draw blanking rectangle over text
    fill(timeShade); 
    stroke (timeShade);
    rect(timeXpos+textWidth+1, tMargin+29+(75*i), timeXpos+textWidth+timeWidth, tMargin+53+(75*i));
    textSize(14);
    fill(0);
    text("Last duration: ", timeXpos+4, tMargin + 45 +(75*i));
    if (active[i] && !ignoring[i]) { // if this timing window is active enlarge the text & change its colour
      textSize(16); // set increased font size of the highlighted text
      fill(220, 155, 20); // sets the colour for the highlighted text
      text(time[i] + "ms", timeXpos+textWidth+10, tMargin + 45 +(75*i)); // print the time for this window in milliseconds
    } else {
      textSize(14); // set the font size to normal for normal text
      fill(0); // set the text colour to black for normal text
      text(time[i] + "ms", timeXpos+textWidth+10, tMargin + 45 +(75*i)); // print the time for this window in milliseconds
    }
  }
}
