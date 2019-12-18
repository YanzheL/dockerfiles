#!/bin/bash
set -e
cd /opt/cruise-control
/bin/bash ${DEBUG:+-x} /opt/cruise-control/kafka-cruise-control-start.sh /opt/cruise-control/config/cruisecontrol.properties 8090
© 2019 GitHub, Inc.
