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


if [[ $# > 0 ]]; then
	CONTAINER_SIZE=$1
else
	CONTAINER_SIZE=256m
fi
echo "Hotspot server1 using container size $CONTAINER_SIZE"
sudo docker run -d --rm \
    --network=host \
    --cpuset-cpus=1 \
    --cpus=0.5 \
    --memory=$CONTAINER_SIZE --memory-swap=$CONTAINER_SIZE \
    -p 192.168.0.10:9090:9090 \
    -v $PWD/server_output_hotspot:/output \
    --name server_hotspot server_hotspot
