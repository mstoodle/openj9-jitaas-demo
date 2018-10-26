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

# Pull docker containers that are needed
sudo docker pull ubuntu:16.04			# openj9 build containers use ubuntu16.04
sudo docker pull telegraf			# used to collect memory/CPU metrics from docker containers
sudo docker pull open-liberty:webProfile7	# OpenLiberty server
sudo docker pull adoptopenjdk/openjdk8		# used to run OpenJDK8 with Hotspot JVM

# download all openjdk, openj9, and omr repos
pushd ../openj9

# Fetch OpenJDK extensions project for JDK8
git clone https://github.com/ibmruntimes/openj9-openjdk-jdk8
cd openj9-openjdk-jdk8

# needed this temporarily while openssl issues are worked out
# Live demo at Code One did use this particular commit
#git checkout 1ba8f1a08bdf67590fabbb0b4a57195da97dd2ef

# will download latest openj9 and omr code on the jitaas branch
bash ./get_source.sh -openj9-branch=jitaas -omr-branch=jitaas

# make sure we have everything for j9 build environment set up in a docker container called 'openj9'
sudo docker build -f openj9/buildenv/docker/jdk8/x86_64/ubuntu16/Dockerfile -t=openj9 .

# This will build the container that will be used for all servers that use OpenJDK8 with OpenJ9 JVM
sudo docker build -f Dockerfile_build_openj9 -t=build_openj9 .

# Make SDKs available to the server containers
cd ..
./build_openj9.sh
cd ../hotspot
./get_hotspot.sh

popd

# Build each of the OpenLiberty server containers
cd server_openj9	&& ./build_server_openj9_newCache.sh	&& cd ..
cd server_nojit1	&& ./build_server_nojit1_newCache.sh	&& cd ..

sudo docker network create my-net
