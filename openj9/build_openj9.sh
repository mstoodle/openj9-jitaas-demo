#!/bin/bash -f
#
# Copyright (c) 2017, 2018 IBM Corp. and others
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

# Usage:
#  $ build_openj9.sh [--fetch-repos] [--noclean]
#    --fetch-repos    downloads all repositories from scratch, WILL ERASE EXISTING openj9-openjdk-jdk8 directory
#    --noclean        do not run "make clean" before building OpenJDK8 with OpenJ9
#
 
if [[ "$1" == "--fetch-repos" ]]; then
	shift
	rm -rf openj9-openjdk-jdk8
	# get and build the openj9 default build container
	git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8
	cd openj9-openjdk-jdk8
	bash ./get_source.sh -openj9-branch=jitaas -omr-branch=jitaas
	sudo docker build -f openj9/buildenv/docker/jdk8/x86_64/ubuntu16/Dockerfile -t=openj9 .
	cd ..
fi

# Create the jitaas build enviroment on top of openj9's container
sudo docker build -f Dockerfile_build_openj9 -t=build_openj9 .

# Full build of OpenJDK8 with Openj9
if [[ $? == 0 ]]; then
	sudo docker run -v $PWD/j2sdk-image:/openj9-openjdk-jdk8/build/linux-x86_64-normal-server-release/images/j2sdk-image -it build_openj9 $1
fi
