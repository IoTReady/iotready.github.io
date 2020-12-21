---
title: Weighty problems, Simple Solutions
excerpt: >-
  When you are building IoT systems, one of the more difficult (and not yet satisfactorily solved) problems is the establishment of the semantics of a measurement that an IoT device reports up the food chain.
date: '2020-11-07'
thumb_image: images/weighty.jpg
image: images/weighty.jpg
layout: post
---

When you are building IoT systems, one of the more difficult (and not yet satisfactorily solved) problems is the establishment of the semantics of a measurement that an IoT device reports up the food chain.

I was musing about some solutions that we had developed several years ago back at HP Labs, when I idly wondered, what is the most common measurement that we make, and why is it so common ?

I knew that in process automation, temperature and pressure are among the top measurements. I presumed that “presence” i.e. the opening or closing of a contact might be one of the top discrete measurements in factory automation.

Some weighty cogitation later (excuse the pun, it's going to be obvious in the next sentence), it struck me that there was one measurement that definitely was up there, and which had an immense number of interesting applications that arose out of measurements of this property. Yes, it's the simple act of weighing something.

Besides being a measurement that goes back to some of mankind’s earliest civilizations, weighing is interesting because of the ability to use it as a proxy for more interesting and complex measurements.

The concept of proxy measurements is easy to understand. Take measuring the rate of flow of liquid in a pipeline. Measure the pressure on either side of a constriction or narrowing in a pipeline. You will find that the rate of flow of fluid in the pipe is related to the difference in the pressure (actually to the square root). This way of measuring a flow is so common that some 20 odd percent of the market for flow measurement actually uses pressure as the underlying measurement. Why is that ? Well it's relatively inexpensive to get a high precision differential pressure measuring device, and your instrument is so simple, no moving parts.

Another example of a proxy measurement using pressure is measuring the level of fluid in a tank. Using a differential pressure transmitter with one side exposed to atmospheric pressure and one side exposed to the fluid through a tap at the bottom of the tank, allows us to measure the pressure exerted by the fluid in the tank (with atmospheric pressure compensated for). If we know the specific gravity of the fluid then a simple calculation tells us the height of fluid in the tank.

So here, using a pressure measurement as a proxy we have been able to measure both a flow in a pipe as well as the level of fluid in a tank. You can see why pressure is such a popular measurement.

So, let's return to weight. Fundamentally weight has always been of interest because it is an indication of the quantity of a thing. Whether it's weighing my gold nugget or the weight of an antibiotic tablet, weight is a fundamental way to determine value, consistency, fraud, decay, and failure among other characteristics.

We run across interesting solutions to problems that use weight as a proxy measurement when interacting with our customers. Here is an example of a design we came up with that I hope will illustrate the point..

The application was for a company that made home and community composting bins. The company had developed its own clay container based composting systems for home users and had subsequently branched out with specially designed, larger, plastic composters for communities. The brand was built around the idea of the ability of the individual or community to have an impact through their direct actions. Here is a picture of the type of composter for which this kind of solution can be easily incorporated / retrofitted.

![example composter](/images/example_compost.jpg)

While there was obvious physical feedback through watching waste go through the composting process and the creation of compost that an individual could use, the idea was to look for ways to show the impact on a larger scale, especially for larger groups like homeowner associations who might have specific recycling goals.

The proposed solution - a simple metal bodied scale, sized to fit under the composter. The low power sensing mechanism, built using best-in class low power chips and algorithms logged weight at periodic intervals with upwards of 1 year of battery life. Low power bluetooth communicated with a phone app that collected weight histories and reported them back for archiving. Simple logic that detected significant changes in weight were used to track the addition and removal of compost to the bin. This allowed calculations of diverted carbon (since composting avoids methane emissions that would be created if the material was put into a landfill - typically between 0.44-0.62 metric tons of carbon dioxide equivalent / ton of feedstock here in California for example).

Tracking weight allowed the generation of meaningful measures of impact and the possibility of encouragement by providing simple gamification tools like leaderboards.

Tracking how well composting is proceeding typically takes measurements of temperature and moisture. That is hard to do for these kinds of composters and a significant additional cost. Having a weight history opened up the possibility of using measurements of weight loss during composting as a proxy to provide insight into the composting process. Typical rules of thumb call for a reduction of about 50% in the moisture content of the incoming feedstock by the time the composting process is complete. Not bad for a weighing scale!

The moral of this story? Don’t be too quick to jump into making all those difficult and expensive measurements. A good proxy may save you time to market and yield a cheaper solution.

There are a couple of other interesting proxy based measurement solutions that we will talk about in a later article.

In the meanwhile, if you have an interesting measurement problem that you think could use some help, do drop us a note.
