import de.bezier.guido.*;
private boolean nahh = false;
private final static int NUM_ROWS = 20;
private final static int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    // make the manager
    Interactive.make( this );
    
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
   
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++){
        buttons[i][j] = new MSButton(i,j);
      }
    }
    for(int i = 0; i < 30; i++){
    setMines();
    }
}
public void setMines()
{
    int row = (int)(Math.random()*NUM_ROWS);
    int col = (int)(Math.random()*NUM_COLS);
    if(!mines.contains(buttons[row][col])){
     mines.add(buttons[row][col]); 
    }
}

public void draw ()
{
    background( 255 );
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int freeSpaces = 0;
    for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            if (!buttons[i][j].clicked && !mines.contains(buttons[i][j])) {
                freeSpaces++;
            }
        }
    }
    return freeSpaces == 0;
}
public void displayLosingMessage()
{ 
    for (int i = 0; i < mines.size(); i++) {
        MSButton minesss = mines.get(i);
        if (!minesss.isFlagged()) {
            minesss.setLabel("Bomb");
            minesss.clicked = true;
        }
    }
    nahh = true;
}
public void displayWinningMessage()
{
   for (int i = 0; i < NUM_ROWS; i++) {
        for (int j = 0; j < NUM_COLS; j++) {
            MSButton current = buttons[i][j];
            if (mines.contains(current)) {
                if (!current.isFlagged()) {
                    current.setLabel("Bomba");
                }
            } else {
                // Count and display the number of adjacent mines for non-mine buttons
                int adjacent = countMines(i, j);
                if (adjacent > 0 && !current.isFlagged()) {
                    current.setLabel(Integer.toString(adjacent));
                }
            }
        }
    }
}
public boolean isValid(int row, int col)
{
  if(row < NUM_ROWS && row >= 0 && col < NUM_COLS && col >= 0)
  return true;
  else
    return false;
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int i = row-1; i <= row + 1; i++){
    for(int j = col-1; j <= col + 1; j++){
      if(i != row || j != col){
      if((isValid(i,j) == true && mines.contains(buttons[i][j]))){
        numMines++;
      }
      }
    }
  }
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
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
    public void mousePressed () 
    {
      if(!nahh){
        clicked = true;
        if(mouseButton == RIGHT){
          if(flagged == true)
          flagged = false;
          else{
          flagged = true;
          clicked = false;
          }
        }
        else if(mines.contains(this)){
        displayLosingMessage();
        }
        else if(countMines(myRow, myCol) > 0){
          setLabel(countMines(myRow, myCol));
        }
        else{
          for(int r = myRow-1; r <= myRow+1; r++){
            for(int c = myCol-1; c <= myCol+1; c++){
              if(isValid(r,c) == true && !buttons[r][c].clicked && !buttons[r][c].flagged)
              buttons[r][c].mousePressed();
            }
          }
            }
      }
        }
    public void draw () 
    {    
      stroke(219,40,93);
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill(255);
        else 
            fill(255,182,193);

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
}

