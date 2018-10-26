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

if [[ "$1" == "1c" ]]; then

    echo "Using 1 core (3)"
    sudo docker run -d --rm \
        --network=host \
        --cpuset-cpus='3' \
        -p 38400:38400 \
        -v $PWD/jitserver_output_1c:/output \
        --name jitserver jitserver 

elif [[ "$1" == "2c" ]]; then

    echo "Using 2 cores (2,3)"
    sudo docker run -d --rm \
        --network=host \
        --cpuset-cpus='2,3' \
        -p 38400:38400 \
        -v $PWD/jitserver_output_2c:/output \
        --name jitserver jitserver 

elif [[ "$1" == "3c" ]]; then

    echo "Using 3 cores (1,2,3)"
    sudo docker run -d --rm \
        --network=host \
        --cpuset-cpus='1-3' \
        -p 38400:38400 \
        -v $PWD/jitserver_output_3c:/output \
        --name jitserver jitserver 

else

    echo "Using 4 cores (0,1,2,3)"
    sudo docker run -d --rm \
        --network=host \
        --cpuset-cpus='0-3' \
        -v $PWD/jitserver_output_4c:/output \
        -p 38400:38400 \
        --name jitserver jitserver 

fi
