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
