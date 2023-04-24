// libraries
// in "import Library > Manage Libraries" search for "oscP5"
import oscP5.*;
import netP5.*;

// font
PFont font;

// osc
OscP5 oscP5;
NetAddress remoteLocation;
int recv_port = 9999;
int send_port = 9998;

// data
int analogValue1 = 0;
int analogValue2 = 0;

int digitalValue1 = 0;
int digitalValue2 = 0;

int distance = 0;

// setup
void setup() {

  // size canvas
  size(640, 480);

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
  // remoteLocation = new NetAddress("192.168.1.201", send_port);

  // listen to different messages
  oscP5.plug(this, "sensors_analog", "/sensors_analog");
  oscP5.plug(this, "sensors_digital", "/sensors_digital");
  oscP5.plug(this, "distance", "/distance");
}


// draw
void draw() {

  // clear background
  background(0);

  // show data
  fill(255);
  noStroke();
  text("sensor analog 1: "+analogValue1, 32, 32);
  text("sensor analog 3: "+analogValue2, 32, 64);
  text("sensor digital 1: "+digitalValue1, 32, 96);
  text("sensor digital 2: "+digitalValue2, 32, 128);
  
  text("distance: "+distance, 32, 160);
}

// OSC
public void sensors_analog(int v1, int v2) {
  // data
  analogValue1 = v1;
  analogValue2 = v2;
}
public void sensors_digital(int v1, int v2) {
  // data
  digitalValue1 = v1;
  digitalValue2 = v2;
}
public void distance(int v1) {
  // data
  distance = v1;
}
