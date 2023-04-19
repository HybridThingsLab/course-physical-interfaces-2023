// Arduino osc
// https://github.com/hideakitai/ArduinoOSC
#include <ArduinoOSCWiFi.h>

// Arduino LSM6DS3 - built-in IMU
// https://github.com/arduino-libraries/Arduino_LSM6DS3
#include <Arduino_LSM6DS3.h>

// WiFi stuff
const char* ssid = "maschinenraum";
const char* pwd = "maschinenraum";
const IPAddress ip(192, 168, 1, 201);  // IP Arduino microcontroller (change here)
const IPAddress gateway(192, 168, 1, 1);
const IPAddress subnet(255, 255, 255, 0);

// for ArduinoOSC
const char* host = "192.168.1.102";  // IP of Laptop (change here)
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

// sensor

// setup
void setup() {

  // init serial connection
  Serial.begin(57600);

  // init IMU (inertial measurement unit)
  if (!IMU.begin()) {
    Serial.println("Failed to initialize IMU!");
    while (1)
      ;
  }
  // calritate IMU
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
