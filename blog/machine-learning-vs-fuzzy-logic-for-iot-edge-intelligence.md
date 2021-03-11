---
title: Excited by Machine Learning for intelligence at the edge? Make sure it's the right tool for your job.
excerpt: >-
  IoT devices can generate a lot of data, and of course there is a natural interest to apply machine learning techniques to look for trends and patterns. Of course, we have plenty of tools up in the cloud, and it is certainly possible to build a solution this way for some use cases.
date: '2021-03-10'
thumb_image: images/BlockDiagram.png
image: images/BlockDiagram.png
layout: post
--- 


IoT devices can generate a lot of data, and of course there is a natural interest to apply machine learning techniques to look for trends and patterns. Of course, we have plenty of tools up in the cloud, and it is certainly possible to build a solution this way for some use cases.

The next obvious thought is to wonder if some of this machine learning can't be sent down to the IoT device. The benefits are clear, cut down on the amount of information that has to be transmitted up into the cloud and improve the processing latency.

This has led to attempts to compute models in the cloud, but execute them on the IoT device, to use reduced resolution and other ideas to shrink the model and so on. The paper [Machine Learning at the Network Edge: A Survey](https://arxiv.org/abs/1908.00080) provides a survey of current efforts at implementing machine learning at the network edge.

A lot of this effort is driven by the success of ML in areas such as image and video processing, pattern classification etc.

The question is, are these useful capabilities for your application ? Is ML the best way to solve typical industrial IoT problems ? 

In more than one previous article, I have touched on the importance of the ability for a degree of local control and visibility at the edge for many IoT systems, particularly those in industrial automation. The ability for local computation enables the generation of semantically more powerful information (eg a signal's slope rather than a stream of raw data) and the ability to act on and communicate conditions and actions through local display.

I believe that there are large classes of problems in the industrial automation space, where not only is machine learning not the best answer, but in some instances, lacks the capability to meet the needs of the problem.

Let's take a popular application space in industrial control - diagnostics. Some simple observations about the characteristics of such problems that can make it difficult to apply ML and to suggest why alternate approaches may provide better results.

1) Most problems at this level have a basis in a physical process which require stateful model(s) for the diagnostic process so you are often looking at a problem of feature extraction coupled with managing model state rather than a problem of merely looking for correlation/inference.

3) Pure ML isn't built to handle state information, state transitions, or to provide for easy tuning of correlation or inference logic with 
customer friendly Domain Specific Language (DSL) interfaces etc.

4) Diagnostic logic is often rule based, a natural outcome of how human's diagnose systems and is often tweaked and updated. There is no easy way to provide a user friendly domain specific language to express rules in with ML. 

5) Practical diagnostic rules are often expressed with "soft logic" (eg somewhat, mostly etc). Capturing this with ML is not really possible.

6) A typical problem breaks down into understanding the underlying physical models, tapping into or creating the sensors to detect deviations in system operation from "nominal" behavior, (these are often simple statistical signal processing blocks) and then providing a rule based or fuzzy logic / Bayesian estimation engine that can use these signals to confirm a hypothesis that there has been a failure in some part of the system.

7) Finite State Machines's and path tracing are a often the best way to model and capture failure modes such as degradation etc.

To help illustrate these points, we are going to look at a well known problem in an environment with limited communication to the IoT device and limited compute capability. The application we are going to look at is the diagnosis of plugged impulse lines for a pressure transmitter. 

[Pressure transmitters such as this example](https://www.emerson.com/resource/image/1272634/portrait_ratio3x4/768/1024/5b5bdf8916ba63cce3030491d3e84dd6/Gm/prod-rmt-p3051s.jpg) are used across a broad range of measurement problems. In most cases, the transmitter is usually somewhat remote from the point at which the pressure to be measured is tapped. The pressure signal is conveyed to the transmitter through thin piping, called an impulse line. Impulse lines can for example, freeze in cold weather, become obstructed by deposits etc thus masking the real pressure on the process side from the transmitter that is trying to measure them. Sometimes this discrepancy is only noticed when a control action that should change the value occurs and the transmitter reports no change. The ability to detect plugging at the transmitter is clearly desirable.

So how do we approach this problem ? The first step is to review the physics of the problem. For example, a constricted pipe effectively functions like a resistor in an electronic circuit and attenuates the pressure signal. Similarly clogging in a long impulse pipe can act as a fluid inertia device ie the equivalent of an inductance.By experimental observation one can characterize signal waveforms into five classes. This classification could be a candidate for ML, but the problem is simple enough that one can address it with simple statistics.

We can now use these signal classifications as input into a simple set of rules that can be used to infer the probably underlying cause for the characteristics occurring in the signal. The figure below shows you examples of these signal types.

![Signal types](/images/SignalTypes.png) 
<p style="text-align: center;font-size:90%"><i>(from US6017143) </i></p>

The transmitter doesn't function in a stand-alone environment. While it receives process signals via its pressure sensor, it also receives process events generated by the signal characteristic analysis described above as well as potentially control signals due to changes in the process being monitored. Managing the interplay between these varied information sources it turns out is best handled by sets of rules developed through an engineering analysis. It turns out that fuzzy logic is a good candidate to handle the "soft logic" that is the usual outcome of the engineering analysis.

A block diagram of the architecture is shown below. The only additional feature to point out is the handling of the configuration that is necessary to permit the transmitter algorithms to self adjust to the process it is installed in. When first installed, or for example, when a set-point change occurs in a system, the transmitter must adjust itself to the new "normal" process signal features. The requires a short learning period to establish baseline parameters for the signal classification.

![Block diagram](/images/BlockDiagram.png)
<p style="text-align: center;font-size:90%"><i>(from US6017143) </i></p>

The result is a compact solution to a real process automation problem, that runs in a highly power and compute constrained device for which a pure ML based solution would not be an option. If you want to know more details, you can look here [US6017143](http://patft.uspto.gov/netacgi/nph-Parser?Sect1=PTO1&Sect2=HITOFF&d=PALL&p=1&u=%2Fnetahtml%2FPTO%2Fsrchnum.htm&r=1&f=G&l=50&s1=6017143.PN.&OS=PN/6017143&RS=PN/6017143).

