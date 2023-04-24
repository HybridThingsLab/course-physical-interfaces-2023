// Arduino osc
// https://github.com/hideakitai/ArduinoOSC
#include <ArduinoOSCWiFi.h>

// Seeed Grove Ultrasonic Ranger
// https://wiki.seeedstudio.com/Grove-Ultrasonic_Ranger/
// https://github.com/Seeed-Studio/Seeed_Arduino_UltrasonicRanger/archive/master.zip
// https://wiki.seeedstudio.com/Upload_Code/
// #include "Ultrasonic.h"



// WiFi stuff
const char* ssid = "maschinenraum"; // change to your WiFi name
const char* pwd = "maschinenraum"; // change to your password
const IPAddress ip(192, 168, 1, 201);  // IP Arduino board (change here)
const IPAddress gateway(192, 168, 1, 1);
const IPAddress subnet(255, 255, 255, 0);

// for ArduinoOSC
const char* host = "192.168.1.101";  // IP of PC/Laptop (change here)
const int recv_port = 9998;
const int send_port = 9999;

// sensors

// analog
int analogPin1 = 0; // analog sensor 1 on PIN A0
int analogPin2 = 6; // analog sensor 2 on PIN A6
int analogValue1 = 0;
int analogValue2 = 0;

// digital
int digitalPin1 = 2; // digital sensor 1 on PIN D2
int digitalPin2 = 4; // digital sensor 2 on PIN D4
int digitalValue1 = 0;
int digitalValue2 = 0;

// init ultrasonic ranger (distance sensor) just if connected! Otherwise deactivate next line with comment!
// Ultrasonic ultrasonic(6); // ultrasonic ranger on PIN D6
int distance = 0;  // distance in cm


// setup
void setup() {

  // init serial connection
  Serial.begin(57600);

  // pin modes
  pinMode(digitalPin1, INPUT);  // just needs to be done if digital input
  pinMode(digitalPin2, INPUT);  // just needs to be done if digital input

// WiFi stuff (no timeout setting for WiFi)
#ifdef ESP_PLATFORM
  WiFi.disconnect(true, true);  // disable wifi, erase ap info
  delay(1000);
  WiFi.mode(WIFI_STA);
#endif
  WiFi.begin(ssid, pwd);
  WiFi.config(ip, gateway, subnet);

  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(500);
  }
  Serial.print("WiFi connected, IP = ");
  Serial.println(WiFi.localIP());

  // send OSC data

  // sensor data
  OscWiFi.publish(host, send_port, "/sensors_analog", analogValue1, analogValue2)
    ->setIntervalMsec(10.f);

  OscWiFi.publish(host, send_port, "/sensors_digital", digitalValue1, digitalValue2)
    ->setIntervalMsec(10.f);

  OscWiFi.publish(host, send_port, "/distance", distance)
    ->setIntervalMsec(10.f);
}



// loop
void loop() {

  // update OSC
  OscWiFi.update();

  // get data analog pins
  analogValue1 = analogRead(analogPin1);  // values between 0-1023
  analogValue2 = analogRead(analogPin2);  // values between 0-1023

  // get data digital pins
  digitalValue1 = digitalRead(digitalPin1);  // value 0 or 1
  digitalValue2 = digitalRead(digitalPin2);  // value 0 or 1

  // show values via serial monitor (debugging) > uncomment
  // Serial.println(analogValue1);
  // Serial.println(analogValue2);
  // Serial.println(digitalValue1);
  // Serial.println(digitalValue2);

  // get distance with ultrasonic ranger, just if connected! Otherwise deactivate next line with comment!
  // distance = ultrasonic.MeasureInCentimeters();

  // show disance via serial monitor
  //Serial.println(distance);

}
