// libraries
// in "import Library > Manage Libraries" search for "oscP5"
import oscP5.*;
import netP5.*;

// in "import Library > Manage Libraries" search for "Minim"
import ddf.minim.*;
import ddf.minim.ugens.*;

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

// minim (sound)
Minim minim;
AudioOutput out;

// the Oscil we use for modulating frequency.
Oscil fm;


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

  // initialize the minim and out objects
  minim = new Minim( this );
  out   = minim.getLineOut();

  // make the Oscil we will hear.
  // arguments are frequency, amplitude, and waveform
  Oscil wave = new Oscil( 200, 0.8, Waves.TRIANGLE );
  // make the Oscil we will use to modulate the frequency of wave.
  // the frequency of this Oscil will determine how quickly the
  // frequency of wave changes and the amplitude determines how much.
  // since we are using the output of fm directly to set the frequency
  // of wave, you can think of the amplitude as being expressed in Hz.
  fm   = new Oscil( 10, 2, Waves.SINE );
  // set the offset of fm so that it generates values centered around 200 Hz
  fm.offset.setLastValue(100);
  // patch it to the frequency of wave so it controls it
  fm.patch( wave.frequency );
  // and patch wave to the output
  wave.patch( out );
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

  // map roll and pitch to modulate synth
  float roll = smooth_data_imu[0];
  float pitch = smooth_data_imu[1];
  float yaw = smooth_data_imu[2];
  roll = map(roll, -180.0, 180.0, -1.0, 1.0);
  pitch = map(pitch, -180.0, 180.0, -1.0, 1.0);
  yaw = map(yaw, -180.0, 180.0, -1.0, 1.0);


  float modulateAmount = map(roll, -1.0, 1.0, 220, 1 );
  float modulateFrequency = map(pitch, -1.0, 1.0, 0.1, 200 );
  // float modulateOffset = map(yaw, -1.0, 1.0, 40, 300 );

  // fm.offset.setLastValue(modulateOffset);
  fm.setFrequency( modulateFrequency);
  fm.setAmplitude( modulateAmount);
}

// OSC

// IMU
public void imu(float r, float p, float y) {
  // roll, pitch, yaw
  data_imu[0] = r;
  data_imu[1] = p;
  data_imu[2] = y;
}
