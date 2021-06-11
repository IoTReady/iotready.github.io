---
title: Bringing simplicity to using ESP32 with AWS IoT Core
excerpt: >-
  Manually preparing devices to connect to AWS IoT Core can be cumbersome, specially in large nummbers. Here is how to do it using a 'prepare' script that saves build time and automates the process for simplicity. 
date: '2021-06-12'
thumb_image: images/esp32-awsiot.png
image: images/esp32-awsiot.png
layout: post
---

# ESP32 and AWS IoT Core

## AWS IoT Core
- AWS IoT Core is one of the biggest services to occupy the IoT service markets, and rightfully so.
- It lets you connect IoT devices to the AWS cloud without the need to provision or manage servers.
- It can support very large numbers of devices and messages, hence is very scalable.
- The billing methods are very attactive. You only pay for exactly which and how much of AWS resources you use.
- AWS IoT Core makes it easy to use other AWS services with least effort.
- AWS IoT Core provides authentication when devices connect to AWS IoT Core, so data is only transferred after proven identity.

However, it might still take users quite some reading, researching and head-scratching the first few times at least before they start to get a hang of the environment and technology. It definitely could use more simplicity.

AWS IoT Core also has robust security features as I mentioned above. However, setting these up causes the user to go through quite a few repeated steps in order to get their devices to start sharing data with AWS IoT Core.

Here are the steps needed to prepare a device to connect to AWS IoT Core:
1. Create a unique 'thing' on the AWS IoT server
2. Create a unique set of [certificates](https://docs.aws.amazon.com/iot/latest/developerguide/x509-client-certs.html) for the thing just created.
3. Create a AWS IoT Core [policy](https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html) to control access to the AWS IoT Core server.
4. Attach the policy to the certificate used for the thing.
5. Upload these certificates into the device so that it can access them to authenticate the connection from the device to the AWS IoT server.

## Need for simplicity and efficiency
As you must have realized, this can be a tedious and time-consuming task, hence inefficient for preparing large number of devices. We wanted to create a tool that not only saves compile time but also automates this process to make it a layman's task to prepare as many devices as possible in the shortest time possible while maintaining simplicity and configurability.

## The [Prepare Script](https://github.com/IoTReady/prepare_script_awsiot)
The prepare script is a tool that automates the creating and flashing of devices making them ready-to-deploy with just one command, saving time in abundance. It does the following:

1. Use esptool to get the default MAC address of the device.
2. Creates an AWS policy if it does not already exist. To learn about policies in AWS, visit [here](https://docs.aws.amazon.com/iot/latest/developerguide/iot-policies.html).
3. Create keys(private and public) and the certificate for the device and saves them as files.
4. Attaches the existing/created policy in step 2 to the certificate.
5. Creates a new thing with the MAC address obtained in step1 as thing name.
6. Copies/embeds the downloaded certificate and keys files into the necessary folder.

![prepare_flow](/images/prepare_script_flow.png)

### SPIFFS Handling
What remains then is a mechanism to upload these unique certificates into the device. This can be done using the [spiffsgen.py](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/storage/spiffs.html#spiffsgen-py) tool. The unique certificates that are downloaded for each device are stored into a directory, which is then created into an image and stored into the SPIFFS partition space in the ESP32 (using the [spiffsgen.py](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/storage/spiffs.html#spiffsgen-py) tool). The code then has provisions to read these files and use them for SSL verification and authentication.

All you need to make sure is to add this into the CMakeLists.txt file under the 'main' directory of your project:
````
spiffs_create_partition_image(my_spiffs_partition my_folder FLASH_IN_PROJECT)
````
If the above is done, the idf.py command makes sure that "my_folder" is turned into an SPIFFS image and flashed into the "my_spiffs_partition" SPIFFS partition

We have released a working example of the script in our ESP32 Firmware Base [repository](https://github.com/IoTReady/esp32_firmware_base/tree/master/examples/aws_iot). 

## Running the example:
- You will need AWS configured in your device in order to automatically access your AWS account and do the various steps above. If you haven't already:
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
    > For more details on AWS access keys :https://docs.aws.amazon.com/general/latest/gr/aws-sec-cred-types.html#access-keys-and-secret-access-keys<br>
    For more details on AWS CLI: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html

- You will need esptool and boto3 installed. Just run:
````
$ pip3 install -r requirements.txt
````
- Make sure you have configured the AWS variables in [registerDevice.py](./registerDevice.py#L19)
- Put your code project into a directory named `source`. This can be changed in the script.
- Connect your ESP32 
> This script is designed to be used for production firmware. Therefore, at every run, it stashes and pulls from the remote git repo. Please move ahead accordingly.
- The AWS certificates will be stored in a folder named `aws_credentials` directory according to the current setup. You can change this in the registerDevice.py file. Make sure the directory exists before you run the script.
- Make sure the prepare.sh file has executable permission:
````
$ sudo chmod a+x prepare.sh
````
- Run prepare.sh in your project folder.
````
$ ./prepare.sh
````

**Note:**
- If the project is not a git repository, comment the following lines in prepare.sh:
````
git stash
git pull
````