---
title: Selecting a Suitable RFID System For Your Operations
excerpt: >-
  There are multiple RFID standards. we present a few simple rules to choose the right one for your application. 
date: '2021-03-13'
thumb_image: images/uhf-rfid-tags.jpg
image: images/uhf-rfid-tags.jpg
layout: post
---

A lot of our customers and potentials use or are looking to adopt RFID systems. For technology that's all around us and has been for a while now, there are still a lot of misconceptions about the available options. This short post is a summary of decision criteria and common use cases.

## Do I need RFID?

Let's start with the basics. RFID tags are only one type of ID technology. Alternatives include barcodes, QR codes and [exotic pigments](https://www.sciencedaily.com/releases/2013/09/130910104515.htm) and [acoustic tags](https://secoora.org/fact/the-technology/acoustic-telemetry/). When should you choose these?

- Choose barcodes if you need printable labels and are ok with manual/short range scanning.
- Choose QR codes if you are ok with barcodes but need to store more data.
- Choose pigments if you need discrete traceability and are ok with a small range of IDs. 
- If you need acoustic tags you probably work in defence or marine applications. 

## Aren't there different kinds of RFID tags?

RFID tags can be further classified based on their frequency spectrum and protocol. Common tags include:

- Low frequency (LF, 125kHz)
- High frequency (HF aka NFC, 13.56MHz)
- Ultra-high frequency (UHF, 860-960MHz)
- WiFi (typically 2.4GHz)
- Bluetooth (2.4GHz)

So, when should you choose which RFID technology?

- Choose LF if you are in an industry that requires these by **regulation**, e.g. sheep and cattle farming in various countries. 
- Choose HF or NFC if you need extremely **short range** tags for security.
- Choose UHF if you want **longer range**, smaller tags or printed **flexible** labels. 
- WiFi and Bluetooth tags are relatively new but allow you to integrate more easily with existing IT infrastructure. 

Across these technologies, tags are available with batteries (active) or without (passive). 

> [Passive Bluetooth tags](https://www.wiliot.com/) are new but we are excited to see where they go. 


### How do passive RF tags work?

All passive RF tags work relatively similarly: 

- Reader transmits signals to energise the tag.
- Tag captures some of this energy, wakes up and acknowledges the reader.
- Reader queries the ID and the tag responds.
- Tag loses energy and continues being.


## Use cases

*These are not meant to be an exhaustive list.*

### Farm to Fork Traceability

RFID tags are increasingly common in the livestock industry, adoption boosted due to regulation following outbreaks of [preventable diseases](https://www.fda.gov/animal-veterinary/animal-health-literacy/all-about-bse-mad-cow-disease). The workflow, while not *simple*, is easy to understand:

- Farmers tag young calves and sheep with a unique ID a few days after birth.
- Innoculations are tracked against this unique ID.
- Markets verify these IDs and innoculations whenever the livestock changes hands.
- Processing plants create batch IDs traceable to specific tags before selling meat to supermarkets.


#### LF Tags

LF tags have so far been the most dominant choice in this industry due to their maturity and relatively low cost. The most common LF tags have a length of wire coiled around a ferrite core. The ferrite core helps concentrate electromagnetic fields inside the tag so that it can capture enough energy to power itself. 

![LF Glass Tag](/images/lf_glass_tags.jpg)

Due to a combination of power emission regulations and the inefficiency of energy capture, LF tags typically only feature a range of a few centimeters. As a result readers tend to be a little... intrusive and cramped.


![Cattle RFID Stick Reader](/images/cow_rfid_scanning.jpg)

![Sheep RFID Race](/images/sheep_rfid_race.jpg)


The low bit rate of LF tags limits the amount of data that can be transferred within one charge cycle - as a result these tags only ever hold an ID. Any other metadata needs to be held on an external application DB.

#### UHF Tags

In order to overcome these drawbacks, there has been some early movement in adopting UHF tags for livestock. UHF tags use a standard originally [developed by GS1](https://www.gs1.org/standards/epc-rfid) for retail logistics operations. 

The primary principle of operation for UHF remains the same as LF tags. However, the increased frequency allows energy to be captured more efficiently and data to be transferred faster. As a result, one achieves longer range and scanning of multiple tags simultaneously. 

UHF also allows the antennas to be smaller - reducing cost and increasing the choice of available materials. This in turn enables flexible UHF label tags - making them suitable for use on all kinds of products. 

![UHF RFID Label](/images/uhf-rfid-label.jpg)

UHF tags do feature more memory than LF tags and can transmit more data. However, it is relatively uncommon to use the tag for storing anything more than an ID. 

> Our customer, [Datamars](https://datamars.com), is one of the world's largest manufacturer of UHF tags for laundry and livestock applications. 


### Indoor Traceability

RFID tags are also very common in indoor traceability. Ever used a "smart" card hanging from a lanyard to open a secured door? That's NFC/HF in action. 

Hospitals are [adopting RFID](https://www.rfidjournal.com/rfid-in-healthcare-revolutionizing-patient-safety-and-changing-the-landscape) systems to track everything from patients to equipment. 

We are working with a customer on introducing traceability into an regulatory compliance system using our IoT ready UHF RFID readers. A more elaborate article on this use case is coming soon. 


### Anti-theft

I am not a fan of the ugly scanners at shop entrances but I understand why they are there. These systems commonly use UHF tags and were previously restricted to high end products. However, the falling cost of tags and the popularity of self-checkout has increased adoption [across all products](https://nexqo.com/2020/06/rfid-the-secret-of-decathlons-rapid-expansion/).

![RFID Stand For Shops](/images/shop_entrance_rfid_stand.jpg)

We have developed a discrete ceiling-mounted RFID reader that is easily integrated into security and door-lock systems. We will shortly post performance metrics from this reader and release the antenna design into the open domain.

