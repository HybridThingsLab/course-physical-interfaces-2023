// libraries
// in "import Library > Manage Libraries" search for "The MidiBus"
import themidibus.*; //Import the library

// midi bus
MidiBus midi_bus;
int channel = 0;
int pitch = 0;
int velocity = 0;


// setup
void setup() {

  // size canvas
  size(400, 400);

  // list all available Midi devices
  MidiBus.list();

  // init midi bus
  //                    Parent In Out
  //                      |    |   |
  midi_bus = new MidiBus(this, -1, 2); // -1 means no input, second number is ID from list in console
}

// draw
void draw() {

  // background
  background(0);

  // control value 
  // to set control value in Helm with "Learn MIDI Assignement" use ""
  
  // control 1
  int control1 = int(map(mouseX, 0, width, 0, 127));
  midi_bus.sendControllerChange(channel, 1, control1); // Send a controllerChange
  
  // control 2
  int control2 = int(map(mouseY, 0, height, 0, 127));
  midi_bus.sendControllerChange(channel, 2, control2); // Send a controllerChange

}

// mouse interaction
void mousePressed() {

  // pitch + velocity
  pitch = int(map(mouseX, 0, width, 0, 127));
  velocity = int(map(mouseY, 0, height, 0, 127));

  // send note
  midi_bus.sendNoteOn(channel, pitch, velocity);
}

void mouseReleased() {

  // send note off
  midi_bus.sendNoteOff(channel, pitch, 0);
}
