#include <TouchScreen.h>
#include <TouchGrid.h>
#include <stdint.h>

#define YP A2
#define XM A3
#define YM 8
#define XP 9

#define ROW_COUNT 9
#define COL_COUNT 5

char *action[5] = { "Hello, ", "Goodbye, ", "Your name is ", "You should peel a melon, ", "Drink some water, "};
char *name[9] = { "Master Yoda", "Chewbacca", "Jack O'Neill", "THOR", "Heisenberg", "Andron", "Edward", "Arthur", "Envy" };

unsigned long time;
TouchScreen ts = TouchScreen(XP, YP, XM, YM, 836);
TouchGrid tGrid = TouchGrid(ROW_COUNT, COL_COUNT);

void setup(void)
{
    delay(3000);
    Serial.begin(9600);
    time = millis();
    TSPoint frstCenter = TSPoint(115, 200, 0);
    TSPoint lstCenter = TSPoint(925, 730, 0);
    tGrid.calculateGridDimensions(frstCenter, lstCenter);
    /* test start */
    TSPoint first = TSPoint(100, 200, 0);
    TSPoint last = TSPoint(900, 700, 0);
    Serial.println("Test first");
    tGrid.getCell(first);
    Serial.println("Test last");
    tGrid.getCell(last);
    /* test end */
}

void loop(void)
{
    TSPoint p = ts.getPoint();
    static TSPoint cell = TSPoint(-1, -1, -1);
    if (p.z > ts.pressureThreshhold)
    {
        Serial.println("[Touch down]");
        cell = tGrid.getCell(p);
        time = millis();
        delay(50);
    }
    else if((millis() - time) > 300 && cell.x > -1 && cell.y > -1)
    {
        Serial.println("[Touch up]");
        tGrid.printDimensions("\tCell", cell.x, cell.y);
        Keyboard.print(action[cell.y]);
        Keyboard.println(name[cell.x]);
        cell.x = -1;
        cell.y = -1;
        time = millis();
        delay(50);
    }
}
