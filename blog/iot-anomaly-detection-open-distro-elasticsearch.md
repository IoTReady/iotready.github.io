---
title: Anomaly Detection For IoT Using Open Distro For ElasticSearch
subtitle: Real-time anomaly detection with minimal setup.
excerpt: >-
  Real time anomaly detection is now part of ODFE and allows applications such as predictive maintenance.
date: '2021-02-17'
thumb_image: images/anomaly_detection_results.png
image: images/anomaly_detection_results.png
layout: post
---

> This post is the third in series on using the AWS ecosystem for IoT applications. Previously, we integrated AWS IoT with [Timestream /Quicksight](/blog/metal-to-alerts-with-aws-iot-timestream-quicksight) and [ElasticSearch/Kibana](/blog/metal-to-alerts-with-aws-iot-elasticsearch-kibana).

## Why

Anomaly detection is the foundation for applications such as Predictive Maintenance, which in turn is the driving force behind most industrial IoT deployments. Now that the _essentials_ of sensors, communication, storage and visualisation have largely been solved, attention has turned to machine learning based analytics. Cue the [new features from AWS IoT](https://aws.amazon.com/iot-analytics/) and Open Distro For ElasticSearch - the latter is the focus of this article. 


## What are we going to build?

We will:

1. Simulate a smart grid sensor capable of measuring current, voltage, tempterature and humidity
2. Train an anomaly detector in ODFE on each of these metrics or `features` as ODFE calls them. 
3. Simulate various grades of anomalies and verify that detector is working fine
4. Integrate the anomaly detector with Kibana's alerts ([previously discussed here](/blog/metal-to-alerts-with-aws-iot-elasticsearch-kibana))


### Simulated Smart Grid Sensor

Our simulated sensor helps monitor and predict failures in the medium voltage (MV) transmission grid. The sensor has the following nominal specifications:

- Voltage between 23kV and 25kV
- Current between 0A and 600A
- Temperature between 30C and 100C
- Humidity between 20% and 80%

> Values in these ranges are considered **good**. Anything outside is an **anomaly**.


### Anomaly Detection in ODFE

ODFE uses the Random Cut Forest (RCF) algorithm for anomaly detection. RCF is an unsupervised algorithm which analyses the data and identifies patterns. Data points that do not fit into these patterns are classified as anomalies and can include, amongst others,:

- Spikes
- Changes in periodicity
- Unclassifiable data points

Each anomaly is given a score - low scores correspond to _normal_ and high scores to _anomalous_ data points. Read more about RCF in these references:

- [Real-time anomaly detection in ODFE](https://opendistro.github.io/for-elasticsearch/blog/odfe-updates/2019/11/real-time-anomaly-detection-in-open-distro-for-elasticsearch/)
- [RCF with AWS Sagemaker](https://docs.aws.amazon.com/sagemaker/latest/dg/randomcutforest.html)
- [RCF Algorithm on Manning](https://freecontent.manning.com/the-randomcutforest-algorithm/)

#### ElasticSearch Instance

Assuming you followed the previous post, you will already have an ElasticSearch instance running. However, we need at least 2 CPU cores to use anomaly detection. I am using a `t2.medium` instance for this post.

## Building Our First Anomaly Detector

Like before, we will start our simulator to inject sensor data into ElasticSearch. I started a script to simulate 21 sensors sending data every 10s. 

```python
current = random.uniform(0.0,600.0)
voltage = random.uniform(23000.0,25000.0)
temperature = random.uniform(30,100)
humidity = random.uniform(20.0,80.0)
```

The injected data looks a bit like this:

![Nominal Current Timeseries Chart](/images/es_cvs_timeseries_good.png)


### Initialisation / Training

The ODFE documentation has an [excellent guide](https://opendistro.github.io/for-elasticsearch-docs/docs/ad/#get-started-with-anomaly-detection) for setting up a detector. Following that we end up with a configuration that looks like this:

![Anomaly Detector Configuration](/images/es_anomaly_detector_configuration.png)

Note that:

- I picked `Detector Interval = 5 minutes` and `Window Delay = 2 minutes` 
  - The documentation suggests smaller intervals make the system more real-time but consume more CPU, which sounds about right.
- You are allowed to add up to 5 features per detector - this seems to be an ODFE limitation rather than that of the RCF algorithm itself.
- I have chosen to track the `max()` value for each metric. You can use any of the standard ElasticSearch aggregations.
- Once configured, the detector took between 30-60 minutes to initialise and go live.
- I made the mistake of trying to enable the detector on a `t2.small` instance and kept running into an `unknown error`. This disappeared once I changed the instance size to `t2.medium`. 


### Anomaly Generation

Once the detector was **Live**, I started generating anomalies in about 60% of the data points using the following snippet. Note that I am randomly introducing anomalies into one or all of the four metrics.

```python
r = random.randint(1,10)
if r == 1:
    current = 0
    voltage = 0
    temperature = 0
    humidity = 0
elif r == 2:
    current = 1000
    voltage = 100000
    temperature = 300
    humidity = 150
elif r == 3:
    current = 1000
    voltage = random.uniform(23000.0,25000.0)
    temperature = random.uniform(30,100)
    humidity = random.uniform(20.0,80.0)
elif r == 4:
    current = random.uniform(0.0,600.0)
    voltage = 100000
    temperature = random.uniform(30,100)
    humidity = random.uniform(20.0,80.0)
elif r == 5:
    current = random.uniform(0.0,600.0)
    voltage = random.uniform(23000.0,25000.0)
    temperature = 300
    humidity = random.uniform(20.0,80.0)
elif r == 6:
    current = random.uniform(0.0,600.0)
    voltage = random.uniform(23000.0,25000.0)
    temperature = random.uniform(30,100)
    humidity = 150
else:
    current = random.uniform(0.0,600.0)
    voltage = random.uniform(23000.0,25000.0)
    temperature = random.uniform(30,100)
    humidity = random.uniform(20.0,80.0)
```

The resulting timeseries charts, in their glorious randomness, look like this:

![Anomalous Metrics Timeseries Charts](/images/es_cvs_timeseries_bad.png)


### Anomaly Detection

And just like that, the detector is triggered within the first time interval. This is great - with little knowledge of machine learning and zero code, we set up a self-taught anomaly detector!


![Anomaly Detector Results](/images/anomaly_detection_results.png)

### Hang On...

If you examine the anomaly grades, you will notice that the grade reduces in each time interval until the detector no longer considers the signals to be anomalous. This reminds me of an old joke,


> Said the guru to his disciple, "Next year is going to be really difficult for you. You will not meet your family or friends for a long time and you will witness a lot of suffering. In fact you won't be able to step outside your own house!". "And the year after?", asked the disciple. The guru replied, "You will get used to it".

Jokes aside, **why** is this happening? 

The anomaly detector, as mentioned above, is self-taught. And it keeps learning - even as anomalous data streams in. As the kind folk at ODFE explained to me, if 5% of your data is anomalous, is it really anomalous or, in fact, the *new normal*? The anomaly detector, naturally, adapts to this new normal and gives these signals a decreasing grade until they are fully *normalised*.

This makes sense, it's just not what I expected. 

### How do you solve this?

> If your data has infrequent anomalies, there's nothing to fix. The existing plugin already works well!

Freezing the anomaly detection data model by stopping the learning phase should solve this problem. I have opened a [feature request](https://github.com/opendistro-for-elasticsearch/anomaly-detection/issues/388) for this very use case.

A good suggestion from the ODFE team was to use a combination of rule based detection algorithms and ML based anomaly detection. This makes sense, especially since there are a few other issues with this domain-agnostic approach:

- All signals, across all devices, in a time interval are given a single anomaly grade. We may need to classify these anomalies for priorities and, more importantly, identify the specific devices which are reporting anomalous data.
- We may need different anomaly detection for each SKU. E.g. 300A current is anomalous for a sensor rated at 200A but normal for a 500A sensor. With ODFE, we would need to send data from each SKU to a different index and set up separate detectors for each.


## Conclusions and Next Steps

Anomaly detection is a relatively new feature in ODFE and is already really good at actually detecting anomalies and does not get tripped unless the anomalies are frequent or persistent. If the [feature request](https://github.com/opendistro-for-elasticsearch/anomaly-detection/issues/388) is accepted and built, we are in job done territory for simple use cases. 

For sensitive applications like smart grids and perhaps industrial monitoring, we are exploring solutions that combine intelligence on the cloud and at the edge. Over the coming weeks and months, we will write about our work with:

- Rule based calibration and detection at the edge
- [Fuzzy logic](https://www.sciencedirect.com/science/article/pii/S0888613X96001168) based fault diagnosis at the edge
- ML at the edge using projects such as [TinyML](https://www.tinyml.org/)

## Ideas, questions or corrections?

Write to us at [hello@iotready.co](mailto:hello@iotready.co)
