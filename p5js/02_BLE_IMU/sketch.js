// Copyright (c) 2018 p5ble
//
// This software is released under the MIT License.
// https://opensource.org/licenses/MIT

// The serviceUuid must match the serviceUuid of the device you would like to connect
const serviceUuid = "2A5A20B9-0000-4B9C-9C69-4975713E0FF2";
let accelerationCharacteristic;
let gyroscopeCharacteristic;
let ax = 0, ay = 0, az = 0;
let gx = 0, gy = 0, gz = 0;
let myBLE;

function setup() {
  // Create a p5ble class
  myBLE = new p5ble();

  createCanvas(600, 400);
  background("#FFF");
  textSize(16);

  // Create a 'Connect and Start Notifications' button
  const connectButton = createButton('Connect and Start Notifications')
  connectButton.mousePressed(connectAndStartNotify);
}

function connectAndStartNotify() {
  // Connect to a device by passing the service UUID
  myBLE.connect(serviceUuid, gotCharacteristics);
  // You can also filter devices by name
  // myBLE.connect({
  //   filters: [{
  //     services: [serviceUuid],
  //   }, {
  //     name: 'ArduinoIMU'
  //   }]
  // }, gotCharacteristics)
}

// A function that will be called once got characteristics
function gotCharacteristics(error, characteristics) {
  if (error) console.log('error: ', error);
  for (let i = 0; i < characteristics.length; i++) {
    if (i == 0) {
      accelerationCharacteristic = characteristics[i];
      // Set datatype to 'custom', p5.ble.js won't parse the data, will return data as it is.
      myBLE.startNotifications(accelerationCharacteristic, handleAcceleration, 'custom');
    } else if (i == 1) {
      gyroscopeCharacteristic = characteristics[i];
      myBLE.startNotifications(gyroscopeCharacteristic, handleGyroscope, 'custom');
    } else {
      console.log("characteristic doesn't match.");
    }
  }
}

// A function that will be called once got characteristics
function handleAcceleration(data) {
  ax = data.getFloat32(0, true);
  ay = data.getFloat32(4, true);
  az = data.getFloat32(8, true);
}

function handleGyroscope(data) {
  gx = data.getFloat32(0, true);
  gy = data.getFloat32(4, true);
  gz = data.getFloat32(8, true);
}

function draw() {
  background(255);
  text(`Acceleration X: ${ax}`, 100, 50);
  text(`Acceleration Y: ${ay}`, 100, 100);
  text(`Acceleration Z: ${az}`, 100, 150);

  text(`Gyroscope X: ${gx}`, 100, 250);
  text(`Gyroscope Y: ${gy}`, 100, 300);
  text(`Gyroscope Z: ${gz}`, 100, 350);
}
