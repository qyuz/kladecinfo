#include <TouchScreen.h>
#include <stdint.h>

#define YP A2
#define XM A3
#define YM 8
#define XP 9

const int X = 0;
const int Y = 1;
const int ROW = 0;
const int COL = 1;
const int ROW_COUNT = 9;
const int COL_COUNT = 5;

int cellDim[2], gridStart[2], touchedCoords[2], touchedCell[2];
unsigned long time;

void cellDimensions(int frstCenter[2], int scndCenter[2], int cellDim[2]) {
    cellDim[X] = (scndCenter[X] - frstCenter[X]) / (ROW_COUNT - 1);
    cellDim[Y] = (scndCenter[Y] - frstCenter[Y]) / (COL_COUNT - 1);
}

void gridDimensions(int frstCenter[2], int scndCenter[2], int cellDim[2], int gridStart[2], int gridEnd[2]) {
    gridStart[X] = frstCenter[X] - cellDim[X] / 2;
    gridStart[Y] = frstCenter[Y] - cellDim[Y] / 2;
    gridEnd[X] = scndCenter[X] + cellDim[X] / 2;
    gridEnd[Y] = scndCenter[Y] + cellDim[Y] / 2;
}

int findTouchedRow(int touchedCoords[2], int gridStart[2], int cellDim[2]) {
    int gridEndY = gridStart[Y] + cellDim[Y];
    int gridEndX = gridStart[X];
    for(int i = 0; i < ROW_COUNT; i++) {
        gridEndX = gridEndX + cellDim[X];
        if(gridStart[X] <= touchedCoords[X] 
            && gridStart[Y] <= touchedCoords[Y] 
            && gridEndX >= touchedCoords[X]
            && gridEndY >= touchedCoords[Y]) {
            return i;
        }
    }
    return -1;
}

void findTouchedCell(int touchedCoords[2], int gridStart[2], int cellDim[2], int touchedCell[2]) {
    int rowStart[2] = { gridStart[X], gridStart[Y] };
    for(int i = 0; i < COL_COUNT; i++) {
        int touchedRow = findTouchedRow(touchedCoords, rowStart, cellDim);
        Serial.print("--------------"); Serial.println(i);
        Serial.println(rowStart[X]);
        Serial.println(rowStart[Y]);
        if(touchedRow > -1) {
            touchedCell[ROW] = touchedRow;
            touchedCell[COL] = i;
            return;
        }
        rowStart[Y] = rowStart[Y] + cellDim[Y];
    }
    touchedCell[ROW] = -1;
    touchedCell[COL] = -1;
}

void start() {
    time = millis();
    
    int frstCenter[2] = { 115, 200 };
    int scndCenter[2] = { 925, 730 }; 
    int gridEnd[2];
    
    //manual start
    //cellDim[X] = 98;
    //cellDim[Y] = 123;
    //gridStart[X] = 80;
    //gridStart[Y] = 155;
    //gridEnd[X] = 960;
    //gridEnd[Y] = 770;
    //manual end
    
    touchedCoords[X] = 925;
    touchedCoords[Y] = 730;
    
    //auto start
    cellDimensions(frstCenter, scndCenter, cellDim);
    gridDimensions(frstCenter, scndCenter, cellDim, gridStart, gridEnd);
    //auto end
    Serial.print("cellDim[X]: "); Serial.println(cellDim[X]);
    Serial.print("cellDim[Y]: "); Serial.println(cellDim[Y]);
    Serial.print("gridStart[X]: "); Serial.println(gridStart[X]);
    Serial.print("gridStart[Y]: "); Serial.println(gridStart[Y]);
    Serial.print("gridEnd[X]: "); Serial.println(gridEnd[X]);
    Serial.print("gridEnd[Y]: "); Serial.println(gridEnd[Y]);
    Serial.print("touchedCoords: "); Serial.println(findTouchedRow(touchedCoords, gridStart, cellDim));
    findTouchedCell(touchedCoords, gridStart, cellDim, touchedCell);
    Serial.print("touchedRow: "); Serial.println(touchedCell[ROW]); 
    Serial.print("touchedCol: "); Serial.println(touchedCell[COL]);
    
    //prevent running keyboard actions during initialization
    touchedCell[ROW] = -1;
    touchedCell[COL] = -1;
}

void setup(void) {
  delay(5000);
  start();
  Keyboard.begin();
  Serial.begin(9600);
}

char *action[5] = { "Hello, ", "Goodbye, ", "Your name is ", "You should peel a melon, ", "Drink some water, "};
char *name[9] = { "Master Yoda", "Chewbacca", "Jack O'Neill", "THOR", "Heisenberg", "Andron", "Edward", "Arthur", "Envy" };

TouchScreen ts = TouchScreen(XP, YP, XM, YM, 836);
void loop(void) {
  // a point object holds x y and z coordinates
  TSPoint p = ts.getPoint();
  
  // we have some minimum pressure we consider 'valid'
  // pressure of 0 means no pressing!
  if (p.z > ts.pressureThreshhold) {
    Serial.print("X = "); Serial.print(p.x);
    Serial.print("\tY = "); Serial.print(p.y);
    Serial.print("\tPressure = "); Serial.println(p.z);
    touchedCoords[X] = p.x;
    touchedCoords[Y] = p.y;    
    findTouchedCell(touchedCoords, gridStart, cellDim, touchedCell);
    Serial.print("[touch down] [Row: "); Serial.print(touchedCell[ROW]); 
    Serial.print("] [Col: "); Serial.print(touchedCell[COL]); Serial.println("]");
    time = millis();
    delay(50);
  } else if((millis() - time) > 300 && touchedCell[ROW] > -1 && touchedCell[COL] > -1) {
    Serial.print("time: "); Serial.println(time);
    Serial.print("[touch up] [Row: "); Serial.print(touchedCell[ROW]); 
    Serial.print("] [Col: "); Serial.print(touchedCell[COL]); Serial.println("]");
    Keyboard.print(action[touchedCell[COL]]);
    Keyboard.println(name[touchedCell[ROW]]);
    touchedCell[COL] = -1;
    touchedCell[ROW] = -1;
    time = millis();
    delay(50);
  }
}

