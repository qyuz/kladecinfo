#include "ChuckHandler.h"
#include "wiring_private.h"
#include "D:\micro\workspace\hood\hardware\HID\avr\cores\hid\USB-Core\Gamepad.h"

class LeftAnalog : public ChuckHandler {
    public:
    void handle(int joyx, int joyy, int accx, int accy, int accz, int cbut, int zbut) {
        if (joyx > 131 && joyx < 135) {
           Gamepad.xAxis(0);
        } else {
           Gamepad.xAxis(map(joyx, 35, 237, -32678, 32677));
        }
        if (joyy > 124 && joyy < 128) {
           Gamepad.yAxis(0);
        } else {
           Gamepad.yAxis(map(joyy, 27, 226, -32677, 32677) * -1);
        }
        if (cbut == 1) {
           Gamepad.press(3);
        } else {
           Gamepad.release(3);
        }
        if (zbut == 1) {
           Gamepad.press(4);
        } else {
           Gamepad.release(4);
        }
        Gamepad.write();
    }
};
