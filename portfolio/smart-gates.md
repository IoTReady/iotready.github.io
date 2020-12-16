---
title: Elsema Smart Gates 
subtitle: IoT Enabled, App Controlled Gates  
date: '2020-08-26'
thumb_image: images/elsema_remote.jpg
image: images/elsema_remote.jpg
layout: project
---

## Customer
[Elsema](https://www.elsema.com/)

> Elsema is a renowned name in providing a range of niche wireless remote control technologies, automatic gate and door products.

## Problem Statement
Elsema wanted to offer their customers an app based interface to control gates as an alternative to their range of wireless remote control fobs.

## Solution

![Elsema Animation](/images/elsema_animation.gif)

Elsema had already chosen **AWS IoT** as their chosen backend for device-cloud-app communications. They reached out to us for our **Flutter** mobile app code kit that supports AWS IoT out of the box. The code kit has allowed them to focus their energy on building a great user experience and not worry about the complexities on **MQTT** on Android and iOS. The code kit also includes a simple flow to configure WiFi on their chosen hardware.

### Challenges

- AWS IoT is wonderful and is our recommended solution for IoT brokers. However, there is no official Flutter support. So we built and open sourced our own plugin for securely connecting and communicating from Flutter!
- MQTT connections are persistent but can be a challenge to maintain when apps go into the background. We had to cover a number of edge cases to ensure that the apps stay connected.
