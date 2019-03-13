int aC = 0; // this is the number of the active config, deliberately small as referenced a lot
byte defaultCal = 0; // holds the number of the currenlty selected default data set
String[] calData = new String [nConfigs]; // Holds the config data as strings which can be saved to file, or loaded from file
// and save the data when required.

void saveCalData() { // the code used to save the current calibration data
  for (byte i=0; i < nConfigs-1; i++){
    calData[i] = bText[i + nButtons] + '\t' + str(minRaw[i]) + '\t' + str(maxRaw[i]) + '\t' + str(lScale[i]); // separates data with tabs
    calData[i] += '\t' + str(uScale[i]) + '\t' + str(trueLo[i]) + '\t' + str(trueHi[i]); // separates data with tabs
    saveStrings("calData.PCT", calData); // this operation saves all 4 data sets in one operation
  }
}

void loadCalData() { // the code used to save the current calibration data
  calData = loadStrings("calData.PCT");
  for (byte i=0; i<nConfigs-1; i++){ // nConfigs -1 as the last data set is temporary
    String[] pieces = split(calData[i], '\t'); // ++ pieces is an array of 4 strings, data is separated by tabs
    // next put that data into the correct place using..
    bText[i+nButtons] = pieces[0];
    units[i] = bText[i+nButtons];
    minRaw[i] = float(pieces[1]);
    maxRaw[i] = float(pieces[2]);
    lScale[i] = float(pieces[3]);
    uScale[i] = float(pieces[4]);
    trueLo[i] = float(pieces[5]);
    trueHi[i] = float(pieces[6]);
  }
}

void listCalData() { // displays the 4 datasets and allows 1 to be selected (for loading AND for saving)
  for (int i= nButtons + cButtons; i<nButtons + cButtons +dButtons -1; i++) { // repeat for number of "data" buttons
    fill(0);
    textSize(14);
    // text("units: " + bText[i-cButtons] + '\n' + "low: " + str(lScale) + bText[i-nButtons], bX1[i] + xOff, bY1[i] + yOff + 20);
    //text("high: " + str(uScale) + bText[i], bX1[i] + xOff, bY1[i] + yOff + 40);
  }
}
