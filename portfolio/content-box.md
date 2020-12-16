---
title: Offline Content Access
subtitle: Enabling education off-grid with, and without, Android Set Top Boxes
date: '2019-01-23'
thumb_image: images/set_top_box.jpg
image: images/set_top_box.jpg
layout: project
---


## Customer - [Meghshala](https://meghshala.online/)

> Empowered teachers lead enlightened classrooms.

## Problem Statement
Meghshala provide training and teaching material to teachers across India - many of whom have limited or no internet access. They needed a solution that enabled seamless content access with or without internet.

## Solution

We worked closely with our sister firm, [ContentReady](https://contentready.co), to implement Bonjour style discoverability and peer-to-peer file syncing into the existing Meghshala app. Suddenly, *every* Meghshala user could enable offline access for others. The app was modified to suit set headless top boxes too with kiosk mode and similar built-in features.

### Challenges

- Android is surprisingly aggressive at killing long-running/background apps. We had to invoke a bunch of tricks and chants to keep the app running!
- Android, again, has no built-in support for mDNS/Bonjour services. We implemented our own custom UDP discovery protocol to work around this.