---
title: Virtual IoT
subtitle: Traceability and continuous monitoring for dumb devices.
date: '2020-07-20'
thumb_image: images/repl_accessory.jpg
image: images/repl_accessory.jpg
layout: project
---

## Customer - [REPL](https://www.repl.com/)

> One of the leading manufacturers of cable accessories for power and telecom industries across the globe.

## Problem Statement
REPL products are deployed in millions of locations in electricity grids across the world, _every year_. REPL wanted to introduce location traceability and enhanced post-deployment monitoring to these products using weather metrics.

## Solution
![REPL Connect Animation](/images/repl_connect.gif)

Our web dashboard has native **geo-spatial** capabilities for storing, querying and visualising data. Working closely with the team at REPL, we customised our **QR scanning** + **location tracking** mobile app code kit to fit the workflow of typical operator. 

### Challenges
- The human operator is a key enabler for this solution. It took multiple iterations to optimise the UX while keeping the process transparent. 
- We wanted to enable a live operation state map where you could see new deployments as they are completed. This is where Elixir and Phoenix with LiveView really shine!
- We are continuing to optimise geo-spatial queries with PostGIS.

