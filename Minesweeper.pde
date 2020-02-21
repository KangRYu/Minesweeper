import de.bezier.guido.*;
// CONSTANTS
private final int NUM_ROWS = 16;
private final int NUM_COLS = 16;
private final float scale = 1; // The scale of all the elements on screen
private final int NUM_MINES = 20;
// STATES
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
// IMAGES
PImage buttonImage, pressedButtonImage, mineImage;

void settings() {
  size((int)(NUM_ROWS * 26 * scale), (int)(NUM_COLS * 26 * scale));
}

void setup () {
  textAlign(CENTER,CENTER);

  // Initialize images
  buttonImage = loadImage("https://drive.google.com/uc?export=view&id=1qQHhxcg6CS2q1Ez_7U3V6yJBPaBy-a0v", "png");
  pressedButtonImage = loadImage("https://drive.google.com/uc?export=view&id=1mdblOTE3YiCDGsXWG7J-6VEssSgykUzM", "png");
  
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
  //your code here
  return false;
}


public void displayLosingMessage() {
  gameOver = true;
  for(MSButton mine : mines) {
    mine.click();
  }
  text("YOU ARE A LOSER", width/2, height/2);
}


public void displayWinningMessage() {
  gameOver = true;
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
  private String myLabel;
  
  public MSButton (int row, int col) {
    width = 26 * scale;
    height = 26 * scale;
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
      clicked = true;
      if(mouseButton == RIGHT) {
        flagged = !flagged;
        if(flagged == false) {
          clicked = false;
        }
      }
      else if(mines.contains(this)) {
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

  public void draw () {  
    if (flagged) {
      fill(20);
      stroke(0);
    }
    else if(clicked && mines.contains(this)) {
      fill(255, 0, 0);
      stroke(235, 0, 0);
    }
    else if(clicked) {
      fill(200);
      stroke(180);
      image(pressedButtonImage, x, y, width, height);
    }
    else {
      fill(100);
      stroke(80);
      image(buttonImage, x, y, width, height);
    } 
    //rect(x, y, width, height);
    fill(0);
    text(myLabel,x+width/2,y+height/2);
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
