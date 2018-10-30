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
# Note: mongorestore's --port option works differently than mongo's --port option
#       mongorestore is --port=N whereas mongo is --port N  (yay!)


if [[ "$1" == "--no-hotspot" ]]; then
	echo No hotspot server will be started
	shift
else
	echo Starting mongo db for server_hotspot
	sudo docker run --rm -d \
	    --network=host \
	    --cpuset-cpus=0 \
	    -v $PWD/acmeair_hotspot:/tmp/acmeair \
	    --name mongo_hotspot mongo --nojournal --port 27017
	sleep 2
	sudo docker exec -it mongo_hotspot mongorestore --port=27017 --drop /tmp/acmeair
fi

if [[ "$1" == "--no-openj9" ]]; then
	echo No openj9 server will be started
	shift
else
	echo Starting mongo db for server_openj9
	sudo docker run --rm -d \
	    --network=host \
	    --cpuset-cpus=0 \
	    -v $PWD/acmeair_openj9:/tmp/acmeair \
	    --name mongo_openj9 mongo --nojournal --port 27117
	sleep 2
	sudo docker exec -it mongo_openj9 mongorestore --port=27117 --drop /tmp/acmeair
fi

if [[ "$1" == "--no-nojit1" ]]; then
	echo No nojit1 server will be started
	shift
else
	echo Starting mongo db for server_nojit1
	sudo docker run --rm -d \
	    --network=host \
	    --cpuset-cpus=0 \
	    -v $PWD/acmeair_nojit1:/tmp/acmeair \
	    --name mongo_nojit1 mongo --nojournal --port 27217
	sleep 2
	sudo docker exec -it mongo_nojit1 mongorestore --port=27217 --drop /tmp/acmeair
fi

if [[ "$1" == "--no-nojit2" ]]; then
	echo No nojit2 server will be started
	shift
else
	echo Starting mongo db for server_nojit2
	sudo docker run --rm -d \
	    --network=host \
	    --cpuset-cpus=0 \
	    -v $PWD/acmeair_nojit2:/tmp/acmeair \
	    --name mongo_nojit2 mongo --nojournal --port 27317
	sleep 2
	sudo docker exec -it mongo_nojit2 mongorestore --port=27317 --drop /tmp/acmeair
fi
