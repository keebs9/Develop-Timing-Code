void drawPlot() {
  if (xPos >= 0) { // doesn't draw anything at the very start when X is off the screen. This seems
    // an odd way of doing this but it allows time for the acquired signal to become valid 
    fill(230); // sets the fill colour for the blanking rectangle
    if (xPos < plotWidth-clrWidth-2) {
      stroke(230); // sets the stroke colour for the perimeter of the blanking rectangle
      rect(xPos+lMargin, tMargin, clrWidth, plotHeight); // draws the blanking rectangle
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1+lMargin, centre+tMargin, xPos+lMargin+clrWidth+1, centre+tMargin); // reinstates portion of centre line
    } else {
      // blanking rectangle still required else the plot line looks thicker
      stroke(230); // sets the stroke colour for the perimeter of the blanking rectangle
      rect(xPos+lMargin, tMargin, plotWidth-xPos-2, plotHeight); // draws the blanking rectangle //<>//
      stroke(10); // sets the stroke colour to restore the centre line
      line(xPos-1+lMargin, centre+tMargin, lMargin+plotWidth, centre+tMargin); // reinstates portion of centre line
    }
    stroke(230, 10, 10); // sets the drawing colour
    line(oldX+lMargin, plotHeight-oldY+tMargin, xPos+lMargin, plotHeight-yPos+tMargin);
  }
}
