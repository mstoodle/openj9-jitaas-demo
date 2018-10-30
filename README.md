# Welcome to the OpenJ9 JIT as a Service Demo !

This repository contains scripts and documentation so that you can try out the JIT as a Service demo I first showed at the Oracle Code One conference Oct 22-Oct 25 using 100% open source projects!

In that demo, I showed 3 configurations of the OpenLiberty application server running the AcmeAir JavaEE7 flight
reservation system benchmark that mostly differ in their JVM configuration: 1) OpenJDK8 with the Hotspot JVM
(which obviously has a JIT compiler inside :) ), 2) OpenJDK8 with the Eclipse OpenJ9 JVM (using its JIT), and
3) OpenJDK8 with Eclipse OpenJ9 JVM but using a remote JIT service that runs on a second machine. Each server
is given the same constrained environmnent to operate in: 256MB of memory and 0.5 cores. Because OpenJ9 uses
memory so efficiently and the remote JIT reduces the transient peformance impacts of JIT compilation, I
actually ran two OpenLiberty servers in the third configuration but each one still has the same environment
(that configuration therefore  uses 1.0 cores so these are not "drop-in" replacement configurations).

Below are the instructions for setting up this demo on two computers called `Laptop1` and `Laptop2` .

# How to start

Start by cloning this repository onto each machine, and then cd into the appropriate directory (`Laptop1` on the machine where you
want to run the OpenLiberty servers, and `Laptop2` where you want to run the JIT service, the databases, and the monitoring
infrastructure.  You'll then have to run the appropriate configuration steps on each server in order to get things going. The
sections below show what you need to do.

The scripts in this repository assume:
. Laptop1 is 192.168.0.10
. Laptop2 is 192.168.0.11

At the moment, youll have to do a recursive grep to find the references to those IP addresses to change them if you're running on
different IP addresses. It shouldn't be too hard to make it easier to set up the server IPs, but that didn't make it into this
version of the demo.

`Laptop1` is where all the OpenLiberty servers run using 3 different colour coded configurations:

Orange uses OpenJDK8 with Hotspot JVM								(server_hotspot)
Blue uses OpenJDK8 with Eclipse OpenJ9 JVM							(server_openj9)
Green uses two "nojit" servers with OpenJDK8 and Eclipse OpenJ9 and a remote JIT service	(server_nojit1, server_nojit2)

`Laptop2` is where the JIT server runs as well as the databases and JMeter load drivers operate.

The recommended demo creation steps are (notice you'll have to run scripts at different time on each machine) detailed below.
The A steps are required to build the shared classes caches and then save them into the docker containers. It can be done
with docker volumes, but I chose to actuall embed the generated caches into the Docker containers and that's why the A steps
are more complicated than one might imagine. Once the caches are generated, you only have to run the much simpler B sequence
to actually run the demo. For the Code One demo, I ran A1 through A8 well before the keynote. I ran B1 through B6 on stage
just before the keynote started (so the servers had been up and running for 20 minutes before I even came on stage), and I
only had to run B7 (by pressing `<return>` on the pre-typed command) during the demo segment of the keynote.

Here are the setup steps in order:

```
	Laptop 1					Laptop 2
A1.	$ ./buildForFirstRun.sh				$ ./buildAll.sh
	[ will take a long time ]			[ will take a long time ]
A2.							$ ./startForFirstRun.sh
A3.	$ ./startForFirstRun.sh
A4.	[run sudo docker stats and wait until activity
	 on servers dies down to around 1-2% ish
	 levels, then ctrl-C out of docker stats]
A5.							$ ./applyLoadForFirstRun.sh
A6.							[ wait until run completes or at least about 5 minutes ]
A7.	$ ./stopAll.sh					$ ./stopAll.sh
A8.	$ ./buildAll.sh
```

At this point, the demo has been completely built and these 'A' steps should not need to be repeated. The following
steps are how you run the demo once it has been built:

```
B1.							$ ./startAll.sh
B2.							Open in browser: http://Laptop2:3000
                    					                 [login: admin, password: admin]
B3.							Click on Acmeair Jit as a Service Demo dashboard
B4.	$ ./startAll.sh
B5.	$ sudo docker stats
B6.	(wait until activity on all servers dies down
	 then you can exit docker stats if you like
	 but often useful to make sure activity is
	 as expected)
B7.							$ ./applyLoadAll.sh
B8. 				[ wait until run completes or you want to stop ]
B9.	$ ./stopAll.sh
B10.							$ stopAll.sh
```

# A few more details about the scripts

The script `buildForFirstRun.sh` will download and build all the docker containers and JVMs needed on Laptop1 for a "first run". In
the first run, only the `server_openj9` and `server_nojit1` servers will be built and started. The purpose of this first run is to
populate the shared classes caches for these two servers. These runs will not perform as well as subsequent runs will perform.

`startForFirstRun.sh` will start `server_openj9` and `server_nojit1` so they will be ready for a first run. It will pause for
10 seconds to make sure you have started the `jitserver` on Laptop2 before it tries to start `server_nojit1`. Once started and the
CPU activity for both servers has gone down to 1-2% levels (use `docker stats`), you should run `applyLoadForFirstRun.sh` on Laptop2
and go through a full run to make sure the shared class caches are filled by a complete run. When the run is finished, you can run
`stopAll.sh` and it will stop all the docker containers (note: this script will also try to stop containers that weren't started in
the first run, but don't worry about the messages you'll see).

`buildAll.sh` will rebuild `server_openj9`, `server_nojit1`, and `server_nojit2` and will copy the shared caches generated
in the first run into these three servers' docker containers.

`startAll.sh` will fire up all 4 servers and will wait 10 seconds before starting `server_nojit1` and `server_nojit2` in case you
have not yet started `jitserver` on Laptop 2. Once started, and the CPU activity for all servers has gone down to 1-2% levels (use
`docker stats`), you are ready to run `applyLoadAll.sh` on Laptop2 to do the full run.

If you want to run individual servers, you can look at `run_<server name>.sh` . The `_newCache` versions of these scripts are
designed to be used to generate a new shared classes cache and will remove any existing shared classes cache for their server.

The `run_telegraf.sh` script starts up the Telegraf monitoring service which will report docker container stats on Laptop1
into an influx database on Laptop2 using the database names `server_docker_metrics` and `server_vm_metrics` .

The `run_influxdb.sh` script starts up the InfluxDB instance used to store all the monitoring data from Telegraf and from JMeter.

The `run_grafana.sh` script starts up the Grafana software so that you can connect to it at the browser at http://localhost:3000
and with username `admin` password `admin`.

...

# What it should look like

![Full 20 minute run result](https://github.com/mstoodle/openj9-jitaas-demo/blob/master/CodeOne_Final.png)

The result of the demo shows that moving the JIT compiler out of the JVM to operate as an independent cloud service allows]
JVM servers to spend their cycles and memory more completely on the workload they were built for. That can mean more efficient
ramp -up because JIT compilation tends to be a very CPU and memory intensive activity that primarily happens in the early
stages of server start-up and application ramp-up.

The advantage of having a JIT service rather than using something like Ahead of Time (AOT) compilation techniques is that
the JIT service is still operating at the same time as the Java application, which means that it can still employ all the
speculative and profile-based optimizations that JVMs have become known for. Solutions that only rely on AOT compilation
will be hard pressed to deliver the same levels of performance that, let's face it, we've all come to expect from the JVM.

This demo shows 2 JVMs taking advantage of a remote JIT server. But we're only at the beginning of this journey. Imagine
scenarios involving 10s or even 100s of microservices, all with their own JVM and their own JIT compiler. The first stage,
which this prototype demonstrates, is to collect all that JIT workload to a single place and free the JVMs from having to do
all the work themselves. The second phase is to better optimize that JIT workload so that we don't have to do N times the
work to support N JVMs. Finally, we can start to employ machine learning and more strenuous optimization techniques now that
JIT resources are no longer tied to the runtime "footprint" of the application. We can afford to collect more rich profile
data because we can spread the overheads across a larger number of JVMs so no one JVM pays too high a price.

Let's start to make the JVM an essential part of the cloud that makes the cloud the most effective way to deploy Java applications!
