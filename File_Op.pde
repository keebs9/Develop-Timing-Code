// declare variables primarily used in the saving & loading of calibration data
int aC = 0; // this is the number of the active config, deliberately small as referenced a lot
byte defaultCal = 0; // holds the number of the currenlty selected default data set
String[] calData = new String [nConfigs]; // Holds the config data as strings which can be saved to file, or loaded from file
// and save the data when required.

void saveCalData() { // the code used to save the current calibration data
// the saving function works by writing an array (set) of text stings to a text file. The data of each dataset are
// separated by tabs, accomplished by the '\t' elements in the code below. The text file must be in the same directory
// as the program is run from.
  for (byte i=0; i < nConfigs-1; i++){
    calData[i] = bText[i + nButtons] + '\t' + str(minRaw[i]) + '\t' + str(maxRaw[i]) + '\t' + str(lScale[i]); // separates data with tabs
    calData[i] += '\t' + str(uScale[i]) + '\t' + str(trueLo[i]) + '\t' + str(trueHi[i]); // separates data with tabs
    saveStrings("calData.PCT", calData); // this operation saves all 4 data sets in one operation
  }
}

void loadCalData() { // the code used to save the current calibration data
// the loading function works by reading each line of the text file into the calData array of text strings. The data must then be
// split back into individual items using the split function, the individual data elements are held in the "pieces" array of text
// strings. The data held in the pieces variable is then converted to floating point numbers so as to have a value (rather than
// being simply text), and stored in the corresponding dataset arrays e.g., lScale, uScale. The exception is that the pressure units
// is stored directly in the button text of the calibration buttons, from where it is referenced when drawing the scales.
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

void listCalData() { // displays the 4 datasets and allows 1 to be selected for saving
// the function uses the data sotred in the calibration button text and the dataset arrays to display a summary
// of each profile, to allow the user to know which config they are overwriting
  for (int i= nButtons + cButtons; i<nButtons + cButtons +dButtons -1; i++) { // repeat for number of "data" buttons
    int j = i-cButtons; // this is to shorten the code as else each j would be replaced with "i-cButtons"
    int k = i-nButtons-cButtons; // this is to shorten the code as else each k would be replaced with "i-nButtons-cButtons"
    fill(0);
    textSize(14);
    // the text lines use the text from the calibration buttons but the positions from the data buttons, hence i & j
    // the k referenecs are setting the index to 0..3 rather than say 8-11
    text("units: " + bText[j] + '\n' + "low: " + str(lScale[k]) + bText[j], bX1[i] + xOff, bY1[i] + yOff + 20);
    text("high: " + str(uScale[k]) + bText[j], bX1[i] + xOff, bY1[i] + yOff + 62);
  }
}
