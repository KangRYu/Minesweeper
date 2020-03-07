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
       deadPressedButtonImage;
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
  smilePressedButtonImage = loadImage("https://i.imgur.com/odSFfUZ.png", "png");
  coolButtonImage = loadImage("https://i.imgur.com/2zPKsa1.png", "png");
  coolPressedButtonImage = loadImage("https://i.imgur.com/vgZJnyv.png", "png");
  deadButtonImage = loadImage("https://i.imgur.com/sRlmsij.png", "png");
  deadPressedButtonImage = loadImage("https://i.imgur.com/DdPqA2B.png", "png");

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
  println(true);
}


public void draw () {
  image(menuPanelImage, 0, 0);

  if(!gameOver) { // If the game is still playing
    if(isWon()) {
      gameOver = true;
    }
    else { // If the player hasn't won yet
    }
  }
  else { // If the game is over
    if(isWon()) { // If the player has won
      displayWinningMessage(); 
    }
    else {
    }
  }

  faceButton.check();
  faceButton.show();

  text(str(num_flags), width/2, 50);
  
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


public void displayLosingMessage() {
  gameOver = true;
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
  println("YOU LOST");
}


public void displayWinningMessage() {
  gameOver = true;
  println("YOU WON");
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
}

public class MenuButton {
  private float x, y, w, h; // Physical properties
  private PImage normalImage, pressedImage;
  private boolean hover; // Physical states

  public MenuButton(float argx, float argy, float argw, float argh) {
    x = argx;
    y = argy;
    w = argw;
    h = argh;
  }

  public void setImages(PImage argNormalImage, PImage argPressedImage) {
    normalImage = argNormalImage;
    pressedImage = argPressedImage;
  }

  public boolean check() {
    if(x - w/2 <= mouseX && mouseX <= x + w/2 && y - h/2 <= mouseY && mouseY <= y + h/2) {
      hover = true; 
    }
    else {
      hover = false;
    }

    if(hover) {
      if(mouseClicked) {
        return true;
      }
    }
    return false;
  }

  public void show() {
    imageMode(CENTER);
    if(hover) {
      image(pressedImage, x, y, w, h);
    }
    else {
      image(normalImage, x, y, w, h);
    }
    imageMode(CORNER);
  }
}
