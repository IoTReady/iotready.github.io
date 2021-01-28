---
title: Anomaly Detection For IoT Using Open Distro For ElasticSearch
subtitle: Real-time anomaly detection with minimal setup.
excerpt: >-
  Real time anomaly detection is now part of ODFE and allows applications such as predictive maintenance.
date: '2021-01-20'
thumb_image: images/es_dashboard.png
image: images/es_dashboard.png
layout: post
published: false
---

> This post is the third in series on using the AWS ecosystem for IoT applications. See the [first](/blog/metal-to-alerts-with-aws-iot-timestream-quicksight) and [second](/blog/metal-to-alerts-with-aws-iot-elasticsearch-kibana) posts for background.

## Why

Anomaly detection is the foundation for applications such as Predictive Maintenance, which in turn is the driving force behind most industrial IoT deployments. Now that the _essentials_ of sensors, communication, storage and visualisation have largely been solved, attention has turned to machine learning based analytics. Cue the [new features from AWS IoT](https://aws.amazon.com/iot-analytics/) and Open Distro For ElasticSearch - the latter is the focus of this article. 


## What are we going to build?

We will:

1. Simulate a smart grid sensor capable of measuring current, voltage, tempterature and humidity
2. Train an anomaly detector in ODFE on each of these metrics or `features` as ODFE calls them. 
3. Simulate various grades of anomalies and verify that detector is working fine
4. Integrate the anomaly detector with Kibana's alerts ([previously discussed here](/blog/metal-to-alerts-with-aws-iot-elasticsearch-kibana))


### Simulated Smart Grid Sensor

We will simulate a sensor suitable for use with the medium voltage (MV) transmission grid with the following hypothetical specifications:

- Voltage between 23kV and 25kV
- Current between 0A and 600A
- Temperature between 30C and 100C
- Humidity between 20% and 80%

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

Like before, we will start our simulator to inject sensor data into ElasticSearch. I simulated 21 sensors with about 20000 data points spread across 6 months and then started a script to inject data every 10s. 

```python
current = random.uniform(0.0,600.0)
voltage = random.uniform(23000.0,25000.0)
temperature = random.uniform(30,100)
humidity = random.uniform(20.0,80.0)
```

The injected data looks a bit like this:

![Nominal Current Timeseries Chart](/images/es_cvs_timeseries_good.png)


### Initialisation / Training

With historical data in place and fresh data coming in regularly, I configured a detector to track the `max()` of our four metrics using [this guide](https://opendistro.github.io/for-elasticsearch-docs/docs/ad/#get-started-with-anomaly-detection) from the documentation.

![Anomaly Detector Configuration](/images/es_anomaly_detector_configuration.png)


- I picked `Detector Interval = 5 minutes` and `Window Delay = 1 minute` 
  - The documentation suggests smaller intervals make the system more real-time but consume more CPU, which sounds about right.
- You are allowed to add up to 5 features per detector - this seems to be an ODFE limitation rather than that of  the RCF algorithm itself.
- Once configured, the detector took about 15 minutes to initialise and go live.
- I made the mistake of trying to enable the detector on a `t2.small` instance and kept running into an `unknown error`. Should have RTFM first :-). 


### Simulating Anomalies

Now for the fun bit, I simulated anomalies in about 60% of the data points using the following snippet:


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
    error = False
    current = random.uniform(0.0,600.0)
    voltage = random.uniform(23000.0,25000.0)
    temperature = random.uniform(30,100)
    humidity = random.uniform(20.0,80.0)
```

The resulting timeseries charts, in their glorious randomness, look like this:

![Anomalous Metrics Timeseries Charts](/images/es_cvs_timeseries_bad.png)


### Detecting Anomalies

With our anomalous data streaming in, the detector catches the anomalies within 1 time interval

### Integrating Alerts


### Caveats

In my first attempt at building the detector, I used the `avg()` function on the features instead of `max()`. Post initialisation, I injected two kinds of anomalous data with very different results.

#### Consistently Out of Band Values 

```python
current = 1000
voltage = 100000
temperature = 300
humidity = 150
```

With these values, the anomaly detector worked perfectly and caught all the anomalies as seen below.

![Anomaly Detection History](/images/es_anomaly_history_bad.png)

#### Sporadically Out of Band Values

```python
r = random.randint(1,5)
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
else:
    current = random.uniform(0.0,600.0)
    voltage = random.uniform(23000.0,25000.0)
    temperature = random.uniform(30,100)
    humidity = random.uniform(20.0,80.0)
```

Making about 40% of the data anomalous seemed to trip up the detector. As the screenshot below shows, even though the average current value is well above the _normal_ levels, the detector does not consider this to be an anomaly. I am digging into this further to understand where this stems from - the algorithm or the `interval` configuration. For now, using `max()` instead of `avg()` for the features in `Detector Configuration` seems to result in our expected behaviour. 

![Anomaly Detection History](/images/es_anomaly_history_random.png)

This reminds me of the old joke,

> Things will not be easy at first, but over time you will get used to it. 

## Conclusions

ElasticSearch and Kibana are large, commendable feats of engineering that power everything from our search engines to our on-demand taxi services. The stack's versatility is clear from its suitability for time-series data too. 

When comparing QuickSight, Grafana and ElasticSearch+Kibana, we would recommend:

**Timestream + QuickSight** if you
  - prefer costs that more linearly scale with use
  - prefer using AWS in-house offerings
  - have data in multiple data sources that you need to analyse without duplication
  - don't need to visualise geospatial data

**Timestream + Grafana** if you
  - need timeseries charts and alerts
  - need gorgeous dashboards with easy (time) filtering
  - don't need to create complex BI style analyses across multiple data sources
  - don't need anomaly detection

**ElasticSearch + Kibana** if you
  - need flexibility in the type of charts and analyses
  - need anomaly detection
  - need to index and search text data too
  - don't mind duplicating your data into ElasticSearch
  - don't mind paying fixed monthly costs for your instance
  - have the ability to secure and monitor your ES instance

## Ideas, questions or corrections?

_We design & manufacture self-powered current/temperature/humidity sensors suitable for industrial and grid applications. Contact us for details._

Write to us at [hello@iotready.co](mailto:hello@iotready.co)
