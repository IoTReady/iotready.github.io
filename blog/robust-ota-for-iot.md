---
title: Over-the-air (OTA) updating your IoT system? Plenty to think about before you sign up.
excerpt: >-
  Among the more critical building blocks of an IoT solution, and one which should be thought about sooner than 
  later is the concept of over-the-air (OTA) updates to your deployed fleet of devices.
date: '2021-02-18'
thumb_image: images/ota.jpg
image: images/ota.jpg
layout: post
---

Photo by Sora Shimazaki from Pexels

By Karan Raj Pradhan and Jay Warrior.

Among the more critical building blocks of an IoT solution, and one which should be thought about sooner than later is the concept of over-the-air (OTA) updates to your deployed fleet of devices. This is particularly useful if that deployed fleet is more than a few hundred devices. There is nothing like a device recall to make that a painful lesson that most of us have gone through, at least once during our careers.

Device updates might be restricted to applications on the device, or more critically to updates to the base firmware itself.

Having this capability gives you all kinds of nice-to-have features such as (relatively) inexpensive bug fixes and product feature upgrades. Certainly everyone of us has experienced multiple over the air updates which are continuously being delivered over the air to our phones. We tend to think of these as a normal part of owning a phone, occasionally something goes wrong and another patch has to be rolled out, sometimes we have to go back to an older version of an app. 

Firmware updates (AKA new OS updates) are a lot trickier of course, and most of us, like our customers often do, view these with suspicion and delay implementing them for as long as possible. We use the principle that if it is working, don’t touch it. 

However going from updating what is essentially an independent device such as a phone or a smart light bulb to updating a working system is another story.

We are not going to dig into the details of OTA technology in this article, but the workflow to actually get updates successfully delivered is quite interesting, so a few technical details are necessary.

We have a customer who has our code running on some 40,000+ devices. The base platform has a custom designed OTA strategy implemented, since at the stage that we developed the device software stack, no good stable solution existed. Karan Raj Pradhan, the engineer who is working on the re-engineering of the strategy sat down with me and as we went over the design, it struck me that there’s a lot of what we had to consider that might be useful to those of you who are thinking about making this feature a core part of your product offering.

Funnily enough, it's not the OTA that is the major problem when implementing a practical update strategy. Setting up the context and ensuring that your IoT devices are in a good state to accept an update is both more critical and very application dependent. In a majority of real world applications, your IoT devices do not operate stand-alone but as part of an overall system. 

Overall system operation requires the operator to be both aware of the state of the individual IoT devices and also to put the system into a safe mode where you can update the devices. 

Another common issue that crops up when updating a system is that typically you update all the components of a system, so for a system as we have described you may have anywhere from a handful to several tens of devices whose updates have to be coordinated together. It does not make sense to carry out these updates individually, downloading and applying updates from the cloud for each one. It makes more sense to download the necessary images once and distribute them locally.

Additionally, you are now faced with the need to make these updates atomically across the set of devices that constitute the system so that you can ensure a coordinated system update.

One soon realizes that it helps to be up and personal with the device, rather than trying to do everything from the cloud. So here is the big problem. Most IoT devices have little if any by way of a local interface. They are literally almost black boxes. So how do you get up close and personal with these devices in the field?

Well, taking a little look back in history to classical industrial control systems applications, we discover the existence of the handheld or device communicator. These are devices that can be taken out into the field and connected up to networks there. They enable the commissioning and validation of devices, the synchronization of configurations, and a range of provisioning and diagnostic apps/plug-ins. They have a long history of fitting the use cases that appeared when using smart devices in the field. Not so common yet for IoT applications.

We had partially implemented this kind of strategy, where a local device coordinates system upgrades using custom apps and firmware on our devices (they use ESP32 modules as their core compute/communication module).

This time round we were able to take advantage of an updated software development kit, the ESP Mesh Development Framework (ESP-MDF) that almost completely maps to our proposed strategy. Using the MDF we now:

1. Supply a configuration and update application that is hosted on the users phone or tablet and that communicates with the devices that constitute the system over the local network, and also to our code repositories in the cloud.
2. First ensure that the user is registered and logged into the app.
3. Ensure that the devices you are going to be communicating with are valid devices that have been registered with the device repository on the cloud.
4. When a firmware or application upgrade is necessary, the user uses the application to set the devices in a safe state.
5. ESP-MDF supplies Application Programming Interfaces (APIs) that enable us to interact with the Mesh Upgrade functionality implemented in the software. The upgrade model uses an elected node in the mesh network, called the root node that the application on the phone talks to in order to carry out the updates.
6. After having pulled down the upgrades from the web server & checking them for validity, the phone app talks to the root node to determine the nodes on the network and to identify the list of devices to upgrade.
7. The phone app sends the firmware together with the list of devices to the root node which checks it for validity and against size constraints.
8. The root node compresses segments and checksums the firmware and uses multicast and mesh transmissions and retransmissions to distribute the firmware to the target nodes and to validate the successful transfer of the firmware based on statuses reported back from the target nodes.
9. Target nodes upon successful receipt and flashing of the new firmware mark the partition holding the new firmware as the boot partition.
10. The root node sends the reboot command to the target nodes and verifies the current software version in the nodes.
11. When this is complete, the root node reports success or failure back to the phone app.
12. Failed nodes revert to their last known good configuration through the use of a watchdog timer or a hardware reset.

We are able to watch and control the state of the application and the update process from the field. We have clear visibility into the state of each device and how we are progressing through the update cycle. We are able to increase the reliability and speed of updates by using locally cached images We can ensure that our updates have succeeded or roll them back before bringing the system back online.

So looking back at historical use-cases, re-discovering the instrumentation/control technician as a key role, you can uncover clues to implement an OTA update strategy that is going to keep your customers happy and you successful. It really is an internet of People and Things.
