import de.bezier.guido.*;
// CONSTANTS
private final int NUM_ROWS = 18;
private final int NUM_COLS = 18;
private final int NUM_MINES = 40;
// STATES
private MSButton[][] buttons; // 2d array of minesweeper buttons
private ArrayList<MSButton> mines; // ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private int num_flags = NUM_MINES; // The number of flags left to use
private boolean mouseClicked = false;
private int startTime = 0; // When the game started
private int endTime = 0; // When the game ended
// FIRST BUTTON PRESS STATES
private boolean firstPress = true;
private int firstPressRow;
private int firstPressCol;
// IMAGES
PImage buttonImage,
       pressedButtonImage,
       mineImage,
       redMineImage,
       incorrectMineImage,
       flagImage,
       oneImage,
       twoImage,
       threeImage,
       fourImage,
       fiveImage,
       sixImage,
       sevenImage,
       eightImage,
       menuPanelImage,
       smileButtonImage,
       smilePressedButtonImage,
       coolButtonImage,
       coolPressedButtonImage,
       deadButtonImage,
       deadPressedButtonImage,
       scoreZeroImage,
       scoreOneImage,
       scoreTwoImage,
       scoreThreeImage,
       scoreFourImage,
       scoreFiveImage,
       scoreSixImage,
       scoreSevenImage,
       scoreEightImage,
       scoreNineImage;
// BUTTONS
MenuButton faceButton;


void setup () {
  size(576, 656);
  textAlign(CENTER,CENTER);

  // Initialize images
  buttonImage = loadImage("https://i.imgur.com/oAnzwYa.png", "png");
  pressedButtonImage = loadImage("https://i.imgur.com/KwqBwhi.png", "png");
  mineImage = loadImage("https://i.imgur.com/f8MnctS.png", "png");
  redMineImage = loadImage("https://i.imgur.com/cpN4VHd.png", "png");
  incorrectMineImage = loadImage("https://i.imgur.com/DY5fr5A.png", "png");
  flagImage = loadImage("https://i.imgur.com/pCiZgwT.png", "png");
  oneImage = loadImage("https://i.imgur.com/mrByZso.png", "png");
  twoImage = loadImage("https://i.imgur.com/W3i9xch.png", "png");
  threeImage = loadImage("https://i.imgur.com/xLgUDre.png", "png");
  fourImage = loadImage("https://i.imgur.com/hUnTlzz.png", "png");
  fiveImage = loadImage("https://i.imgur.com/FK3UiU6.png", "png");
  sixImage = loadImage("https://i.imgur.com/2406BD3.png", "png");
  sevenImage = loadImage("https://i.imgur.com/qslZ7NS.png", "png");
  eightImage = loadImage("https://i.imgur.com/KKXo07N.png", "png");
  menuPanelImage = loadImage("https://i.imgur.com/Rt3ICkI.png", "png");
  smileButtonImage = loadImage("https://i.imgur.com/VdjULyx.png", "png");
  smilePressedButtonImage = loadImage("https://i.imgur.com/vi9bxvd.png", "png");
  coolButtonImage = loadImage("https://i.imgur.com/2zPKsa1.png", "png");
  coolPressedButtonImage = loadImage("https://i.imgur.com/TKyoQ00.png", "png");
  deadButtonImage = loadImage("https://i.imgur.com/sRlmsij.png", "png");
  deadPressedButtonImage = loadImage("https://i.imgur.com/ufoEhXw.png", "png");
  scoreZeroImage = loadImage("https://i.imgur.com/uqzd9ds.png", "png");
  scoreOneImage = loadImage("https://i.imgur.com/p9Ihs9J.png", "png");
  scoreTwoImage = loadImage("https://i.imgur.com/HhNBvaB.png", "png");
  scoreThreeImage = loadImage("https://i.imgur.com/egFvbaG.png", "png");
  scoreFourImage = loadImage("https://i.imgur.com/g2hOQvl.png", "png");
  scoreFiveImage = loadImage("https://i.imgur.com/unXONab.png", "png");
  scoreSixImage = loadImage("https://i.imgur.com/kovMYqf.png", "png");
  scoreSevenImage = loadImage("https://i.imgur.com/E27qGsU.png", "png");
  scoreEightImage = loadImage("https://i.imgur.com/Rg1BK48.png", "png");
  scoreNineImage = loadImage("https://i.imgur.com/ndftokq.png", "png");

  // Initialize buttons
  faceButton = new MenuButton(288, 40, 40, 40);
  faceButton.setImages(smileButtonImage, smilePressedButtonImage);
  
  // Make the manager
  Interactive.make(this);
  
  // Creates an empty grid of buttons
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for(int r = 0; r < buttons.length; r++) {
    for(int c = 0; c < buttons[r].length; c++) {
      buttons[r][c] = new MSButton(r, c);
    }
  }

  // Initializes mines array list
  mines = new ArrayList<MSButton>();
}


public void mousePressed() {
  mouseClicked = true;
}


public void draw () {
  // Draw menu panel
  image(menuPanelImage, 0, 0);

  // Update facebutton
  if(faceButton.check()) {
    reset();
  }
  faceButton.show();

  // Draw flag counter
  drawFlagCounter();
  // Draw time counter
  drawTimeCounter();
  
  mouseClicked = false;
}


public void setMines() {
  int minesCount = 0;
  while(minesCount < NUM_MINES) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    MSButton target = buttons[r][c];

    if(!mines.contains(target)) {
      if(!(firstPressRow == r && firstPressCol == c)) {
        mines.add(target);
        minesCount++;
      }
    }
  }
}


public boolean isWon() {
  int clickedButtons = 0; // The number of buttons that are clicked
  for(MSButton[] list : buttons) { // Iterate over all buttons
    for(MSButton button : list) {
      if(button.isClicked()) { // Check if the button is clicked
        clickedButtons++;
      }
    }
  }

  if(clickedButtons == NUM_ROWS * NUM_COLS - NUM_MINES) { // If the number of clicked buttons is equal to the number of safe buttons
    return true;
  }
  return false;
}


public void reset() { // Resets the board
  firstPress = true;
  num_flags = NUM_MINES;
  faceButton.setImages(smileButtonImage, smilePressedButtonImage);
  // Resets all buttons
  for(MSButton[] list : buttons) {
    for(MSButton button : list) {
      button.reset();
    }
  }
  // Clears all mines
  mines.clear();
  // Saves current time
  startTime = millis();
  // Starts the game
  gameOver = false;
}


public void displayLosingMessage() {
  gameOver = true; // Ends game
  endTime = millis(); // Saves the end time
  for(MSButton mine : mines) { // Clicks all unflagged mines to show their location
    if(!mine.isFlagged()) {
      mine.click();
    }
  }
  for(MSButton[] list : buttons) { // Sets all flagged non mines off
    for(MSButton button : list) {
      if(button.isFlagged() && !mines.contains(button)) {
        button.setWrong();
      }
    }
  }
  faceButton.setImages(deadButtonImage, deadPressedButtonImage); // Change the face button images
}


public void displayWinningMessage() {
  gameOver = true;
  faceButton.setImages(coolButtonImage, coolPressedButtonImage);
}


public boolean isValid(int r, int c) {
  if(r < 0 || c < 0) {
    return false;
  }
  if(r >= NUM_ROWS || c >= NUM_COLS) {
    return false;
  }
  return true;
}


public int countMines(int row, int col) {
  int numMines = 0;
  for(int r = -1; r <= 1; r++) {
    for(int c = -1; c <= 1; c++) {
      if(!(r == 0 && c == 0)) {
        if(isValid(row + r, col + c)) {
          if(mines.contains(buttons[row + r][col + c])) {
            numMines++;
          }  
        }   
      }
    }
  }
  return numMines;
}


public void drawFlagCounter() {
  imageMode(CENTER);
  image(giveImage(num_flags % 10), 90, 40, 22, 40);
  image(giveImage(floor(num_flags / 10) % 10), 68, 40, 22, 40);
  image(giveImage(floor(floor(num_flags / 10) / 10)), 46, 40, 22, 40);
  imageMode(CORNER);
}


public void drawTimeCounter() {
  int time;
  // Different time calculations for gameover and not
  if(!gameOver) {
    time = floor((millis() - startTime)/1000);
  }
  else {
    time = floor((endTime - startTime)/1000);
  }
  // Caps time at 999
  if(time > 999) {
    time = 999;
  }
  imageMode(CENTER);
  image(giveImage(time % 10), width - 46, 40, 22, 40);
  image(giveImage(floor(time / 10) % 10), width - 68, 40, 22, 40);
  image(giveImage(floor(floor(time / 10) / 10)), width - 90, 40, 22, 40);
  imageMode(CORNER);
}


public PImage giveImage(int input) {
  if(input == 1) {
    return scoreOneImage;
  }
  else if(input == 2) {
    return scoreTwoImage;
  }
  else if(input == 3) {
    return scoreThreeImage;
  }
  else if(input == 4) {
    return scoreFourImage;
  }
  else if(input == 5) {
    return scoreFiveImage;
  }
  else if(input == 6) {
    return scoreSixImage;
  }
  else if(input == 7) {
    return scoreSevenImage;
  }
  else if(input == 8) {
    return scoreEightImage;
  }
  else if(input == 9) {
    return scoreNineImage;
  }
  else {
    return scoreZeroImage;
  }
}
