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

// imu (roll, pitch, yaw)
float[] data_imu = new float[3];
float[] smooth_data_imu = new float[3];
float smooth_factor_imu = 0.9; // change here

// data sensors

// two sensors (analogRead())
float[] data_sensors_analog = new float[2]; // sensor data come as integer and is converted to float when received
float[] smooth_data_sensors_analog = new float[2];
float smooth_factor_sensors_analog = 0.3; // change here

// two sensors (digitalRead())
int[] data_sensors_digital = new int[2];

// ultrasonic ranger (distance sensor)
int distance = 0;
float smooth_distance = 0.0;
float smooth_factor_distance = 0.5; // change here


// viz data

// IMU
color[] colors_imu = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};
String[] labels_imu = {"roll: ", "pitch: ", "yaw: "};
float multiplier_graph_imu = 2.0;
int height_graph_imu = 12;
int start_y_imu = 60;
int offset_y_imu = 80;

// analog sensors
color[] colors_sensors_analog = {color(255, 255, 0), color(0, 255, 255)};
String[] labels_sensors_analog = {"sensor analog 1: ", "sensor analog 2: "};
float multiplier_graph_sensors_analog = 0.3;
int height_graph_sensors_analog = 12;
int start_y_sensors_analog = 320;
int offset_y_sensors_analog = 80;

// digital sensors
String[] labels_sensors_digital = {"sensor digital 1: ", "sensor digital 2: "};
int size_rect_sensors_digital = 12;
int start_y_sensors_digital = 480;
int offset_y_sensors_digital = 48;

// ultrasonic ranger (distance sensor)
int height_graph_ultrasonic = 12;
int start_y_ultrasonic = 580;

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
  remoteLocation = new NetAddress("192.168.1.201", send_port);

  // listen to different messages
  oscP5.plug(this, "imu", "/imu");
  oscP5.plug(this, "sensors_analog", "/sensors_analog");
  oscP5.plug(this, "sensors_digital", "/sensors_digital");
  oscP5.plug(this, "distance", "/distance");

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
  if (data_sensors_digital[0] == 1) {
    // note on (just one time)
    if (note1_played == false) {
      midi_bus.sendNoteOn(channel, pitch1, velocity);
      note1_played = true;
    }
  }
  if (data_sensors_digital[0] == 0) {
    // note off
    midi_bus.sendNoteOff(channel, pitch1, 0);
    note1_played = false;
  }

  // note 2
  if (data_sensors_digital[1] == 1) {
    // note on (just one time)
    if (note2_played == false) {
      midi_bus.sendNoteOn(channel, pitch2, velocity);
      note2_played = true;
    }
  }
  if (data_sensors_digital[1] == 0) {
    // note off
    midi_bus.sendNoteOff(channel, pitch2, 0);
    note2_played = false;
  }

  // control value
  int control_value1 = int(map(smooth_data_sensors_analog[0], 0, 1023, 0, 127)); // smoothed value first sensor analog
  midi_bus.sendControllerChange(channel, 1, control_value1); // Send a controllerChange

  int control_value2 = int(map(smooth_data_sensors_analog[1], 0, 1023, 0, 127)); // smoothed value second sensor analog
  midi_bus.sendControllerChange(channel, 2, control_value2); // Send a controllerChange

  // IMU

  // loop trough data of IMU
  for (int i=0; i<data_imu.length; i++) {

    // temporary pos y for visualization
    int temp_pos_y = start_y_imu+offset_y_imu*i;

    // smooth sensor values
    smooth_data_imu[i] = lerp(smooth_data_imu[i], data_imu[i], smooth_factor_imu);

    // show values as text (three digits after '.')
    String value = nf(data_imu[i], 0, 3);
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(labels_imu[i]+value, width/2, temp_pos_y);

    // show values as bar (raw and smoothed data)
    noStroke();
    fill(colors_imu[i]);
    // raw data
    rect(width/2, temp_pos_y+height_graph_imu*2, data_imu[i]*multiplier_graph_imu, height_graph_imu);
    // smooth data
    rect(width/2, temp_pos_y+height_graph_imu*4, smooth_data_imu[i]*multiplier_graph_imu, height_graph_imu);
  }

  // data sensors

  // loop trough data of sensors analog
  for (int i=0; i<data_sensors_analog.length; i++) {

    // temporary pos y for visualization
    int temp_pos_y = start_y_sensors_analog+offset_y_sensors_analog*i;

    // smooth sensor values
    smooth_data_sensors_analog[i] = lerp(smooth_data_sensors_analog[i], data_sensors_analog[i], smooth_factor_sensors_analog);

    // show values as text (three digits after '.')
    String value = nf(data_sensors_analog[i], 0, 3);
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(labels_sensors_analog[i]+value, width/2, temp_pos_y);

    // show values as bar (raw and smoothed data)
    noStroke();
    fill(colors_sensors_analog[i]);
    // raw data
    rect(width/2, temp_pos_y+height_graph_sensors_analog*2, data_sensors_analog[i]*multiplier_graph_sensors_analog, height_graph_sensors_analog);
    // smooth data
    rect(width/2, temp_pos_y+height_graph_sensors_analog*4, smooth_data_sensors_analog[i]*multiplier_graph_sensors_analog, height_graph_sensors_analog);
  }

  // loop trough data of sensors digital
  for (int i=0; i<data_sensors_digital.length; i++) {

    // temporary pos y for visualization
    int temp_pos_y = start_y_sensors_digital+offset_y_sensors_digital*i;

    // show values as text
    noStroke();
    fill(255);
    textAlign(LEFT, TOP);
    text(labels_sensors_digital[i]+data_sensors_digital[i], width/2, temp_pos_y);

    // show values as rect (not filled or filled)
    if (data_sensors_digital[i]==0) {
      noFill();
      stroke(255);
    } else {
      noStroke();
      fill(255);
    }
    rect(width/2, temp_pos_y+size_rect_sensors_digital*2, size_rect_sensors_digital, size_rect_sensors_digital);
  }

  // ultrasonic ranger (=distance)
  // smooth value
  smooth_distance = lerp(smooth_distance, distance, smooth_factor_distance);
  noStroke();
  fill(255);
  textAlign(LEFT, TOP);
  text("distance (cm): "+distance, width/2, start_y_ultrasonic);
  // show values as bar (raw and smoothed data)
  noStroke();
  fill(255);
  // raw data
  rect(width/2, start_y_ultrasonic+height_graph_ultrasonic*2, distance, height_graph_ultrasonic);
  rect(width/2, start_y_ultrasonic+height_graph_ultrasonic*4, smooth_distance, height_graph_ultrasonic);
}

// OSC

// IMU
public void imu(float r, float p, float y) {
  // roll, pitch, yaw
  data_imu[0] = r;
  data_imu[1] = p;
  data_imu[2] = y;
}

// data sensors
public void sensors_analog(int v1, int v2) {
  // data
  data_sensors_analog[0] = float(v1);
  data_sensors_analog[1] = float(v2);
}
public void sensors_digital(int v1, int v2) {
  // data
  data_sensors_digital[0] = v1;
  data_sensors_digital[1] = v2;
}
public void distance(int v1) {
  // data
  distance = v1;
}
