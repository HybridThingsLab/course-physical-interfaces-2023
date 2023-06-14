# Physical Interfaces / summer term 2023
HS Augsburg, Prof. Andreas Muxel 

# Arduino Nano 33 IoT
* https://store.arduino.cc/products/arduino-nano-33-iot
* restart board > press white button on board once
* hard reset (if board is not visible in Arduino IDE) > double press white button on board

# Grove Shield for Arduino Nano
* https://wiki.seeedstudio.com/Grove_Shield_for_Arduino_Nano/
* to work with Arduino 33 serial boards, please switch the VCC power to 3.3V. If the VCC power supply is switched to 5V, the development board may be damaged!
![image](https://user-images.githubusercontent.com/36045885/233867107-1c738aad-8702-4763-a5a6-cc8998f8954a.png)


# Seeed Grove System
* parts available in Prototyping Lab: https://github.com/HybridThingsLab/protobase/wiki/Seeed-Grove-System 
* Grove Ultrasonic Ranger (tutorial & library), https://wiki.seeedstudio.com/Grove-Ultrasonic_Ranger/, see also code example [/Arduino/01_sensors_to_osc](https://github.com/HybridThingsLab/course-physical-interfaces-2023/tree/main/Arduino/01_sensors_to_osc)

# Capacitive Sensor
* Capacitive Sensor Library, https://github.com/PaulStoffregen/CapacitiveSensor
* further details principle capacitive sensing: https://playground.arduino.cc/Main/CapacitiveSensor/
* if you want to connect sensor to digital pin 2 and 3, use "D2" connection on Grove Shield for Arduino Nano
* if you want to connect another sensor to digital pin 4 and 5, use "D4" connection on Grove Shield for Arduino Nano
* never touch metal, foil etc. directly, always use another material in between (for example foam noodle etc.) for best results!
* see also code examples [/Arduino/04_CapSense_to_osc](https://github.com/HybridThingsLab/course-physical-interfaces-2023/tree/main/Arduino/04_CapSense_to_osc) and [/Processing/sketch_08_CapSense_to_midi](https://github.com/HybridThingsLab/course-physical-interfaces-2023/tree/main/Processing/sketch_08_CapSense_to_midi)

![capSensing](https://user-images.githubusercontent.com/36045885/236751146-33e90607-4916-4dbc-9162-0291caf5f7b0.jpg)

# Flex and Pressure Sensor
| ![wiring](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/a60fc7d2-ecef-4757-a983-be780e642754) | ![clip01](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/4c281d3f-c028-4b4e-8793-b31c3a66c166) | ![clip02](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/b947ce15-ebb4-4036-a98a-16d97c1e88e9) |
|---|---|---|
| wiring | step 1 | step 2 |
| ![pressure01](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/8792f196-a729-487b-86f4-b6078fc2fbb4) | ![pressure02](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/b58e5306-cce4-42df-bbca-29d6b929752e) | ![pressure03](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/16d32858-c230-4688-ae48-468364c0cb74) |
| step 3 | step 4 | step 5 |
* measure value on analog input (for example A0)


# Soldering
![soldering](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/6ecc60bc-06fb-47f2-a572-0db1c1ae183c)
* check tutorial Wiki Prototyping Lab, https://github.com/HybridThingsLab/protobase/wiki/Soldering

# Direct Connection to Arduino Nano (no Grove Shield)
**Pinout Diagram**
![image](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/47305ca7-2adc-41bd-b3d8-50383059df04)

**Switch**
|![switch01](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/953e2fd8-83e7-46a0-af5f-b7901c71428d)|![switch02](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/2dacc126-be69-4e27-b02f-d8704209b379)|![switch03](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/ec9d3e76-7a5f-4042-a5b3-f6728e995a64)|![switch04](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/1d0a4f69-bf0e-4c5f-8b70-d76f43bed4e9)|![switch05](https://github.com/HybridThingsLab/course-physical-interfaces-2023/assets/36045885/54c6b623-554f-444c-ae59-d7ee16ee5877)|
|---|---|---|---|---|
| step 1 | step 2 | step 3| step 4 | step 5 |



# MIDI setup
* Mac: activate MIDI Port in system settings, https://support.apple.com/de-de/guide/audio-midi-setup/ams1013/mac 
* PC: install loopMidi: http://www.tobias-erichsen.de/software/loopmidi.html, to have a virtual MIDI port (Processing <> Helm)

# Helm  synthesizer 
* download: https://tytel.org/helm/
* click on logo for Audio/MIDI settings (activate virtual MIDI port here)
* set "VEL TRACK" to 100% 
* right-click on knob and use "Learn MIDI Assignement", see also code [/Processing/sketch_06_midi_set_control](https://github.com/HybridThingsLab/course-physical-interfaces-2023/tree/main/Processing/sketch_06_midi_set_control)


<img width="470" alt="image" src="https://user-images.githubusercontent.com/36045885/233994532-479fc511-3947-4b5e-96d2-31506a514dba.png">
<img width="329" alt="image" src="https://user-images.githubusercontent.com/36045885/233443943-9adf69aa-22de-45bf-a8b2-3b7f00bbc60e.png">
<img width="317" alt="image" src="https://user-images.githubusercontent.com/36045885/233444014-e31a2e09-8edb-4c3d-8833-3b683cb04cf4.png">
<img width="322" alt="image" src="https://user-images.githubusercontent.com/36045885/233783738-6171d349-9771-4d92-b78b-b9d80543e92c.png">


# Tutorials Helm
* https://steemit.com/music/@buckydurddle/helm-video-tutorials-beginner-s-guide
* https://www.youtube.com/watch?v=Rh9jXdXPP-Q
