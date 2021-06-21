---
title: stamp_esp32 - a minimal form factor esp32 development board
excerpt: >-
  While the ESP32 has many development boards available on the market, sometimes you want a minimally sized version that can easily mount on your own pcb. 
date: '2021-06-20'
thumb_image: images/Front_3D.jpg
image: images/Front_3D.jpg
layout: post
---



## Product Description

While the ESP32 has many development boards available on the market, sometimes you want a minimally sized version that can easily mount on your own pcb. Stamp_esp32 is an entry level development board which is essentially a shrunken version of the esp32C DEvKitC.

It has all the ESP32 pins exposed and is easy to connect and use. This board is designed with the castellated edge connector pins which makes easier for the board to be either directly soldered or used with heade pins. 

## Circuit

### Power Supply

There are two mutually exclusive ways to provide power to the board:

* 5 Volts / GND castellated edge connector pins

* 3.3 Volts / GND castellated edge conector pins

The input power is supplied through the castellated edge connector pins which are marked as VBUS and GND on the board. 

<p align="center"><img src="/images/stamp_esp32-Docs/Powe_supply_pin.png"></p>

The 3.3 Volts for the esp32 wroom module is sourced through the voltage regulator AMS117_3.3 which is the U2 component in the schematics.
The LED D1 indicates the presence of power supply to the circuit.

![Image]/images/stamp_esp32-Docs/AMS117_3.3_LED.png)

### Programing pins

For data transmission we have used the two castellated edge connector pins that are D+ and D- which are marked on the board

<p align="center"><img src="/images/stamp_esp32-Docs/Powe_supply_pin.png")></p>

This board is UART protocol based hence, for convenience it provides onboard USB to UART conversion, The USB to UART Bridge chip is provides transfer rates of up to 3 Mbps.

![Image](/images/stamp_esp32-Docs/USB_to_UART_Bridge.png)

### Switch Buttons

The two push button switches are used. SW2  is connected to the enable pin of the Esp32 WROOM. The other switch button, SW1 is used as boot pin which is connected to IO0 of the Esp32 WROOM.

![Image](/images/stamp_esp32-Docs/Switch_button.png)

### ESP32 module

Briefly, the ESP32-WROOM-32D is a powerful, generic Wi-Fi+BT+BLE MCU module that targets a wide variety of applications, ranging from low-power sensor networks to the most demanding tasks, such as voice encoding, music streaming and MP3 decoding.

The advantage of the ESP32-WROOM is:

* It has the SPI flash rate of 32 Mbits
* It operates with the 3.3Volts
* It has the onboard Antenna 

![Image](/images/stamp_esp32-Docs/esp32_wroom_32d.png)

### Castellated edge cuts

Castellated edge cuts  are plated through holes or vias placed on the edges of a printed circuit board. These are cut through to form a series of half holes. These half holes, called castelations, serve as pads to create a connection between the module board and the board that it will be soldered onto.

The youtube channel VoltLog has a nice explanation of [**How to create Castellated Edge cuts**](https://youtu.be/ZtRmQ-350Dc)

Castellation service is not provided by all PCB  manufacturers.  [**PCB WAY**](https://www.pcbway.com/) is one PCB manufacturing company which is based in China that provides castellation services. You opt for the castellation on their website while sending your gerber file for the manufacturing.

### PCB Dimensions
The size of the stamp_esp32 is 37.9mm x 31.3mm. The antenna size is 6.5mm

<p align="center"><img src="/images/stamp_esp32-Docs/PCB_dimensions.png"></p>

The final PCB looks like the 3D image given below

<p align="center"><img src="/images/stamp_esp32-Docs/Front_3D.png"></p>

<p align="center"><img src="/images/stamp_esp32-Docs/Back_3D.png")</p>