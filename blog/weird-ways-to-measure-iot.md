---
title: More from the X-Files… Weird ways to solve IoT measurement problems
excerpt: >-
  No, not those X-Files. I am talking about those interesting measurement stories where we were, like Mulder and Scully desperately seeking a solution to a complicated problem.back-end.
date: '2020-11-07'
thumb_image: images/biogas_user.jpg
image: images/biogas_user.jpg
layout: post
---

No, not those X-Files. I am talking about those interesting measurement stories where we were, like Mulder and Scully desperately seeking a solution to a complicated problem. In our case to measure variable X, and it was only by a combination of engineering and modeling and lateral thinking like our heroes, where we were able to measure our X, not directly, but in terms of a proxy measurement Y.

In an earlier article I introduced you to the idea of proxy measurements, and why they can, when appropriate save you both time and money. Actually it turns out that they are very appropriate - every client wants you to save time and money.

More seriously though, a clever proxy measurement can make the difference between having a product and not.

So here is a neat example.

The customer was a new startup that was targeting the large deficit of energy in rural India. For all the usual reasons, poor infrastructure, insufficient generation and inefficient revenue generation, there were few solutions. The biggest need for energy in this rural population was for household cooking fuel. The startup through extensive work in the field, realized that with a careful selection of target customers, a re-thinking of the technologies needed and attention to the business model, a possible solution existed for at least one segment of the rural population.

The target was the small farmer with two or three cows on the farm. About half of rural households own cattle. Cattle waste is often dried and used as fuel, but burning this is an inefficient way to generate energy. The idea was old - generate biogas, but the implementation was new. Instead of the traditional (and expensive) biogas fermenter which needs cement, bricks and quite extensive construction, the startup invented a pre-fabricated, flexible, pvc coated fabric bag based biogas plant. Installing one required only two days to dig a shallow pit to hold the bag and setting up a feed and waste overflow system. An integral part of the business model was the commercialization of the bio-fertilizer that was a byproduct of the fermentation process. Generated gas was piped directly to the household stove through pipes.

Inside the house, the gas was filtered and pressurized with an inexpensive pump that generated the necessary pressure for the gas stove.

An important part of the economic model was the ability to measure the gas consumed by the cooking stove. The problem was that there were no cheap enough and reliable enough pressure or flow sensors to meet the pricing constraints that the startup needed to meet. No “X” (gas consumption) measurement - no money.

We took a step back. The problem was not just a gas measurement that was required, but a mechanism to communicate weekly or monthly gas consumptions back to the startup for billing. Cellular infrastructure was spotty to say the least, and even when it was present the combination of GPRS hardware and communication costs would even further worsen the product budget.

My colleagues and I have long talked about building practical IoT systems, and some of the design features and principles that we believe will be essential to success in building these kinds of systems, particularly in low resource applications. (Towards a Practical Architecture for Internet of Things: An India-centric View)

One of the principles we talk about is that it’s not really the IoT (Internet of Things) but the IoPT (The Internet of People and Things). For multiple reasons - cost, resilience, business models, etc, people are fundamental components of a viable IoT system.

So here are the aha’s that finally allowed us to meet our goals.

* Since the components are all standardized, gas flow rates can be measured on the product at the factory, and only a one time flow measurement needs to be taken. The pump provides a constant volume of gas at a nominal pressure head that is sufficient to operate the cooking stove.
* The amount of gas used under these conditions is therefore directly related to the amount of time that the pump is operating.
* We can measure the amount of time that the pump runs by simply connecting a low cost data logger in line with the pump to measure the cumulative operating time.
* Since there is a field operative who visits every couple of weeks to service the waste composter and take away the slurry, we actually have a communication channel back to headquarters.
* A simple app on the field operative’s phone that retrieves the operating time from the data logger via BLE and resets the data logger enables billing information to be collected and then aggregated back at the main service centre.

And this is what the final system architecture looked like..

![gas measurement](/images/proxy_biogas_measurement.jpg)

We ended up with a low cost gas consumption measurement capability, a reliable way to capture data for billing purposes, and a process, that by using a human in the loop, provided a level of reliability that would have been hard to achieve with a more technical IoT solution.

In this case our proxy measurement scheme yielded a whole lot more than just the value of “X” !
