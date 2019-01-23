void drawTiming() {
  for (byte i =0; i<3; i++) {
    fill(230); 
    stroke (230);
    rect(rMargin+15, tMargin+29+(75*i), rMargin+118, tMargin+53+(75*i));
    fill(255); 
    stroke (255);
    rect(rMargin+119, tMargin+29+(75*i), rMargin+200, tMargin+53+(75*i));
    textSize(14);
    fill(0);
    text("Last duration: ", rMargin+20, tMargin + 45 +(75*i));
    if (active[i]) {
      textSize(16);
      fill(255, 20, 20);
      text(time[i] + "ms", rMargin + 120, tMargin + 45 +(75*i));
    } else {
      textSize(14);
      fill(0);
      text(time[i] + "ms", rMargin + 120, tMargin + 45 +(75*i));
    }
  }
}
