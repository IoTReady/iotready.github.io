---
title: Easy to use GSM and GPS building blocks for mobile IoT devices
excerpt: >-
  Among the numerous applications that IoT technology has been applied to, there is a large class of applications that need some unique capabilities from their underlying hardware platform in order to enable their construction.
date: '2021-03-09'
thumb_image: images/Smart_City-IoT.jpg
image: images/Smart_City-IoT.jpg
layout: post
---


Among the numerous applications that IoT technology has been applied to, there is a large class of applications that need some unique capabilities from their underlying hardware platform in order to enable their construction. We are talking about applications, typically for mobile or widely geographically distributed applications. Examples of these might be sensors for monitoring agricultural pumps, for monitoring transportation vehicles and so on.

The hardware for this class of applications usually have some distinguishing characteristics:

- Cellular infrastructure, with support for SMS and optionally voice.
- GPS capability to allow the device to determine its location
- A real time clock for event stamping and data logging
- Compute and storage with sufficient GPIO pins
- SPI/I<sup>2</sup>C  interfaces for connection to peripheral devices
- A reasonable cost.


The [Ai-thinker A9/A9G](http://www.ai-thinker.com/pro_view-28.html) is one platform that provides a perfect processing power and more importantly a perfect combination of features:

![A9 Module](/images/A9.png) ![](/images/A9G.png)

  * RDA 32 bit RISC core, frequency up to 312MHz, with 4k instruction cache, 4k data cache
  * Up to 29 GPIOs (with two download pins)
  * Calendar (Real Time Clock) with alarm
  * 1 USB1.1 device interface
  * 2 UART interface with flow control (+1 download/debug serial port)
  * 2 SPI interface
  * 3 I<sup>2</sup>C interface
  * 1 SDMMC controller (interface)
  * 2 ADC interface, 10 bits
  * 32Mb (4MB) SPI NOR Flash
  * 32Mb (4MB) DDR PSRAM
  * 8kHz, 13Bits/sample ADC mic
  * 48kHz, 16bits/sample DAC Audio
  * Power Management Unit: Lithium battery charge management, integrated DC-DC and LDOs, variable IO voltage
  * 18.8 x 19.2 mm SMD package
  * Quad-band GSM/GPRS (800/900/1800 / 1900MHz)
  * Calls
  * SMS service
  * Integrated GPS+BDS (connected to UART2 internal of module)


 > To know more about the A9/A9G modules, you can find the datasheets and schematics [here](https://github.com/IoTReady/a9_gsm_gps_library/tree/main/doc).

A lot of you reading this article might only know of the A9 family as a AT-command controlled peripheral IoT enabler, oblivious to the fact that the A9/A9G is capable of customized firmware! The Ai-Thinker platorm includes an [SDK](https://ai-thinker-open.github.io/GPRS_C_SDK_DOC/en/) that allows you to  use the module not just as a peripheral that your microcontroller talks to, but a stand-alone device. 

Taking advantage of this access gives you a chance to create a design without needing a separate board and external controller for your application.

In this article we describe a wrapper around the core SDK that we have just open sourced. This wrapper simplifies using the capabilities of the A9/A9G and allows you to access the capabilities of the A9 through some simple abstractions.

While these should be enough to get you from point A to point B in IoT, the A9 and A9G pack a lot more heat than I can describe in this tiny article alone. It is rarely that a module that is as tiny as this, is able to pack as much ability as they A9/A9G.

## Overview of the [open source library](https://github.com/IoTReady/a9_gsm_gps_library)

We, at IoTReady, would not be where we are without the help of open-source platforms and make it a part of our core principles to put in as much effort as we can to share the knowledge and experience we gain. 

The A9/A9G are a pair of low-cost GPRS SoC modules from AI-Thinker. The A9G variant includes an on-chip GPS. The firmware uses a custom RTOS and we have created a set of libraries to simplify custom product development.

This SDK provides a wrapper over the most used functionalities for the Ai-Thinker GPRS SoC modules A9/A9G making for simpler setup and faster deployability.

The A9/A9G can be used in a wide variety of IoT applications. This low-cost, effective module can be the go-to product for quick development and deployment of IoT solutions around the world. Okay okay, I'm going to stop bragging about stuff you already know and get to the point of all this conversation.

**This brings me to talk about the drawbacks about trying to use the A9/A9G modules:**
- Scattered Documentation plus language barriers.
- AT commands do not provide anywhere near half the complete control that can be obtained on this module using the SDK.
- Development on this product has been almost completely stopped.

**What does this SDK do to solve these?**
- This library provides an easier-to-use and ready-to-deploy, out of the box API wrapper over the GPRS_C_SDK provided by Ai-Thinker. Dont get me wrong, you will still need to use and setup the GPRS_C_SDK and setup the toolkit, but we have tried to simplify it for you so you dont need to waste your precious time looking for the right links and putting the documents together(which you can find [here](https://iotready.co/a9_gsm_gps_library)).
- On top of that, we provide wrapper functions/APIs to maintain homogeneity as much as possible in your code structuring and writing.
- They also help you skip complex steps in order to get the job done with simpler, lesser code and better documentation!

For example, 
The [mqtt_ssl_initialize()](https://iotready.co/a9_gsm_gps_library/mqtt__lib_8h.html#a384477abcbbf9c75747f48b14c0f0d00) takes all the parameters required to initialize MQTT with SSL verification. This exempts you from having to write complex structures and feed configurations into the code, hence saving time and effort while maintaining coherence. We have an [example](https://github.com/IoTReady/a9_gsm_gps_library/blob/main/a9_mqtt_lib/src/mqtt_example.c) that has been built to do exactly that with [AWS IoT Core](https://aws.amazon.com/iot-core/)! Just do the following:
- Feed in these certificates and keys into [certs.h](https://github.com/IoTReady/a9_gsm_gps_library/blob/main/a9_mqtt_lib/include/certs.h):
  - Root CA certificate
  - Client certificate
  - Public key
- Edit the parameters in [mqtt_config.h](https://github.com/IoTReady/a9_gsm_gps_library/blob/main/a9_mqtt_lib/include/mqtt_config.h) to suit your settings and configuration.
- Build and flash as directed [here](https://github.com/IoTReady/a9_gsm_gps_library#hardware-connection)!

![A9 MQTT Snippet](/images/A9-mqtt-snippet.png)

And **VOILA!**, you're up and running with AWS IoT. 

For more information about the various functions and complete code and documentation, please see [Github repo](https://github.com/IoTReady/a9_gsm_gps_library) and [documentation](https://iotready.co/a9_gsm_gps_library/)

For issues, please feel free to submit an issue on the [Github repo](https://github.com/IoTReady/a9_gsm_gps_library). For further queries, please write to us at hello@iotready.co. For more of our open-source projects, visit [https://iotready.co/open-source/](https://iotready.co/open-source/)
