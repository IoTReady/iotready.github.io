---
title: Using SPIFFS to Simplify AWS IoT Integration For ESP32
excerpt: >-
  Manually preparing devices to connect to AWS IoT Core can be cumbersome, especially in large numbers. We present a script to help you prepare devices fast and reliably while storing certificates in the SPIFFS partition. 
date: '2021-06-12'
thumb_image: images/esp32-awsiot.png
image: images/esp32-awsiot.png
layout: post
---

## Why AWS IoT?

- AWS IoT is a managed service from AWS to provide secure connectivity for your devices. 
- It's highly scalable, supporting millions of devices and billions of messages without you having to manage servers.
- You pay per event at a pretty reasonable rate. 
- The built-in rules engine makes it easy to integrate other AWS services or your external APIs.
- Authentication is handled using X509 certificates making the service highly secure. 

However, as the service has grown, so has the complexity. One part of the flow that has remained constant but trips some of our customers up constantly is the device preparation flow. It goes as follows:

1. Register a unique 'thing' with a thing ID on AWS IoT.
2. Create a set of thing-specific [certificates](https://docs.aws.amazon.com/iot/latest/developerguide/x509-client-certs.html).
3. Create a [policy](https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html) for access control.
4. Attach the policy to the certificate used for the thing.
5. Upload these certificates into the device for authentication while connecting.

If you do this often enough, it's second nature. But if you do this often, why wouldn't you...

# Script it!

As you must have realized, this can be a tedious and time-consuming task. Highly inefficient, and error prone, for preparing large number of devices. For our devices, we wrote a simple `bash` script. 

## [prepare.sh](https://github.com/IoTReady/prepare_script_awsiot)

`prepare.sh` automates registration with AWS IoT and flashes the ESP32 devices in one smooth flow. Flashing each device with the right certificates takes less than 30 seconds!

You can inspect the script linked above and the flow below. Feel free to adapt it to your own use case!


![prepare_flow](/images/prepare_script_flow.png)

### Architectural Choices

There are a couple of choices we make that are worth highlighting:

1. We use the `MAC` address of the ESP32 as the `thingId` on AWS IoT and as `clientId` everytime the ESP32 connects.
2. We store the certificates in an SPIFFS partition on the ESP32 instead of embedding the certificates in a header file as the example code suggests.

The first of these choices is a simple, pragmatic choice that we imagine most other developers make too. 

The second of these is our little gift to you. Storing the certificates in SPIFFS has 2 important benefits:

1. Changing a header file leads to recompilation of your entire project. Compiling an SPIFFS partition takes a fraction of that time.
2. SPIFFS files can be handled as regular files during operation and, thus, can be replaced as needed.


### SPIFFS Handling

What remains then is a mechanism to upload these unique certificates into the device. This can be done using the nifty [spiffsgen.py](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/storage/spiffs.html#spiffsgen-py) tool. 


You will need to add the following snippet into the CMakeLists.txt file under the 'main' directory of your project:

````
spiffs_create_partition_image(my_spiffs_partition my_folder FLASH_IN_PROJECT)
````

If the above is done, the `idf.py` ensures that `my_folder` is converted into an SPIFFS image and flashed into the "my_spiffs_partition" partition. Make sure you allocate sufficient space for this partition in your `partitions.csv`!

For a complete working example, check out our [ESP32 Firmware Base repository](https://github.com/IoTReady/esp32_firmware_base/tree/master/examples/aws_iot). You will notice that we load the certificates from `SPIFFS` on boot insides `tasks.c`.

## Running the example

- We use a Python script [`registerDevice.py`](https://github.com/IoTReady/esp32_firmware_base/blob/master/examples/aws_iot/registerDevice.py) for registering things with AWS IoT and downloading certificates.
- By default, the script relies on your global AWS CLI credentials. 
  - You will need to install and configure AWS CLI if you haven't already done so:

    - Install the python AWS CLI on your machine
    ````
    $ pip3 install awscli
    ````
    - Once done, run the command below to configure your AWS security credentials by providing the respective values:
    ````
    $ aws configure

    AWS Access Key ID [None]:
    AWS Secret Access Key [None]:
    Default region name [None]:
    Default output format [None]:
    ````

    - In lieu of setting up AWS CLI system-wide, you can also use environment variables to access the keys explicly in `registerDevice.py`. 

> Read more about [AWS access keys](https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys) and [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
    

- For getting the `MAC` address and flashing, we use `esptool` and for AWS API connectivity, we use `boto3` installed. Install them with:

````
$ pip3 install -r requirements.txt
````
- Configure the region and other AWS parameters in `registerDevice.py` as per your needs.
- Put your code project into a directory named `source`. This can be changed in the script.
- Connect your ESP32 via USB

> This script is designed to be used for production firmware. Therefore, at every run, it stashes and pulls from the remote git repo. Please move ahead accordingly.

- The AWS certificates will be stored in a folder named `aws_credentials` directory according to the current setup. You can change this in the registerDevice.py file. Make sure the directory exists before you run the script.
- Make sure the prepare.sh file has executable permission:
````
$ chmod a+x prepare.sh
````
- Run prepare.sh in your project folder.
````
$ ./prepare.sh
````

## Summary

We have used variants of this script to flash and ship over 50,000 ESP32 powered products worth over $40M. There are other ways, today, of provisioning devices - including self-provisioning. Yet, this trusty little script with the SPIFFS trick has helped save hundreds of hours of effort and mistakes. Good luck!

## Ideas, questions or corrections?

Write to us at [hello@iotready.co](mailto:hello@iotready.co)
