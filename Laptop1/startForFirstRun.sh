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

if [[ "$1" == "--help" ]]; then
	echo 'Usage: startForFirstRun.sh [<openj9 container size> <openj9 nojit container size>]'
	exit 1
fi

if [[ $# == 3 ]]; then
	OPENJ9_CONTAINER_SIZE=$2
	OPENJ9_NOJIT_CONTAINER_SIZE=$3
else
	OPENJ9_CONTAINER_SIZE=256m
	OPENJ9_NOJIT_CONTAINER_SIZE=256m
fi
echo Using container sizes:
echo "    OpenJ9       : $OPENJ9_CONTAINER_SIZE"
echo "    OpenJ9 NOJIT : $OPENJ9_NOJIT_CONTAINER_SIZE and $OPENJ9_NOJIT_CONTAINER_SIZE"

echo Starting telegraf monitor
./run_telegraf.sh

echo In 10 seconds, jitserver is expected to be available!
sleep 10

echo Starting server_nojit1
./run_server_nojit1.sh $OPENJ9_NOJIT_CONTAINER_SIZE

echo Starting server_openj9
./run_server_openj9.sh $OPENJ9_CONTAINER_SIZE
