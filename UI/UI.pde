import beads.*;
import javax.sound.sampled.Clip;
import javax.sound.sampled.AudioSystem;
import javax.sound.sampled.AudioInputStream;
import processing.serial.*;

String sourceFile;
PImage img;  
AudioContext ac;
SamplePlayer sp;
Gain g;
Glide gainValue;
Serial port;

void setup(){
  
  //window
  size(300,450);
  
  //image
  img = loadImage("treeswallow.jpg");
  
  //port for Arduino
  port = new Serial(this, "/dev/tty.usbmodem1431", 9600);  

  //audio
  ac = new AudioContext();
  sourceFile = sketchPath("") + "swallowSound.wav";
  try {
    sp =  new SamplePlayer(ac, new Sample(sourceFile));
  }
  catch(Exception e){
    print("Error" + e.toString());
  }
  
  //allows multiple plays
  sp.setKillOnEnd(false);
  
  //volume
  gainValue = new Glide(ac, 0.0, 20);
  g = new Gain(ac, 1, gainValue);
  
  g.addInput(sp); // connect the SamplePlayer to the Gain
  
  ac.out.addInput(g); // connect the Gain to the AudioContext
  ac.start(); // begin audio processing
}

void draw(){
  background(0);
  image(img,10,20,90,60);
  while (port.available() > 0) {
    char inByte = port.readChar();
    if(inByte == 'f')
    {
      // set the gain based on mouse position
       gainValue.setValue(0.636);
      // move the playback pointer to the first loop point (0.0)
       sp.setToLoopStart();
       sp.start(); // play the audio file
       
       tint(0,200,255);
       image(img,10,20,90,60);
    }
  }
}
