// Arduino osc
// https://github.com/hideakitai/ArduinoOSC
#include <ArduinoOSCWiFi.h>


// WiFi stuff
const char* ssid = "maschinenraum";
const char* pwd = "maschinenraum";
const IPAddress ip(192, 168, 1, 201);  // IP Arduino board (change here)
const IPAddress gateway(192, 168, 1, 1);
const IPAddress subnet(255, 255, 255, 0);

// for ArduinoOSC
const char* host = "192.168.1.102";  // IP of Laptop (change here)
const int recv_port = 9998;
const int send_port = 9999;

// sensors

// analog
int analogPin1 = A0;
int analogPin2 = A6;
int analogValue1 = 0;
int analogValue2 = 0;

// digital
int digitalPin1 = 2;
int digitalPin2 = 4;
int digitalValue1 = 0;
int digitalValue2 = 0;

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
}
