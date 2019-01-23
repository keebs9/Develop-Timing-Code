void drawPlot() {
  if (xPos >= 0) { // doesn't draw anything at the very start when X is off the screen. This seems
    // an odd way of doing this but it allows time for the acquired signal to become valid 
    fill(230); // sets the fill colour for the blanking rectangle
    stroke(230); // sets the stroke colour for the perimeter of the blanking rectangle
    if (xPos >= 999) {
      stroke(255, 0, 0); // just a debugging line
    }

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
    stroke(230, 10, 10); // sets the drawing colour
    strokeCap(ROUND);
    line(oldX+lMargin, plotHeight-oldY+tMargin, xPos+lMargin, plotHeight-yPos+tMargin);
    strokeCap(SQUARE);
  }
}
