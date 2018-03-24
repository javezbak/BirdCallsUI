void setup() {
  pinMode(11, INPUT); 
  pinMode(12, OUTPUT); 

  Serial.begin(9600);
}

void loop() {
  if(digitalRead(11) == HIGH)
  {
    Serial.print("f");
  }
  delay(200);
}
