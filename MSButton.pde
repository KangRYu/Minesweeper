public class MSButton {
  private int myRow, myCol;
  private float x, y, width, height;
  private boolean clicked, flagged, wrong; // States
  private boolean firstMine = false; // The first mine that is clicked, should be red
  private String myLabel;
  
  public MSButton (int row, int col) {
    width = 576.0 / NUM_COLS;
    height = 576.0 / NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height + 80;
    myLabel = "";
    flagged = clicked = wrong = false;
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed() {
    if(!gameOver) {
      if(mouseButton == RIGHT && !isClicked()) {
        if(flagged) {
          num_flags++;
        }
        else {
          num_flags--;
        }
        flagged = !flagged;
      }
      else if(!flagged) {
        if(firstPress) {
          firstPressRow = myRow;
          firstPressCol = myCol;
          setMines();
          firstPress = false;
        }
        clicked = true;
        if(mines.contains(this)) {
          displayLosingMessage();
          firstMine = true;
        }
        else if(countMines(myRow, myCol) > 0) {
          myLabel = str(countMines(myRow, myCol));
        }
        else {
          for(int r = -1; r <= 1; r++) {
            for(int c = -1; c <= 1; c++) {
              if(!(r == 0 && c == 0)) {
                if(isValid(myRow + r, myCol + c)) {
                  if(!buttons[myRow + r][myCol + c].isClicked()) {
                    buttons[myRow + r][myCol + c].mousePressed();
                  }
                }   
              }
            }
          }
        }
      }
    }
    if(isWon()) { // Check winning conditions
      displayWinningMessage();
    }
  }

  public void draw () {  
    if (flagged) {
      if(wrong) {
        image(incorrectMineImage, x, y, width, height);
      }
      else {
        image(flagImage, x, y, width, height);
      }
    }
    else if(clicked && mines.contains(this)) {
      if(firstMine) {
        image(redMineImage, x, y, width, height);
      }
      else {
        image(mineImage, x, y, width, height);
      }
    }
    else if(clicked) {
      if(myLabel.equals("1")) {
        image(oneImage, x, y, width, height);
      }
      else if(myLabel.equals("2")) {
        image(twoImage, x, y, width, height);
      }
      else if(myLabel.equals("3")) {
        image(threeImage, x, y, width, height);
      }
      else if(myLabel.equals("4")) {
        image(fourImage, x, y, width, height);
      }
      else if(myLabel.equals("5")) {
        image(fiveImage, x, y, width, height);
      }
      else if(myLabel.equals("6")) {
        image(sixImage, x, y, width, height);
      }
      else if(myLabel.equals("7")) {
        image(sevenImage, x, y, width, height);
      }
      else if(myLabel.equals("8")) {
        image(eightImage, x, y, width, height);
      }
      else {
        image(pressedButtonImage, x, y, width, height);
      }
    }
    else {
      image(buttonImage, x, y, width, height);
    } 
  }

  public void setLabel(String newLabel) {
    myLabel = newLabel;
  }

  public void setLabel(int newLabel) {
    myLabel = ""+ newLabel;
  }

  public boolean isFlagged() {
    return flagged;
  }

  public boolean isClicked() {
    return clicked;
  }

  public void click() { // Clicks the button no matter if it is flagged or not
    if(flagged) {
      flagged = false;
    }
    clicked = true;
  }

  public void setWrong() {
    wrong = true;
  }

  public void reset() { // Resets the button
    clicked = flagged = wrong = firstMine = false;
    myLabel = "";
  }
}
