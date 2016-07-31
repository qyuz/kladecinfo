#include "ChuckHandler.h"
#include "wiring_private.h"
#include "D:\micro\workspace\hood\hardware\HID\avr\cores\hid\USB-Core\Gamepad.h"

class LeftDpad : public ChuckHandler {
    private:
        const int DEVIATION_TRIGGER = 37;
    public:
    void handle(int joyx, int joyy, int accx, int accy, int accz, int cbut, int zbut) {
        uint8_t dPad1 = GAMEPAD_DPAD_CENTERED;
        boolean joyUp, joyRight, joyDown, joyLeft;

        joyUp = joyy > 125 + DEVIATION_TRIGGER;
        joyDown = joyy < 125 - DEVIATION_TRIGGER;
        joyRight = joyx > 132 + DEVIATION_TRIGGER;
        joyLeft = joyx < 132 - DEVIATION_TRIGGER;
        if (joyUp == true && joyRight == true) {
           dPad1 = GAMEPAD_DPAD_UP_RIGHT;
        } else if (joyDown && joyRight) {
           dPad1 = GAMEPAD_DPAD_DOWN_RIGHT;
        } else if (joyDown && joyLeft) {
           dPad1 = GAMEPAD_DPAD_DOWN_LEFT;
        } else if (joyUp && joyLeft) {
           dPad1 = GAMEPAD_DPAD_UP_LEFT;
        } else if (joyUp) {
           dPad1 = GAMEPAD_DPAD_UP;
        } else if (joyRight) {
           dPad1 = GAMEPAD_DPAD_RIGHT;
        } else if (joyDown) {
           dPad1 = GAMEPAD_DPAD_DOWN;
        } else if (joyLeft) {
           dPad1 = GAMEPAD_DPAD_LEFT;
        }
        Gamepad.dPad2(dPad1);

        if (cbut == 1) {
          Gamepad.press(1);
        } else {
          Gamepad.release(1);
        }
        if (zbut == 1) {
          Gamepad.press(2);
        } else {
          Gamepad.release(2);
        }
        Gamepad.write();
    }
};
