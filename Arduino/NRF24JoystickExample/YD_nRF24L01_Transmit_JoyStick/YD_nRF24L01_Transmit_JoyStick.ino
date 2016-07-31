/* YourDuinoStarter Example: nRF24L01 Transmit Joystick values
 - WHAT IT DOES: Reads Analog values on A0, A1 and transmits
   them over a nRF24L01 Radio Link to another transceiver.
 - SEE the comments after "//" on each line below
 - CONNECTIONS: nRF24L01 Modules See:
 http://arduino-info.wikispaces.com/Nrf24L01-2.4GHz-HowTo
RF Module Leonardo
   1 - GND
   2 - VCC 3.3V !!! NOT 5V
   3 - CE to Arduino pin 9
   4 - CSN to Arduino pin 10(NOT SURE BUT WORKS)
   5 - SCK to Arduino ICSP pin 3
   6 - MOSI to Arduino ICSP pin 4
   7 - MISO to Arduino ICSP pin 1
   8 - UNUSED
   - 
   Analog Joystick or two 10K potentiometers:
   GND to Arduino GND
   VCC to Arduino +5V
   X Pot to Arduino A0
   Y Pot to Arduino A1
   
 - V1.00 11/26/13
   Based on examples at http://www.bajdi.com/
   Questions: terry@yourduino.com */

/*-----( Import needed libraries )-----*/
#include <SPI.h>
#include <nRF24L01.h>
#include <RF24.h>
/*-----( Declare Constants and Pin Numbers )-----*/
#define CE_PIN   9
#define CSN_PIN 10

// NOTE: the "LL" at the end of the constant is "LongLong" type
const uint64_t pipe = 0xE8E8F0F0E1LL; // Define the transmit pipe


/*-----( Declare objects )-----*/
RF24 radio(CE_PIN, CSN_PIN); // Create a Radio
/*-----( Declare Variables )-----*/
int joystick[2];  // 2 element array holding Joystick readings
int i = 0;

void setup()   /****** SETUP: RUNS ONCE ******/
{
  Serial.begin(9600);
  radio.begin();
  radio.openWritingPipe(pipe);
}//--(end setup )---


void loop()   /****** LOOP: RUNS CONSTANTLY ******/
{
  joystick[0] = i++;
  joystick[1] = i++;
  
  radio.write( joystick, sizeof(joystick) );

  
  delay(3);

}//--(end main loop )---

/*-----( Declare User-written Functions )-----*/

//NONE
//*********( THE END )***********

