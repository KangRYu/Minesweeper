import de.bezier.guido.*;
// CONSTANTS
private final int NUM_ROWS = 18;
private final int NUM_COLS = 18;
private final int NUM_MINES = 40;
// STATES
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
// IMAGES
PImage buttonImage,
       pressedButtonImage,
       mineImage,
       redMineImage,
       flagImage,
       oneImage,
       twoImage,
       threeImage,
       fourImage,
       fiveImage,
       sixImage,
       sevenImage,
       eightImage;


void setup () {
  size(560, 560);
  textAlign(CENTER,CENTER);

  // Initialize images
  buttonImage = loadImage("https://drive.google.com/uc?export=view&id=1qQHhxcg6CS2q1Ez_7U3V6yJBPaBy-a0v", "png");
  pressedButtonImage = loadImage("https://drive.google.com/uc?export=view&id=1mdblOTE3YiCDGsXWG7J-6VEssSgykUzM", "png");
  mineImage = loadImage("https://drive.google.com/uc?export=view&id=146PpNwOqit2sgrbD7vPMgIuvrACjQJpX", "png");
  redMineImage = loadImage("https://drive.google.com/uc?export=view&id=1NxpTCO0Rzu6NpgkBxA9wfNu6xqK5V7eZ", "png");
  flagImage = loadImage("https://drive.google.com/uc?export=view&id=1lvfIs11J9i4j-dE8dowdhxAcxs07HOHp", "png");
  oneImage = loadImage("https://drive.google.com/uc?export=view&id=1dnrIIzY2IOfVJepbLwHNAyS0iV9htviL", "png");
  twoImage = loadImage("https://drive.google.com/uc?export=view&id=1slx93DGW84fpmVRfmTT7z3PCt0Oi7MWI", "png");
  threeImage = loadImage("https://drive.google.com/uc?export=view&id=1i1m2HMhwqNyrjReR7o8HHlfHPN0Xlvcq", "png");
  fourImage = loadImage("https://drive.google.com/uc?export=view&id=1oRxC93zlO8BtTqLq6pySjTgO9j9zbg-d", "png");
  fiveImage = loadImage("https://drive.google.com/uc?export=view&id=17RD74oq232NBPL0ZogMe4bn7kp1kuRIz", "png");
  sixImage = loadImage("https://drive.google.com/uc?export=view&id=1YbnFlLTx3PNNtS5ugTtG7vuFx1uz6VWi", "png");
  sevenImage = loadImage("https://drive.google.com/uc?export=view&id=1bcTUtcPAfrHG24_1rnXcvOY3iBD-VA1r", "png");
  eightImage = loadImage("https://drive.google.com/uc?export=view&id=1mghED4ys8o-NTFLOIU__LaWb-sQuuvc4", "png");
  
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
  
  setMines();
}


public void setMines() {
  int minesCount = 0;
  while(minesCount < NUM_MINES) {
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    MSButton target = buttons[r][c];

    if(!mines.contains(target)) {
      mines.add(target);
      minesCount++;
    }
  }
}


public void draw () {
  background(200);
  if(isWon() == true)
    displayWinningMessage();
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
  for(MSButton mine : mines) {
    mine.click();
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
  private boolean clicked, flagged;
  private boolean firstMine = false; // The first mine that is clicked, should be red
  private String myLabel;
  
  public MSButton (int row, int col) {
    width = 560.0 / NUM_COLS;
    height = 560.0 / NUM_ROWS;
    myRow = row;
    myCol = col; 
    x = myCol*width;
    y = myRow*height;
    myLabel = "";
    flagged = clicked = false;
    Interactive.add(this); // register it with the manager
  }

  // called by manager
  public void mousePressed() {
    if(!gameOver) {
      if(mouseButton == RIGHT) {
        flagged = !flagged;
      }
      else if(!flagged) {
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
      image(flagImage, x, y, width, height);
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
}
