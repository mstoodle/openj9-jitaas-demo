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

sudo docker pull adoptopenjdk/openjdk8-openj9:jdk8u181-b13_openj9-0.9.0
sudo docker pull telegraf
sudo docker pull influxdb:1.0.0
sudo docker pull mongo
sudo docker pull grafana/grafana:5.1.0

echo Building jmeter client for server_hotspot
cd AcmeAir_hotspot	&& ./build_jmeter_hotspot.sh	&& cd ..

echo Building jmeter client for server_openj9
cd AcmeAir_openj9	&& ./build_jmeter_openj9.sh	&& cd ..

echo Building jmeter client for server_nojit1
cd AcmeAir_nojit1	&& ./build_jmeter_nojit1.sh	&& cd ..

echo Building jmeter client for server_nojit2
cd AcmeAir_nojit2	&& ./build_jmeter_nojit2.sh	&& cd ..

echo Building openj9 for jitserver now
pushd ../openj9
./build_openj9.sh --fetch-repos
popd

echo Building jitserver
cd jitserver		&& ./build_jitserver.sh		& cd ..
