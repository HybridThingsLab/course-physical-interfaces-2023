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

// imu (roll, pitch, yaw)
float[] data_imu = new float[3];
float[] smooth_data_imu = new float[3];
float smooth_factor_imu = 0.1;



// viz data

// IMU
color[] colors_imu = {color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)};
String[] labels_imu = {"roll: ", "pitch: ", "yaw: "};
float multiplier_graph_imu = 2.0;
int height_graph_imu = 12;
int start_y_imu = 60;
int offset_y_imu = 80;


// setup
void setup() {

  // size canvas
  size(960, 540);

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
}


// draw
void draw() {

  // clear background
  background(0);

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
}

// OSC

// IMU
public void imu(float r, float p, float y) {
  // roll, pitch, yaw
  data_imu[0] = r;
  data_imu[1] = p;
  data_imu[2] = y;
}
