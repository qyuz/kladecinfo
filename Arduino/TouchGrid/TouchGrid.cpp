#include "wiring_private.h"
#include "TouchScreen.h"
#include "TouchGrid.h"

TouchGrid::TouchGrid(int rowCount, int colCount)
{
    segments[X] = rowCount;
    segments[Y] = colCount;
}

TouchGrid::TouchGrid(int rowCount, int colCount, TSPoint frstCenter, TSPoint lstCenter)
{
    segments[X] = rowCount;
    segments[Y] = colCount;
    calculateGridDimensions(frstCenter, lstCenter);
}

void TouchGrid::calculateGridDimensions(TSPoint frstCenter, TSPoint lstCenter)
{
    cellDim[X] = (lstCenter.x - frstCenter.x) / (segments[X] - 1);
    cellDim[Y] = (lstCenter.y - frstCenter.y) / (segments[Y] - 1);
    gridStart[X] = frstCenter.x - cellDim[X] / 2;
    gridStart[Y] = frstCenter.y - cellDim[Y] / 2;
    gridEnd[X] = lstCenter.x + cellDim[X] / 2;
    gridEnd[Y] = lstCenter.y + cellDim[Y] / 2;
    printDimensions("Segments", segments[X], segments[Y]);
    printDimensions("CellDim", cellDim[X], cellDim[Y]);
    printDimensions("GridStart", gridStart[X], gridStart[Y]);
    printDimensions("GridEnd", gridEnd[X], gridEnd[Y]);
}

int TouchGrid::calculateSegment(int touched, int axis)
{
    if(touched < gridStart[axis] || touched > gridEnd[axis])
    {
        return -1;
    }
    int segmentStart = gridStart[axis], segmentEnd = gridStart[axis] + cellDim[axis];
    for(int i = 0; i < segments[axis]; i++)
    {
        if(touched >= segmentStart && touched <= segmentEnd)
        {
            return i;
        }
        else
        {
            segmentStart = segmentEnd;
            segmentEnd = segmentEnd + cellDim[axis];
        }
    }
    return -1;
};

TSPoint TouchGrid::getCell(TSPoint point)
{
    TSPoint cell = TSPoint(calculateSegment(point.x, X), calculateSegment(point.y, Y), 0);
    printDimensions("\tPoint", point.x, point.y);
    printDimensions("\tCell", cell.x, cell.y);
    return cell;
}

void TouchGrid::printDimensions(char * name, int x, int y)
{
    Serial.print(name);
    Serial.print("\tX: ");
    Serial.print(x);
    Serial.print("\tY: ");
    Serial.println(y);
}
