---
title: Joovv Light Therapy
subtitle: The "Apple" of Light Therapy Products
date: '2018-06-30'
thumb_image: images/joovv_panel.jpg
image: images/joovv_panel.jpg
layout: project
---

## Customer - [Joovv](https://www.joovv.com/)

> World’s most trusted in-home light therapy.

## Problem Statement
Joovv wanted to bring light therapy into the 21st century with cutting edge voice, mesh and app capabilities.

## Solution

<!-- ![Joovv](/images/joovv.jpg) -->

We were embedded with Joovv's OEM in China to help redesign the core controller hardware, write the **firmware**, **mobile apps** and **Alexa skill**. These now power over **45000 units** worldwide generating 15M+ messages to our IoT cloud each month.  

### Challenges

- Before BLE mesh became a thing, we had to implement a fast, highly scalable BLE-based lead/follow algorithm for connecting multiple Joovv units.
- Joovv units are packed with features, supporting BLE, WiFi, AWS IoT and CANBus! Writing stable firmware that ran on the (relatively) tiny microcontroller was certainly _exciting_.