// libraries
// in "import Library > Manage Libraries" search for "The MidiBus"
import themidibus.*; //Import the library

// midi bus
MidiBus midi_bus;
int channel = 0;


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
  // to set control value in Helm with "Learn MIDI Assignement" change control number
  
  // control 1
  int control_number = 1; // change here!
  int control = int(map(mouseX, 0, width, 0, 127));
  midi_bus.sendControllerChange(channel, control_number, control); // Send a controllerChange
  

}
