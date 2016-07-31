class TouchGrid
{
public:
    TouchGrid();
    TouchGrid(int rowCount, int colCount);
    TouchGrid(int rowCount, int colCount, TSPoint frstCenter, TSPoint lstCenter);

    static const int X = 0;
    static const int Y = 1;

    int segments[2], cellDim[2], gridStart[2], gridEnd[2];

    void calculateGridDimensions(TSPoint frstCenter, TSPoint lstCenter);
    TSPoint getCell(TSPoint point);
    void printDimensions(char * name, int X, int Y);

private:
    int calculateSegment(int touched, int axis);
};
