#include <Keypad.h>   //use the Keypad libraries

const byte ROWS = 4; //four rows
const byte COLS = 4; //four columns

//define the symbols on the buttons of the keypads
char hexaKeys[ROWS][COLS] = 
{
  { 
    'A','B','C','D'      }
  ,
  { 
    'E','F','G','H'      }
  ,
  { 
    'I','J','K','L'      }
  ,
  { 
    'M','N','O','P'      }
};
byte rowPins[ROWS] = { 2, 3, 4, 5}; //connect to the row pinouts of the keypad
byte colPins[COLS] = { 6, 7, 8, 9}; //connect to the column pinouts of the keypad

//initialize an instance of class NewKeypad
Keypad customKeypad = Keypad( makeKeymap(hexaKeys), rowPins, colPins, ROWS, COLS); 

void setup()
{
  Serial.begin(9600);
}

void loop()
{
  readKey();
  delay(100);
}

void readKey()
{
  char customKey = customKeypad.getKey(); //get the key value
  if(customKey)
    Serial.println(customKey);
  delay(100);
}
