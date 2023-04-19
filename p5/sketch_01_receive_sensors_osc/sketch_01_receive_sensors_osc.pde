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
  remoteLocation = new NetAddress("192.168.1.201", send_port);

  // listen to different messages
  oscP5.plug(this, "sensors_analog", "/sensors_analog");
  oscP5.plug(this, "sensors_digital", "/sensors_digital");
}


// draw
void draw() {

  // clear background
  background(0);

  // show data
  fill(255);
  noStroke();
  text(analogValue1, 32, 32);
  text(analogValue2, 32, 64);
  text(digitalValue1, 32, 96);
  text(digitalValue2, 32, 128);
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
