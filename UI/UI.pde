import beads.*;
import processing.sound.*;
import processing.serial.*;
import java.util.HashMap;

Serial port;
final int size = 200;

Bird selectedBird = null;
float duration = 0.0;
boolean needRefresh = false;

class Bird{
  
  private PImage image;
  private SoundFile call;
  private int xCoor;
  private int yCoor;
  private int sizeX;
  private int sizeY;
  
  Bird(String img, String soundFile, int x, int y)
  {
    image = loadImage(img);
    call = new SoundFile(UI.this, soundFile);
    xCoor = x;
    yCoor = y;
  }
  
  public void drawOnScreen() { image(image, xCoor, yCoor, size, size); }
  
  public void buttonPress()
  { 
    needRefresh = true;
    duration = call.duration();
    selectedBird = this;
    
    //orange outline around selected bird
    fill(204, 102, 0);
    rect(xCoor-10, yCoor-10, size+20, size+20, 7);
    drawOnScreen();
    
    //play the bird call
    call.play();
  }
}

//stores all bird instances
Bird birds[];
HashMap<Character, Bird> buttonToBird = new HashMap<Character, Bird>();

void setup()
{
  //window size
  fullScreen();
  
  //creating the birds
  //row 1
  Bird grayCatBird = new Bird("grayCatBird.jpg", "GrayCatbird.wav", 10, 20); 
  Bird osprey = new Bird("osprey.jpg", "Osprey.wav", 413, 20);
  Bird mourningDove = new Bird("MourningDove.jpg", "Mourning Dove.wav", 816, 20);
  Bird redWingedBlackBird = new Bird("redWingedBlackBird.jpg", "Red-winged blackbird.wav", 1219, 20);
  
  //row 2
  Bird blackCappedChickadee = new Bird("BlackCappedChickadee.jpg", "chickadee.wav", 10, 240); 
  Bird blueJay = new Bird("BlueJay.jpg", "blueJay.wav", 413, 240);
  Bird canadaGoose = new Bird("CanadaGoose.jpg", "canadaGoose.wav", 816, 240);
  Bird downyWoodpecker = new Bird("DownyWoodpecker.jpg", "woodpecker.wav", 1219, 240);
  
  //row 3
  Bird easternScreenOwl = new Bird("EasternScreenOwl.jpg", "owl.wav", 10, 460); 
  Bird easternTowhee = new Bird("EasternTowhee.jpg", "towhee.wav", 413, 460);
  Bird mallard = new Bird("Mallard.jpg", "mallard.wav", 816, 460);
  Bird northernCardinal = new Bird("NorthernCardinal.jpg", "cardinal.wav", 1219, 460);
  
  //row 4
  Bird songSparrow = new Bird("SongSparrow.jpg", "sparrow.wav", 10, 680); 
  Bird turkey = new Bird("Turkey.jpg", "turkey.wav", 413, 680);
  Bird yellowWarbler = new Bird("YellowWarbler.jpg", "warbler.wav", 816, 680);
  Bird redBreastedNuthatch = new Bird("redBreastedNuthatch.jpg", "nuthatch.wav", 1219, 680);
  
  birds = new Bird[]{grayCatBird, osprey, mourningDove, redWingedBlackBird,
                     blackCappedChickadee, blueJay, canadaGoose, downyWoodpecker,
                     easternScreenOwl, easternTowhee, mallard, northernCardinal,
                     songSparrow, turkey, yellowWarbler, redBreastedNuthatch};
  char letter = 'A';
  for (int i = 0; i < birds.length; ++i)
  {
    buttonToBird.put(letter, birds[i]);
    ++letter;
  }
  
  //port for Arduino
  port = new Serial(this, "/dev/tty.usbmodem1431", 9600);
  
  //display all the birds 
  background(0);
  for(int i = 0; i < birds.length; ++i)
    birds[i].drawOnScreen();
}

void draw(){
  
  //a bird button has already been pressed
  if(duration > 0)
    duration -= 0.1;
  if(duration < 0 && needRefresh)
  {
    //draw the images again
    background(0);
    for(int i = 0; i < birds.length; ++i)
      birds[i].drawOnScreen();
    needRefresh = false;
    
    //ignore any button presses during an existing bird call
    port.clear();
  }
  
  else
  {
    while (port.available() > 0 && !needRefresh)
    {
      //recieve button presses
      char inByte = port.readChar();
      Bird selectedBird = buttonToBird.get(inByte);
      if(selectedBird != null)
        selectedBird.buttonPress();
    }
  }
  delay(100);
}
