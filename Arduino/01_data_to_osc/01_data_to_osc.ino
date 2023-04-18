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
const char* host = "192.168.1.101";  // IP of Laptop (change here)
const int recv_port = 9998;
const int send_port = 9999;

// sensors
int sensorPin1 = A0;
int sensorPin2 = A6;
int sensorValue1 = 0;
int sensorValue2 = 0;

// setup
void setup() {

  // init serial connection
  Serial.begin(57600);

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

  // random data
  OscWiFi.publish(host, send_port, "/sensors", sensorValue1, sensorValue2)
    ->setIntervalMsec(10.f);
}



// loop
void loop() {

  // update OSC
  OscWiFi.update();

  // get data sensor 1 and 2
  sensorValue1 = analogRead(sensorPin1);
  sensorValue2 = analogRead(sensorPin2);
}
