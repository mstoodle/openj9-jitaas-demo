# Welcome to the OpenJ9 JIT as a Service Demo !

This repository will soon be populated with scripts and documentation so that you can try out the JIT as a Service demo I gave at the Oracle Code One conference Oct 22-Oct 25 using 100% open source projects!

In that demo, I showed 3 configurations of the OpenLiberty application server running the AcmeAir JavaEE7 flight reservation system benchmark: 1) OpenJDK8 with Hotspot (which has a JIT :) ), 2) OpenJDK8 with Eclipse OpenJ9 (using its JIT), and 3) OpenJDK8 with Eclipse OpenJ9 but using a remote JIT service that runs on a second machine. Each server is given the same constrained environmnent to operate in: 256MB of memory and 0.5 cores. Because OpenJ9 uses memory so efficiently and the remote JIT reduces the transient peformance impacts of a JIT compiler, I actually ran two OpenLiberty servers in the third configuration but each one still has the same environment (so that configuration does use 1.0 cores so these are not "drop-in" replacement configurations).

The result of the demo shows that moving the JIT compiler out of the JVM to operate as an independent cloud service allows JVM servers to spend their cycles and memory more completely on the workload they were built for. That can mean more efficient ramp -up because JIT compilation tends to be a very CPU and memory intensive activity that primarily happens in the early stages of server start-up and application ramp-up.

The advantage of having a JIT service rather than using something like Ahead of Time (AOT) compilation techniques is that the JIT service is still operating at the same time as the Java application, which means that it can still employ all the speculative and profile-based optimizations that JVMs have become known for. Solutions that only rely on AOT compilation will be hard pressed to deliver the same levels of performance that, let's face it, we've all come to expect from the JVM.

This demo shows 2 JVMs taking advantage of a remote JIT server. But we're only at the beginning of this journey. Imagine a scenario involving 10s or even 100s of microservices, all with their own JVM and their own JIT compiler. The first stage, which this prototype demonstrates, is to collect all that JIT workload to a single place and free the JVMs from having to do all the work themselves. The second phase is to better optimize that JIT workload so that we don't have to do N times the work to support N JVMs. Finally, we can start to employ machine learning and more strenuous optimization techniques now that JIT resources are no longer tied to the runtime "footprint" of the application. We can afford to collect more rich profile data because we can spread the overheads across a larger number of JVMs so no one JVM pays too high a price.

Let's start to make the JVM an essential part of the cloud that makes the cloud the most effective way to deploy Java applications!

The demo is coming soon! Stay tuned!
