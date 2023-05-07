// libraries
// in "import Library > Manage Libraries" search for "oscP5"
import oscP5.*;
import netP5.*;

// libraries
// in "import Library > Manage Libraries" search for "The MidiBus"
import themidibus.*; //Import the library


// font
PFont font;

// osc
OscP5 oscP5;
NetAddress remoteLocation;
int recv_port = 9999;
int send_port = 9998;

// midi bus
MidiBus midi_bus;
int channel = 0;

Boolean note1_played = false;
Boolean note2_played = false;

// data sensors

// two capactive sensors
float[] data_sensors_capacitive = new float[2]; // sensor data come as integer and is converted to float when received
float[] smooth_data_sensors_capacitive = new float[2];
float smooth_factor = 0.5; // change here
float threshold_trigger_note = 1500.0; // values above this threshold will trigger a note


// viz data

// analog sensors
color[] colors = {color(255, 255, 0), color(0, 255, 255)};
String[] labels = {"sensor capacitive 1: ", "sensor capacitive 2: "};
float multiplier = 0.1;
int height_graph = 12;
int pos_x = 32;
int start_y = 100;
int offset_y = 80;

// setup
void setup() {

  // size canvas
  size(1200, 675);

  // framerate
  frameRate(60);

  // pixelDensity (if retina screen)
  pixelDensity(2);

  // font
  font = loadFont("IBMPlexMono-14.vlw");
  textFont(font);

  /* start oscP5, listening for incoming messages at port 9999 */
  oscP5 = new OscP5(this, recv_port);

  // remote device (Arduino Nano), where data is send to
  remoteLocation = new NetAddress("192.168.0.201", send_port);

  // listen to different messages
  oscP5.plug(this, "sensors_capacitive", "/sensors_capacitive");

  // list all available Midi devices
  MidiBus.list();

  // init midi bus
  //                    Parent In Out
  //                      |    |   |
  midi_bus = new MidiBus(this, -1, 2); // -1 means no input, second number is ID from list in console
}


// draw
void draw() {

  // background (color depends on value sensor digital)
  background(0);

  // MIDI

  // send note
  int pitch1 = 40; // midi note 1
  int pitch2 = 56; // midi note 2
  int velocity = 127;

  // note 1
  if (smooth_data_sensors_capacitive[0] >= threshold_trigger_note) {
    // note on (just one time)
    if (note1_played == false) {
      midi_bus.sendNoteOn(channel, pitch1, velocity);
      note1_played = true;
    }
  }
  if (smooth_data_sensors_capacitive[0] < threshold_trigger_note) {
    // note off
    midi_bus.sendNoteOff(channel, pitch1, 0);
    note1_played = false;
  }

  // note 2
  if (smooth_data_sensors_capacitive[1] >= threshold_trigger_note) {
    // note on (just one time)
    if (note2_played == false) {
      midi_bus.sendNoteOn(channel, pitch2, velocity);
      note2_played = true;
    }
  }
  if (smooth_data_sensors_capacitive[1] < threshold_trigger_note) {
    // note off
    midi_bus.sendNoteOff(channel, pitch2, 0);
    note2_played = false;
  }




  // data sensors

  // loop trough data of capacitive sensors
  for (int i=0; i<data_sensors_capacitive.length; i++) {

    // temporary pos y for visualization
    int temp_pos_y = start_y+offset_y*i;

    // smooth sensor values
    smooth_data_sensors_capacitive[i] = lerp(smooth_data_sensors_capacitive[i], data_sensors_capacitive[i], smooth_factor);

    // show values as text (three digits after '.')
    String value = nf(data_sensors_capacitive[i], 0, 3);
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(labels[i]+value, pos_x, temp_pos_y);

    // show values as bar (raw and smoothed data)
    noStroke();
    fill(colors[i]);
    // raw data
    rect(pos_x, temp_pos_y+height_graph*2, data_sensors_capacitive[i]*multiplier, height_graph);
    // smooth data
    rect(pos_x, temp_pos_y+height_graph*4, smooth_data_sensors_capacitive[i]*multiplier, height_graph);
  }
}

// OSC

// data sensors
public void sensors_capacitive(int v1, int v2) {
  // data
  data_sensors_capacitive[0] = float(v1);
  data_sensors_capacitive[1] = float(v2);
}
