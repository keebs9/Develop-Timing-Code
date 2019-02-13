void drawPlot() {
  if (xPos >= 0) { // doesn't draw anything at the very start when X is off the screen. This seems
    // an odd way of doing this but it allows time for the acquired signal to become valid 
    fill(plotFill); // sets the fill colour for the blanking rectangle
    stroke(plotFill); // sets the stroke colour for the perimeter of the blanking rectangle

    // Note that xPos is always relative to plot width for calculations and the margins added when drawn

    if (xPos < (plotWidth-clrWidth-1)) { // has to be -1 or it overlaps R/H scale by 1 pixel
      rect(xPos+lMargin, tMargin, xPos+lMargin+clrWidth, bMargin); // draws the blanking rectangle
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1+lMargin, centre+tMargin, xPos+lMargin+clrWidth+1, centre+tMargin); // reinstates portion of centre line
    } else {
      if (xPos<plotWidth-1) { // no blank required when at very edge of window
        // blanking rectangle still required else the plot line looks thicker
        rect(xPos+lMargin, tMargin, plotWidth+lMargin-2, plotHeight+tMargin); // draws the blanking rectangle
        stroke(10); // sets the stroke colour to restore the centre line
        line(xPos-1+lMargin, centre+tMargin, lMargin+plotWidth, centre+tMargin); // reinstates portion of centre line
      }
    }
    
    // sets the drawing colour based on whether the trace is in a measurement window or not
    for (byte i=0; i<3; i++){ // repeat 3 times, once for each pressure window
      if (active[i]) { // if the current window number is active then... (only 1 window can be active at any time)
        stroke(darkR[i], darkG[i], darkB[i]); // set the drawing colours to that of the active window 
      }
    }
    
    strokeCap(ROUND); // this has to be round for this function otherwise there are many gaps, constant pressure lines disappear
    line(oldX+lMargin, plotHeight-oldY+tMargin, xPos+lMargin, plotHeight-yPos+tMargin); // draw plot line from last to current position
    strokeCap(SQUARE);
  }
}
