// libraries
// in "import Library > Manage Libraries" search for oscP5
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
int sensorValue1 = 0;
int sensorValue2 = 0;


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
  oscP5.plug(this, "sensors", "/sensors");
}


// draw
void draw() {

  // clear background
  background(0);

  // show data
  fill(255);
  noStroke();
  text(sensorValue1, 32, 32);
  text(sensorValue2, 32, 64);
}

// OSC
public void sensors(int v1, int v2) {
  // data
  sensorValue1 = v1;
  sensorValue2 = v2;
}
