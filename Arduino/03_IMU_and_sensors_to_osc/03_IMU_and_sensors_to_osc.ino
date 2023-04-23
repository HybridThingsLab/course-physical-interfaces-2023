// Arduino osc
// https://github.com/hideakitai/ArduinoOSC
#include <ArduinoOSCWiFi.h>

// Arduino LSM6DS3 - built-in IMU
// https://github.com/arduino-libraries/Arduino_LSM6DS3
#include <Arduino_LSM6DS3.h>

// Seeed Grove Ultrasonic Ranger, just if connected! Otherwise deactivate last line with comment!
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

// IMU (built-in inertial measurement unit)

float accelX, accelY, accelZ,                               // units m/s/s i.e. accelZ if often 9.8 (gravity)
  gyroX, gyroY, gyroZ,                                      // units dps (degrees per second)
  gyroDriftX, gyroDriftY, gyroDriftZ,                       // units dps
  gyroRoll, gyroPitch, gyroYaw,                             // units degrees (expect major drift)
  gyroCorrectedRoll, gyroCorrectedPitch, gyroCorrectedYaw,  // units degrees (expect minor drift)
  accRoll, accPitch, accYaw,                                // units degrees (roll and pitch noisy, yaw not possible)
  complementaryRoll, complementaryPitch, complementaryYaw;  // units degrees (excellent roll, pitch, yaw minor drift)
long lastTime;
long lastInterval;

// sensors

// analog
int analogPin1 = 0;  // analog sensor 1 on PIN A5
int analogPin2 = 6;  // analog sensor 2 on PIN A6
int analogValue1 = 0;
int analogValue2 = 0;

// digital
int digitalPin1 = 2;  // digital sensor 1 on PIN D2
int digitalPin2 = 4;  // digital sensor 2 on PIN D2
int digitalValue1 = 0;
int digitalValue2 = 0;

// init ultrasonic ranger (distance sensor) just if connected! Otherwise deactivate first line with comment!
// Ultrasonic ultrasonic(6);  // ultrasonic ranger on PIN D6
int distance = 0;          // distance in cm

// setup
void setup() {

  // init serial connection
  Serial.begin(57600);

  // pin modes
  pinMode(digitalPin1, INPUT);  // just needs to be done if digital input
  pinMode(digitalPin2, INPUT);  // just needs to be done if digital input

  // init IMU (inertial measurement unit)
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1)
      ;
  }
  // calibrate IMU
  calibrateIMU(250, 250);

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
  OscWiFi.publish(host, send_port, "/imu", complementaryRoll, complementaryPitch, complementaryYaw)
    ->setIntervalMsec(10.f);

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

  // IMU
  if (readIMU()) {
    long currentTime = micros();
    lastInterval = currentTime - lastTime;  // expecting this to be ~104Hz +- 4%
    lastTime = currentTime;

    doCalculations();
  }

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

///////////////////
// function IMU ///
///////////////////
void doCalculations() {
  accRoll = atan2(accelY, accelZ) * 180 / M_PI;
  accPitch = atan2(-accelX, sqrt(accelY * accelY + accelZ * accelZ)) * 180 / M_PI;

  float lastFrequency = (float)1000000.0 / lastInterval;
  gyroRoll = gyroRoll + (gyroX / lastFrequency);
  gyroPitch = gyroPitch + (gyroY / lastFrequency);
  gyroYaw = gyroYaw + (gyroZ / lastFrequency);

  gyroCorrectedRoll = gyroCorrectedRoll + ((gyroX - gyroDriftX) / lastFrequency);
  gyroCorrectedPitch = gyroCorrectedPitch + ((gyroY - gyroDriftY) / lastFrequency);
  gyroCorrectedYaw = gyroCorrectedYaw + ((gyroZ - gyroDriftZ) / lastFrequency);

  complementaryRoll = complementaryRoll + ((gyroX - gyroDriftX) / lastFrequency);
  complementaryPitch = complementaryPitch + ((gyroY - gyroDriftY) / lastFrequency);
  complementaryYaw = complementaryYaw + ((gyroZ - gyroDriftZ) / lastFrequency);

  complementaryRoll = 0.98 * complementaryRoll + 0.02 * accRoll;
  complementaryPitch = 0.98 * complementaryPitch + 0.02 * accPitch;
}

/*
  the gyro's x,y,z values drift by a steady amount. if we measure this when arduino is still
  we can correct the drift when doing real measurements later
*/
void calibrateIMU(int delayMillis, int calibrationMillis) {

  int calibrationCount = 0;

  delay(delayMillis);  // to avoid shakes after pressing reset button

  float sumX, sumY, sumZ;
  int startTime = millis();
  while (millis() < startTime + calibrationMillis) {
    if (readIMU()) {
      // in an ideal world gyroX/Y/Z == 0, anything higher or lower represents drift
      sumX += gyroX;
      sumY += gyroY;
      sumZ += gyroZ;

      calibrationCount++;
    }
  }

  if (calibrationCount == 0) {
    Serial.println("Failed to calibrate");
  }

  gyroDriftX = sumX / calibrationCount;
  gyroDriftY = sumY / calibrationCount;
  gyroDriftZ = sumZ / calibrationCount;
}

/**
   Read accel and gyro data.
   returns true if value is 'new' and false if IMU is returning old cached data
*/
bool readIMU() {
  if (IMU.accelerationAvailable() && IMU.gyroscopeAvailable()) {
    IMU.readAcceleration(accelX, accelY, accelZ);
    IMU.readGyroscope(gyroX, gyroY, gyroZ);
    return true;
  }
  return false;
}
