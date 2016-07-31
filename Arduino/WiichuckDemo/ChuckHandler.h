#pragma once

class ChuckHandler {
    public:
    virtual void handle(int joyx, int joyy, int accx, int accy, int accz, int cbut, int zbut);
};
