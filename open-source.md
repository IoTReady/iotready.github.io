---
title: Open Source At IoTReady
# image: images/about.jpg
layout: page
---

## Firmware

### A9/A9G GSM/GPS Chip
The A9/A9G are a pair of low-cost GPRS SoC modules from [AI Thinker]. The A9G variant includes an on-chip GPS. The firmware uses a custom RTOS and we have created a set of libraries to simplify custom product development. 

- [Github Repo](https://github.com/IoTReady/a9_gsm_gps_library)
- [Documentation](https://iotready.co/a9_gsm_gps_library/)


### ESP32 BLE/WiFi Chip
The ESP32 needs no introduction as the most popular WiFi module around. We are working on releasing our code framework built on top of the ESP IDF (IoT Development Framework). Our goal is to make the library as user friendly as the Arduino code base without compromising on size or speed. 


## Mobile App
We build our mobile apps using Flutter due to its cross-platform capabilities and excellent performance. The Flutter ecosystem is still nascent and we have sponsored and released a number of open-source plugins to assist with common IoT use cases.


### AWS IoT

- [Github Repo](https://github.com/IoTReady/flutter-aws-iot)
- [Documentation](https://pub.dev/packages/aws_iot)

### AWS Cognito

- [Github Repo](https://github.com/scientifichackers/flutter_cognito_plugin)
- [Documentation](https://pub.dev/packages/flutter_cognito_plugin)


### AWS AppSync

- [Github Repo](https://github.com/IoTReady/flutter-aws-appsync)
- [Documentation](https://pub.dev/packages/aws_appsync)


### RX-BLE

- [Github Repo](https://github.com/scientifichackers/flutter-rx-ble)
- [Documentation](https://pub.dev/packages/rx_ble)

### WiFi Configuration

- [Github Repo](https://github.com/RohitKumarMishra/wifi_configuration)
- [Documentation](https://pub.dev/packages/wifi_configuration)


### P2P Network File Sync

- [Github Repo](https://github.com/scientifichackers/flutter_cognito_plugin)
- [Documentation](https://pub.dev/packages/network_file)


### Plugin Scaffold

- [Github Repo](https://github.com/scientifichackers/flutter-plugin-scaffold)
- [Documentation](https://pub.dev/packages/plugin_scaffold)


### Super Logging

- [Github Repo](https://github.com/scientifichackers/super_logging)
- [Documentation](https://pub.dev/packages/super_logging)


### Keyboard Events

- [Github Repo](https://github.com/scientifichackers/flutter-keyboard-plugin)
- [Documentation](https://pub.dev/packages/keyboard)


### PDF Viewer

- [Github Repo](https://github.com/scientifichackers/flutter_pdf_viewer)
- [Documentation](https://pub.dev/packages/flutter_pdf_viewer)


## TODO
*We will release these as time permits. However, if you have an urgent need for any of these or are willing to mess around with slightly undercooked tools, please do reach out!*

- nRF52 BLE Data logger
- Alexa Smart Home Skill with CloudFormation template
- CAD files for most of our antenna library
- Calculation tools for antenna range and size modeling
- Sustain OS - collection of mods to Alpine Linux + flashing tools suitable for Raspberry Pi 3 and other Armv7 boards