// Arduino osc
// https://github.com/hideakitai/ArduinoOSC
#include <ArduinoOSCWiFi.h>

// Capactive Sensor
// https://github.com/PaulStoffregen/CapacitiveSensor
// https://playground.arduino.cc/Main/CapacitiveSensor/ > explanation
#include <CapacitiveSensor.h>

// WiFi stuff
const char* ssid = "maschinenraum"; // change to your WiFi name
const char* pwd = "maschinenraum"; // change to your password
const IPAddress ip(192, 168, 0, 201);  // IP Arduino board (change here)
const IPAddress gateway(192, 168, 0, 1);
const IPAddress subnet(255, 255, 255, 0);

// for ArduinoOSC
const char* host = "192.168.0.100";  // IP of PC/Laptop (change here)
const int recv_port = 9998;
const int send_port = 9999;

// capcative sensors
CapacitiveSensor cs_1 = CapacitiveSensor(2, 3);  // 3.0 mega-ohhm Resistor pin 2+3, 3 is sensor pin (where wire to foil is connected)
CapacitiveSensor cs_2 = CapacitiveSensor(4, 5);  // 3.0 mega-ohhm Resistor pin 4+5, 5 is sensor pin (where wire to foil is connected)
int capacitiveValue1 = 0;
int capacitiveValue2 = 0;


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

  // capacitive sensors data
  OscWiFi.publish(host, send_port, "/sensors_capacitive", capacitiveValue1, capacitiveValue2)
    ->setIntervalMsec(10.f);

}



// loop
void loop() {

  // update OSC
  OscWiFi.update();

  // capacitve sensing (byte samples)
  capacitiveValue1 = cs_1.capacitiveSensor(30);
  capacitiveValue2 = cs_2.capacitiveSensor(30);

  // show values via serial monitor (debugging) > uncomment
  // Serial.print(capacitiveValue1);
  // Serial.print(" ");
  // Serial.println(capacitiveValue2);

}
