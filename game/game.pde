/* 
Conway's game of life...
 
Rules:
5. Vichniac Vote Rule:
A new cell is alive if the total number of alive neighbours in its neighborhood 
grid is four, six, seven, eight, or nine, and the new cell is dead if the 
total number of alive neighbours is zero, one, two, three, or five. 

Alive = 1
Dead = 0

Instructions:
* Press SPACE BAR to pause and change the cell's values with the mouse 
* On pause, click to activate/deactivate cells 
* Press R to randomly reset the cells' grid 
* Press C to clear the cells' grid 

Author: Joan Soler-Adillon
Source: https://processing.org/examples/gameoflife.html
Modifications by: Maria Camila Remolina Gutierrez
*/

// Size of cells
int cellSize = 10;

// How likely for a cell to be alive at start (in percentage)
float probabilityOfAliveAtStart = 15;

// Variables for timer
int interval = 100;
int lastRecordedTime = 0;

// Colors for active/inactive cells
color alive = color(0, 200, 0);
color dead = color(0);

// Array of cells
int[][] cells; 
// Buffer to record the state of the cells and use this while changing the others in the interations
int[][] cellsBuffer; 

// Pause
boolean pause = false;

void setup() {
  size (1280, 720);

  // Instantiate arrays 
  cells = new int[width/cellSize][height/cellSize];
  cellsBuffer = new int[width/cellSize][height/cellSize];

  // This stroke will draw the background grid
  stroke(48);
  noSmooth();

  // Initialization of cells
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      float state = random (100);
      if (state > probabilityOfAliveAtStart) { 
        state = 0;
      }
      else {
        state = 1;
      }
      cells[x][y] = int(state); // Save state of each cell
    }
  }
  background(0); // Fill in black in case cells don't cover all the windows
}


void draw() {

  //Draw grid
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      if (cells[x][y]==1) {
        fill(alive); // If alive
      }
      else {
        fill(dead); // If dead
      }
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  // Iterate if timer ticks
  if (millis()-lastRecordedTime>interval) {
    if (!pause) {
      iteration();
      lastRecordedTime = millis();
    }
  }

  // Create  new cells manually on pause
  if (pause && mousePressed) {
    // Map and avoid out of bound errors
    int xCellOver = int(map(mouseX, 0, width, 0, width/cellSize));
    xCellOver = constrain(xCellOver, 0, width/cellSize-1);
    int yCellOver = int(map(mouseY, 0, height, 0, height/cellSize));
    yCellOver = constrain(yCellOver, 0, height/cellSize-1);

    // Check against cells in buffer
    if (cellsBuffer[xCellOver][yCellOver]==1) { // Cell is alive
      cells[xCellOver][yCellOver]=0; // Kill
      fill(dead); // Fill with kill color
    }
    else { // Cell is dead
      cells[xCellOver][yCellOver]=1; // Make alive
      fill(alive); // Fill alive color
    }
  } 
  else if (pause && !mousePressed) { // And then save to buffer once mouse goes up
    // Save cells to buffer (so we opeate with one array keeping the other intact)
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cellsBuffer[x][y] = cells[x][y];
      }
    }
  }
}


void iteration() { // When the clock ticks
  // Save cells to buffer (so we operate with one array keeping the other intact)
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      cellsBuffer[x][y] = cells[x][y];
    }
  }

  // Visit each cell:
  for (int x=0; x<width/cellSize; x++) {
    for (int y=0; y<height/cellSize; y++) {
      // And visit all the neighbours of each cell
      int neighbours = 0; // We'll count the neighbours
      for (int xx=x-1; xx<=x+1;xx++) {
        for (int yy=y-1; yy<=y+1;yy++) {  
          if (((xx>=0)&&(xx<width/cellSize))&&((yy>=0)&&(yy<height/cellSize))) { // Make sure you are not out of bounds
            if (!((xx==x)&&(yy==y))) { // Make sure to to check against self
              if (cellsBuffer[xx][yy]==1){
                neighbours ++; // Check alive neighbours and count them
              }
            } // End of if
          } // End of if
        } // End of yy loop
      } //End of xx loop
      // We've checked the neigbours: apply rules!
      // A new cell is alive if the total number of alive neighbours in its neighborhood 
      // grid is four, six, seven, eight, or nine, and the new cell is dead if the 
      // total number of alive neighbours is zero, one, two, three, or five.= 
      // Alive = 1   Dead = 0  
      int nm = neighbours + cellsBuffer[x][y];
      if (nm == 4 || nm >= 6) { // 4, 6, 7, 8, 9 alive => majority alive => be alive
        cells[x][y] = 1; 
      } 
      else { // 0, 1, 2, 3, 5 alive => majority dead => be dead
        cells[x][y] = 0; 
      } // End of if
    } // End of y loop
  } // End of x loop
} // End of function


void keyPressed() {
  if (key=='r' || key == 'R') {
    // Restart: reinitialization of cells
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        float state = random (100);
        if (state > probabilityOfAliveAtStart) {
          state = 0;
        }
        else {
          state = 1;
        }
        cells[x][y] = int(state); // Save state of each cell
      }
    }
  }
  if (key==' ') { // On/off of pause
    pause = !pause;
  }
  if (key=='c' || key == 'C') { // Clear all
    for (int x=0; x<width/cellSize; x++) {
      for (int y=0; y<height/cellSize; y++) {
        cells[x][y] = 0; // Save all to zero
      }
    }
  }
}