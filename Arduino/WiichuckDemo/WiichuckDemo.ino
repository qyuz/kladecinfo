/*
 * WiiChuckDemo --
 *
 * 2008 Tod E. Kurt, http://thingm.com/
 *
 */

#include <Wire.h>
#include "nunchuck_funcs.h"
#include "LeftAnalog.cpp"
#include "LeftDpad.cpp"

int loop_cnt=0;
int joyx,joyy,accx,accy,accz,cbut,zbut;

LeftAnalog leftAnalog = LeftAnalog();
LeftDpad leftDpad = LeftDpad();

void setup() {
    pinMode(LED_BUILTIN, OUTPUT);
    Serial.println('Initing WiiCh');
    Serial.begin(19200);
    nunchuck_init(); // send the initilization handshake
    Gamepad.begin();
    Serial.print("WiiChuckDemo ready\n");
}

void loop() {
  static int hidMode = 0, prevHidMode = hidMode;
  static boolean changeModeDown = false;
  if( loop_cnt > 15 ) { // every n msecs get new data
      loop_cnt = 0;

      nunchuck_get_data();
      Serial.print("mode: ");
      Serial.print(hidMode, DEC);
      Serial.print('\t');
      nunchuck_print_data();

      joyx = nunchuck_joyx();
      joyy = nunchuck_joyy();
      cbut = nunchuck_cbutton();
      zbut = nunchuck_zbutton();
      accx  = nunchuck_accelx(); // ranges from approx 70 - 182
      accy  = nunchuck_accely(); // ranges from approx 65 - 173
      accz  = nunchuck_accelz();

      if (hidMode == 0) {
        digitalWrite(LED_BUILTIN, LOW);
      } else if (hidMode == 1) {
        digitalWrite(LED_BUILTIN, HIGH);
      }

      if (accy <= 90 || changeModeDown) {
        if (zbut == 1) {
          if (!changeModeDown) {
             changeModeDown = true;
             hidMode++;
             if (hidMode > 1) {
               hidMode = 0;
             }
          }
          return;
        } else {
          changeModeDown = false;
        }
      }

      if (prevHidMode != hidMode) {
        prevHidMode = hidMode;
        Gamepad.releaseAll();
      }

      if (hidMode == 0) {
        leftAnalog.handle(joyx, joyy, accx, accy, accz, cbut, zbut);
      } else if (hidMode == 1) {
        leftDpad.handle(joyx, joyy, accx, accy, accz, cbut, zbut);
      }
  }
  loop_cnt++;
  delay(1);
}

