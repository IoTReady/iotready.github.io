---
title: IoT’s big dirty secret - It’s the cloud!
excerpt: >-
  It all arises because of the dependence of the vast majority of IoT solutions on a cloud back-end.
date: '2020-12-03'
thumb_image: images/iot_arch_.png
image: images/iot_arch_.png
layout: post
---


Yes, really. Let me explain why.

It all arises because of the dependence of the vast majority of IoT solutions on a cloud back-end. While attractive for many reasons, using a cloud based solution for certain key parts of your infrastructure can lead to pretty dramatic loss of functionality when things go wrong.

It's not an IoT problem either. A couple of weeks earlier Apple machines had a problem when a local process that’s part of Apple's Gatekeeper security solution(trustd) on the machine had trouble connecting to Apple’s Online Certificate Status Protocol website and as a consequence installed applications would not launch.

Unfortunately, there are many incentives for a vendor to tie back information between you and the cloud, all of which cement in architectural vulnerabilities.

While the cloud plays a big role in these kinds of problems, it’s also an architectural problem, caused by assumptions that ubiquitous connectivity exists. Unfortunately in the real world this is just not the case. It’s not a feature of working in less developed areas of the world either - you only have to Google “kids without internet” to get a long list of articles about problems all over the United States.

So how did this dependence on the cloud back-end come about? The cloud is not essential for IoT, but it makes some functions of an IoT system easier. In the same way that businesses and enterprises were attracted to the cloud, IoT recognized similar benefits from following the same transition.

Centralizing computing resources has important benefits. The most obvious one is the ability to aggregate data across wide areas. The second is the ability to easily scale resources both for the purpose of data analysis as well as for handling the growth in a system as more and more devices are added. This ease of use encouraged not only the migration of these analytics and data storage functions to the cloud but resulted in certain vital core functions involved with the operation of the IoT system to migrate into the cloud as well. These included things such as device configuration, device management, and in many cases the fundamental algorithms used in the solution as well. And this is where the potential for problems creeps in.

A simple analogy for us is the human body and the operation of our nervous system. The nervous system plays the role of a factory or process control automation system. It handles all inputs and outputs, it processes and analyzes information and causes physical actions to be taken. It is interesting that while we as humans distinguish between the central nervous system (the brain and spinal cord) and the peripheral nervous system (all the other nerves in the body), the body looks at the nervous system as being composed of the voluntary and involuntary nervous sub-systems. As you can easily infer, the voluntary nervous system is under our mental control, while the involuntary nervous system consists of reflexes and other autonomic processes that execute without conscious control from the human mind.

Interestingly enough long years of experience in process and factory automation has resulted in a mimicking of this behaviour in industrial automation. We speak of first level or “closed loop” control where the controller is making automatic decisions, and the higher or “setpoint control” where an operator or a higher level optimization algorithm determines and adjusts setpoints.

For a more human example, a cruise control system follows exactly this model. We set a speed limit, the cruise control adjusts the car to that speed. With newer systems additional algorithms can manipulate the setpoint so as to keep constant distance from a vehicle in front and other useful features.

In addition to this simple model, additional critical capabilities such as fail-safe modes and emergency shutdown modes are commonly built into real systems.

IoT systems have the same functions and needs as those that we have described. Because of the limited capabilities at the end nodes, operating as they are under resource constraints, there has been a tendency to push functionality up into the cloud. Thus the end devices are relatively simple devices that sense or actuate and send data up to the cloud where the “loop closing” computations are made. The analogy to this is as if the sensation of touching something boiling hot had to travel up the spinal cord to the brain and all the way down again to tell the finger to move. Not a good way to prevent a burn. Worse, of course, if the signal happened to get lost on the way upto or back from the brain because of an occasional bit of nervous congestion.

This architectural failure in IoT system design has been the subject of much interest over the last few years and has given rise to the pursuit of what are called edge or fog computing architectures. Here data and control processing are pushed out as close to the edge device as possible at an “edgebox” or edge device that provides a compute and data reduction platform.

The decision as to how to partition functionality between the various levels of control and data processing and the devices on which the control and data processing happens is critical to obtaining a robust and performant IoT system. This is driven of course by the needs of the application, and so we need to start with the architecture of the problem.

The European Union has for many years been working towards a vision for the future of industrial manufacturing called Industry 4.0. It has yielded, in my opinion one of the best architectural models for building such systems. This model is the Reference Architectural Model Industry 4.0. RAMI is a DIN standard (91345) and an IEC pre-standard (PAS 63088). Needless to say it applies squarely to IoT solutions, and I will use it in this and future articles to talk about the various critical components of an IoT solution.

![RAMI](/images/RAMI.png)

The RAMI reference model is structured as a cube with three complementary axes. The first is the hierarchy level axis. It corresponds most closely with the architectural models that you are most used to seeing, and stretches from devices in the field up through enterprise systems. The second is the functional layer axis. It describes the various meta-data and information transformations as we move from a physical asset on the shop floor upto the highest level of an organization or business process. The third and most often ignored axis is the life-cycle axis which considers the evolution of a system and its components from the earliest stages of development through deployment and maintenance. It forces one to take a holistic view of the various components of a system and their evolution over time.

We now have the abstractional framework that we can use to break out the various functions and components of our (IoT) Industry 4.0 solutions and the means to make the right decisions about where and how functionality should be distributed.

In the next few articles we will pick out some of these key functional entities and describe solution components that meet these needs.
