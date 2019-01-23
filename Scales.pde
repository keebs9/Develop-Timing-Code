void drawScales() {
  strokeCap(SQUARE);
  stroke(10); // sets the colour of the centre line and scales
  line(lMargin-1, centre+tMargin, rMargin, centre+tMargin); // horizontal line half way up
  line(lMargin-2, tMargin, lMargin-2, bMargin); // draws left hand scale
  line(rMargin, tMargin, rMargin, bMargin); // draws right hand scale
  stroke(0, 0, 230); // sets the colour of the graticules
  line(lMargin-7, tMargin, lMargin-2, tMargin); // draws upper left graticule
  line(rMargin, tMargin, rMargin+5, tMargin); // draws upper right graticule
  line(lMargin-7, (plotHeight*0.125)+tMargin, lMargin-2, (plotHeight*0.125)+tMargin); // draws 1/8 left graticule
  line(rMargin, (plotHeight*0.125)+tMargin, rMargin+5, (plotHeight*0.125)+tMargin); // draws 1/8 right graticule
  line(lMargin-7, (plotHeight*0.25)+tMargin, lMargin-2, (plotHeight*0.25)+tMargin); // draws 2/8 left graticule
  line(rMargin, (plotHeight*0.25)+tMargin, rMargin+5, (plotHeight*0.25)+tMargin); // draws 2/8 right graticule
  line(lMargin-7, (plotHeight*0.375)+tMargin, lMargin-2, (plotHeight*0.375)+tMargin); // draws 3/8 left graticule
  line(rMargin, (plotHeight*0.375)+tMargin, rMargin+5, (plotHeight*0.375)+tMargin); // draws 3/8 right graticule
  line(lMargin-7, (plotHeight*0.5)+tMargin, lMargin-2, (plotHeight*0.5)+tMargin); // draws 4/8 left graticule
  line(rMargin, (plotHeight*0.5)+tMargin, rMargin+5, (plotHeight*0.5)+tMargin); // draws 4/8 right graticule
  line(lMargin-7, (plotHeight*0.625)+tMargin, lMargin-2, (plotHeight*0.625)+tMargin); // draws 5/8 left graticule
  line(rMargin, (plotHeight*0.625)+tMargin, rMargin+5, (plotHeight*0.625)+tMargin); // draws 5/8 right graticule
  line(lMargin-7, (plotHeight*0.750)+tMargin, lMargin-2, (plotHeight*0.750)+tMargin); // draws 6/8 left graticule
  line(rMargin, (plotHeight*0.750)+tMargin, rMargin+5, (plotHeight*0.750)+tMargin); // draws 6/8 right graticule
  line(lMargin-7, (plotHeight*0.875)+tMargin, lMargin-2, (plotHeight*0.875)+tMargin); // draws 7/8 left graticule
  line(rMargin, (plotHeight*0.875)+tMargin, rMargin+5, (plotHeight*0.875)+tMargin); // draws 7/8 right graticule
  line(lMargin-7, plotHeight+tMargin, lMargin-2, plotHeight+tMargin); // draws lower left graticule
  line(rMargin, plotHeight+tMargin, rMargin+5, plotHeight+tMargin); // draws lower right graticule
  strokeCap(ROUND);
}
