import de.bezier.guido.*;
// CONSTANTS
private final int NUM_ROWS = 5;
private final int NUM_COLS = 5;

private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList<MSButton> mines; //ArrayList of just the minesweeper buttons that are mined


void setup () {
    size(400, 400);
    textAlign(CENTER,CENTER);
    
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
    int r = (int)(Math.random() * NUM_ROWS);
    int c = (int)(Math.random() * NUM_COLS);
    MSButton target = buttons[r][c];
    println(mines);

    if(!mines.contains(target)) {
        mines.add(target);
    }
}


public void draw () {
    background( 0 );
    if(isWon() == true)
        displayWinningMessage();
}


public boolean isWon() {
    //your code here
    return false;
}


public void displayLosingMessage() {
    //your code here
}


public void displayWinningMessage() {
    //your code here
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
    //your code here
    return numMines;
}


public class MSButton {
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton (int row, int col) {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () {
        clicked = true;
        //your code here
    }

    public void draw () {    
        if (flagged)
            fill(0);
        else if(clicked && mines.contains(this)) 
            fill(255,0,0);
        else if(clicked)
            fill(200);
        else 
            fill(100);

        rect(x, y, width, height);
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
}
