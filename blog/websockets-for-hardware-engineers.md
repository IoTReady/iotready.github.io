---
title: Websockets for Hardware Engineers - Part 1
subtitle: Or how to use websockets for profit.
excerpt: >-
  Websockets are a communication protocol that allow the creation of persistent, bidirectional communication channels between client and server.
date: '2020-12-15'
thumb_image: images/websockets.png
image: images/websockets.png
layout: post
---

## Before we start, what is HTTP?
This is what HTTP REST looks like...

<div class="mermaid">
journey
    title Typical Client-Server Flow
    section Identify Yourself!
      SSL Handshake: 3: Client, Server
      Authenticate: 5: Client
      Authorize: 3: Server
    section Make a Request
      Ask for data: 5: Client
      Send data: 3: Server
</div>
<div class="mermaid">
journey
    title A bit later...
    section Identify Yourself!
      SSL Handshake: 3: Client, Server
      Authenticate: 4: Client
      Authorize: 3: Server
    section Make a Request
      Send data: 3: Client
      Acknowledge: 3: Server
</div>

### We noticed some issues...

- Each request is preceded by an SSL handshake (if HTTPS) and authentication
- This can consume significant resources (CPU, time, memory) each time
- The server can never send data to the client
  - The client needs to implement polling to request data any time it is needed.

## What are websockets?
Websockets are a communication protocol that allow the creation of **persistent**, **bidirectional** communication **channels** between client and server.

<div class="mermaid">
journey
    title A Websockets Journey
    section Identify Yourself!
      SSL Handshake: 3: Client, Server
      Authenticate: 5: Client
      Authorize: 3: Server
    section Make a Request
      Send data: 5: Client
      Acknowledge: 3: Server
    section Event on Server!
      Send data: 3: Server
    section Make a Request
      Get data: 5: Client
      Send data: 3: Server
</div>

### Persistent
- Once established, the connection between client and server is kept-alive for a long period
  - No theoretical limit
  - Connection can be kept alive through regular pings
- Disconnections are events that can be monitored to trigger reconnection

### Bidirectional
- Once the connection is established, the server can send information to the client at any time. 
  - No need for the client to initiate the request
- Client can also send requests to the server
  
### Channels
- Each websocket connection is actually a channel
  - Imagine a long pipe where information can flow both ways
- Each channel is opened on a specific address, and typically, has a specific purpose
- Each client can open multiple channels with the same server
- Multiple clients can open channels with the same server

### Points to Note
- Websockets is based on TCP so the server cannot broadcast messages to all clients
  - Instead, on the server, maintain a list of connnected clients and send them messages in a loop
- Each websocket connection consumes memory so close unused connections
  - Enforce ping based check of alive clients - if no response, close the connection!
- Websockets only concerns itself with the transport layer (on top of TCP) and makes no recommendation about the encoding of the data being transmitted.
  - You can [transmit text](https://www.websocket.org/echo.html)
  - Or [JSON](https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md)
  - Or [even binary files](https://techtutorialsx.com/2018/11/08/python-websocket-client-sending-binary-content/)

## Exercises
### Tools we need
- [websocat](https://github.com/vi/websocat/releases) or similar command line websockets client for Exercise 1
- [NodeJS](https://nodejs.org/en/) or [Python 3](https://www.python.org/) for Exercise 2
- [ESP32](https://www.espressif.com/en/products/socs/esp32/overview) and [ESP-IDF](https://esp-idf.readthedocs.io/) for Exercise 3 

### 1. Public Websocket Server
- Use websocat from a terminal to connect to the [Binance websocket streams](https://github.com/binance-exchange/binance-official-api-docs/blob/master/web-socket-streams.md)
  - These endpoints are known to work:
    - `wss://stream.binance.com:9443/ws/!miniTicker@arr`
    - `wss://stream.binance.com:9443/ws/btcusdt@depth`
    - `wss://stream.binance.com:9443/ws/bnbbtc@depth`
- Open another terminal/tab and connect to a different stream from Binance
- For the really patient, check how long the connection remains open for with:
```bash
date; websocat wss://stream.binance.com:9443/ws/bnbbtc@depth; date
```

### 2. Local Websocket Server
#### NodeJS
- Follow [this excellent tutorial](https://flaviocopes.com/websockets/) to set up a local websocket client and server

#### Python
- Follow [this tutorial](https://codingpointer.com/python-tutorial/python-websockets) to set up a local websocket client and server

### 3. ESP32 as a Websocket Server
- [Set up ESP-IDF](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/get-started/index.html#installation-step-by-step) on your computer
- Build and flash the [Websocket Echo Server example](https://github.com/espressif/esp-idf/tree/master/examples/protocols/http_server/ws_echo_server) from ESP-IDF on the ESP32
  - You will need to configure your WiFi settings with `idf.py menuconfig`
  - Once booted, the ESP32 will print its `ip_address`. You will need this.
- Using websocat, connect to `http://ip_address/ws/`
- Once connected, type and send any string message, e.g. `hello`
- Open a new terminal and repeat the websocat messaging. 
  - What do you notice across the two clients?

#### More advanced example
- Try this [slightly more advanced example](https://github.com/espressif/esp-idf/tree/master/examples/protocols/websocket)

## Questions
- What are the similarities and differences between HTTP and BLE?
- What are the similarities and differences between Websockets and BLE?
- How would you implement an API for client to request changes (e.g. switch on lights)?

## Ideas, questions or corrections?
Write to us at [hello@iotready.co](mailto:hello@iotready.co)
