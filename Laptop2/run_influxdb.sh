# Copyright (c) 2018, 2018 IBM Corp. and others
#
# This program and the accompanying materials are made available under
# the terms of the Eclipse Public License 2.0 which accompanies this
# distribution and is available at https://www.eclipse.org/legal/epl-2.0/
# or the Apache License, Version 2.0 which accompanies this distribution and
# is available at https://www.apache.org/licenses/LICENSE-2.0.
#
# This Source Code may also be made available under the following
# Secondary Licenses when the conditions for such availability set
# forth in the Eclipse Public License, v. 2.0 are satisfied: GNU
# General Public License, version 2 with the GNU Classpath
# Exception [1] and GNU General Public License, version 2 with the
# OpenJDK Assembly Exception [2].
#
# [1] https://www.gnu.org/software/classpath/license.html
# [2] http://openjdk.java.net/legal/assembly-exception.html
#
# SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
#


#export HOST=127.0.0.1
export HOST=192.168.0.11
sudo docker run --rm -d \
    --network=host \
    --cpuset-cpus=0 \
    -v $PWD/influxdb.conf:/etc/influxdb/influxdb.conf:ro \
    --name influxdb influxdb:1.0.0 -config /etc/influxdb/influxdb.conf

sleep 1

# Make sure jmeter database is there
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+DATABASE+%22jmeter%22"

# Sum throughput for two nojit containers
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_sum_1%22+ON+%22jmeter%22+BEGIN+SELECT+sum(%22value%22)+AS+%22jmeter1%22+INTO+%22jmeter_sum%22+FROM+%22jmeter_nojit1.all.a.count%22+GROUP+BY+time(1s)+END&db=jmeter"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_sum_2%22+ON+%22jmeter%22+BEGIN+SELECT+sum(%22value%22)+AS+%22jmeter2%22+INTO+%22jmeter_sum%22+FROM+%22jmeter_nojit2.all.a.count%22+GROUP+BY+time(1s)+END&db=jmeter"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_sum_3%22+ON+%22jmeter%22+BEGIN+SELECT+mean(jmeter1)%2Bmean(jmeter2)+AS+jmeter_nojit_both+INTO+jmeter_sum+FROM+%22jmeter_sum%22+GROUP+BY+time(1s)+END&db=jmeter"

# Make sure server_docker_metrics database is there...
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+DATABASE+%22server_docker_metrics%22"

# Sum memory for two nojit containers
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_memsum_1%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(%22total_rss%22)+AS+%22mem1%22+INTO+%22mem_sum%22+FROM+%22docker_container_mem_docker%22+WHERE+(time+%3E+now()+-+12h+AND+container_name+%3D+%27server_nojit1%27)+GROUP+BY+time(10s)+END&db=server_docker_metrics"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_memsum_2%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(%22total_rss%22)+AS+%22mem2%22+INTO+%22mem_sum%22+FROM+%22docker_container_mem_docker%22+WHERE+(time+%3E+now()+-+12h+AND+container_name+%3D+%27server_nojit2%27)+GROUP+BY+time(10s)+END&db=server_docker_metrics"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_memsum_3%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(mem1)+%2B+mean(mem2)+AS+mem_nojit_both+INTO+server_docker_metrics.autogen.mem_sum+FROM+server_docker_metrics.autogen.mem_sum+GROUP+BY+time(10s)+END&db=server_docker_metrics"

# Sum CPU for two nojit containers
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_cpusum_1%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(%22usage_percent%22)+AS+%22cpu1%22+INTO+%22cpu_sum%22+FROM+%22docker_container_cpu_docker%22+WHERE+(time+%3E+now()+-+12h+AND+container_name+%3D+%27server_nojit1%27)+GROUP+BY+time(10s)+END&db=server_docker_metrics"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_cpusum_2%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(%22usage_percent%22)+AS+%22cpu2%22+INTO+%22cpu_sum%22+FROM+%22docker_container_cpu_docker%22+WHERE+(time+%3E+now()+-+12h+AND+container_name+%3D+%27server_nojit2%27)+GROUP+BY+time(10s)+END&db=server_docker_metrics"
curl -X POST "http://192.168.0.11:8086/query?q=CREATE+CONTINUOUS+QUERY+%22cq_cpusum_3%22+ON+%22server_docker_metrics%22+RESAMPLE+EVERY+1s+FOR+12h+BEGIN+SELECT+mean(cpu1)+%2B+mean(cpu2)+AS+cpu_nojit_both+INTO+server_docker_metrics.autogen.cpu_sum+FROM+server_docker_metrics.autogen.cpu_sum+GROUP+BY+time(10s)+END&db=server_docker_metrics"
