void drawTiming() {
  fill(230); 
  stroke (230);
  rect(rMargin+10, tMargin+32, 180, 18);
  fill(255); 
  stroke (255);
  rect(rMargin+115, tMargin+32, 80, 18);
  textSize(14);
  fill(0);
  text("Last duration: ", rMargin+20, tMargin + 45);
  if (active[0]) {
    textSize(16);
    fill(255, 20, 20);
    text(time[0] + "ms", rMargin + 120, tMargin + 45);
  } else {
    textSize(14);
    fill(0);
    text(time[0] + "ms", rMargin + 120, tMargin + 45);
  }
}
